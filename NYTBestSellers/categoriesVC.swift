//
//  CategoriesVC.swift
//  nyTimesBestSeller
//
//  Created by Kyle Ong on 10/1/16.
//  Copyright © 2016 Kyle Ong. All rights reserved.
//

import UIKit
import Alamofire

class CategoriesVC: UIViewController {
    
    //typealias categoryTuple = (categoryName: String, categoryCode: String)
    
    //Constants
    struct Constants{
        static let categoriesCell = "categoryTableViewCell"
    }
    
    //categoryList Names
    var categoriesList = [String]()
    //var categoriesCodeList = [String]()
    var filteredCategoriesList = [String]()
    var categoriesDict = [String : String]()
    var filteredCategoriesDict = [String : String]()
    
    var allCategoryIndex:Int = 0
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var searchBar: UISearchBar!
    
    
    //MARK: - View Load
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        self.navigationController?.navigationBar.titleTextAttributes = [ NSFontAttributeName: UIFont(name: "Times New Roman", size: 20)!]
        self.navigationController?.navigationBar.tintColor = UIColor.black
        
        //CHECK APP LAUNCH FIRST TIME AND HANDLE
        if UserDefaults.standard.bool(forKey: "launchedBefore") {
            loadData() //not first launch
        } else {
            UserDefaults.standard.set(true, forKey: "launchedBefore") // first launch
            UserDefaults.standard.synchronize()
            if hasConnectivity() {
                loadData()
            } else {
                let alert = UIAlertController(title: "Alert", message: "Internet Connection Required!", preferredStyle: UIAlertControllerStyle.alert)
                alert.addAction(UIAlertAction(title: "Okay", style: UIAlertActionStyle.default, handler: nil))
                self.present(alert, animated: true, completion: nil)
            }
        }
        
        configure()
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func configure(){
        registerNibs()
        sortDataAlphabetical()
        moveAllCategoryToIndexZero()
        tableView.delegate = self
        tableView.dataSource = self
        searchBar.delegate = self
        filteredCategoriesList = categoriesList
        setLogo()
    }
    
    func setLogo(){
        let logo = UIImage(named: "nytimes")
        let imageView = UIImageView(image: logo)
        self.navigationItem.titleView = imageView
    }
    
    func registerNibs(){
        tableView.register(UINib(nibName: Constants.categoriesCell, bundle: nil), forCellReuseIdentifier: Constants.categoriesCell)
    }

    
    //load category list data from local json
    func loadData() {
        
        self.categoriesList = [String]()
        self.categoriesDict = [String:String]()
        
        self.categoriesList.append("All")
        self.categoriesDict["All"] = ""
        //self.categoriesCodeList.append("")
        
        let fileLocation = Bundle.main.path(forResource: "names", ofType: "json")!
        let text : String
        do {
            text = try String(contentsOfFile: fileLocation)
        }
        catch {
            text = ""
        }
        
        if let dataFromString = text.data(using: String.Encoding.utf8, allowLossyConversion: false) {
            let json = JSON(data: dataFromString)
            
            let results = json["results"]
            for (_,myResult) in results {
                if let list = myResult["display_name"].string {
                    self.categoriesList.append(list)
                    if let listCode = myResult["list_name_encoded"].string {
                        //self.categoriesList.append((categoryName:list, categoryCode:listCode))
                        print (listCode)
                        self.categoriesDict[ list ] = listCode
                        print ("betch")
                        print(categoriesDict[list])
                        //self.categoriesCodeList.append(listCode)
                    }
                }
    
            }
        }
        
        self.tableView.reloadData()
    }
    
    func sortDataAlphabetical(){
        self.categoriesList.sort{ $0 < $1 }
    }
    
    func findAllCategoryIndex() -> Int{
        var x: Int = 0
        while x != self.categoriesList.count{
            if categoriesList[x].lowercased() == "all"{
                return x
            }
            x += 1
        }
        return -1 //all category does not exist
    }
    
    func moveAllCategoryToIndexZero(){
        let allCategoryIndex = findAllCategoryIndex()
        if (allCategoryIndex != -1){
            let temp = self.categoriesList
            self.categoriesList[0] = self.categoriesList[allCategoryIndex]
            var index: Int = 1
            for x in temp{
                if (x.lowercased() == "all"){
                    continue
                }
                if (index == self.categoriesList.count){
                    self.categoriesList.append(x)
                    index = index + 1
                }else{
                    self.categoriesList[index] = x
                    index = index + 1
                }
            }
        }else{
            print("all category does not exist!")
        }
    }
    
    //MARK: - Check Internet Connection
    func hasConnectivity() -> Bool {
        do {
            let reachability: Reachability = Reachability.init()!
            let networkStatus: Int = reachability.currentReachabilityStatus.hashValue
            
            return (networkStatus != 0)
        }
    }
}

//table View
extension CategoriesVC: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return filteredCategoriesList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        //dequeue
        let cell = tableView.dequeueReusableCell(withIdentifier: Constants.categoriesCell, for: indexPath as IndexPath) as! CategoryTableViewCell
        
        //format the cell
        cell.categoryName.text = "\(filteredCategoriesList[indexPath.row])"
        


        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if categoriesList.isEmpty {
        } else {
            
            let detailView:CategoryDetailVC = self.storyboard?.instantiateViewController(withIdentifier: "CategoryDetailVC") as! CategoryDetailVC
            
            detailView.title = "\(filteredCategoriesList[indexPath.row])"
            if indexPath.row == 0 {
                detailView.categoryName = "All"
            } else {
                detailView.categoryName = "\(filteredCategoriesList[indexPath.row])"
            }
            
            //detailView.categorycode = "\(categoriesCode[indexPath.row])"
            if let detailCategoryCode = categoriesDict[filteredCategoriesList[indexPath.row]] { //dictionary will always return an optional
                detailView.categorycode = "\(detailCategoryCode)"
                print (detailCategoryCode)
            }
            //detailView.categorycode = "\(categoriesDict[filteredCategoriesList[indexPath.row]])"
            self.navigationController?.pushViewController(detailView, animated: true)
        }
        self.tableView!.deselectRow(at: indexPath as IndexPath, animated: true)
    }
}



//search bar
extension CategoriesVC:UISearchBarDelegate{
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if (searchText.isEmpty){
            filteredCategoriesList = categoriesList
        }else{
            filteredCategoriesList = categoriesList.filter({(dataItem: String) -> Bool in
                // If dataItem matches the searchText, return true to include it
                if dataItem.range(of:searchText) != nil {
                    return true
                } else {
                    return false
                }
            })
        }

        tableView.reloadData()
        filteredCategoriesList = searchText.isEmpty ? categoriesList : categoriesList.filter({(dataString: String) -> Bool in
            return dataString.range(of: searchText) != nil
        })
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        self.searchBar.endEditing(true)
    }
}





