//
//  WalletViewController.swift
//  PaymentWallTask
//
//  Created by Antoun on 22/08/2020.
//  Copyright © 2020 PaymentWall. All rights reserved.
//

import UIKit

class WalletViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    @IBOutlet weak var labelBalance: UILabel!
    
    @IBOutlet weak var labelNoRecords: UILabel!
    
    @IBOutlet weak var tableViewPaymentHistory: UITableView!
    
    @IBOutlet weak var constraintTableHeight: NSLayoutConstraint!
    
    var coreDataHelper: CoreDataHelper!
    
    var products = [Product]()
    
    var productsByDate = [String: [Product]]()
    
    var loadingView: LoadingView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    
        loadingView = LoadingView(frame: self.view.frame)
        loadingView.setLoadingImage(image: UIImage(named: "ic_loading")!)
        loadingView.backgroundColor = UIColor.white.withAlphaComponent(0.8)
        loadingView.setIsLoading(false)
        self.view.addSubview(loadingView)
        
        coreDataHelper = CoreDataHelper.getInstance()
        
        tableViewPaymentHistory.register(UINib(nibName: "PaymentHistoryTableViewCell", bundle: nil), forCellReuseIdentifier: "cell")
        tableViewPaymentHistory.register(PaymentSectionTableViewHeaderFooterView.self,
                                         forHeaderFooterViewReuseIdentifier: "sectionHeader")
        tableViewPaymentHistory.rowHeight = UITableView.automaticDimension
        tableViewPaymentHistory.delegate = self
        tableViewPaymentHistory.dataSource = self
        tableViewPaymentHistory.reloadData()
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        labelBalance.text = "$\(String(format: "%.2f", SettingsManager().getBalance()))"
        
        loadingView.setIsLoading(true)
        coreDataHelper.getPaymentHistory(id: SettingsManager().getId()) { (products) in
            
            self.loadingView.setIsLoading(false)
            
            if products.count == 0{
                self.tableViewPaymentHistory.isHidden = true
            }else {
                
                self.tableViewPaymentHistory.isHidden = false
                self.labelNoRecords.isHidden = true
                
                self.products = products
                
                for p in self.products{
                    
                    if self.productsByDate[p.date]?.count ?? 0 > 0{
                        // has elements before
                        
                        var tempProducts = self.productsByDate[p.date]
                        tempProducts?.append(p)
                        
                        self.productsByDate[p.date] = tempProducts
                        
                    }else{
                        
                        var tempProducts = [Product]()
                        tempProducts.append(p)
                        
                        self.productsByDate[p.date] = tempProducts
                    }
                }
                
                self.tableViewPaymentHistory.reloadData()
                self.constraintTableHeight.constant = self.tableViewPaymentHistory.contentSize.height
                self.tableViewPaymentHistory.setNeedsUpdateConstraints()
            }
            
        }
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        var i = 0;
        for (_, products) in productsByDate {
            
            if i == section{
                return products.count
            }
            
            i+=1
        }
        
        return productsByDate.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! PaymentHistoryTableViewCell
        
        cell.setDetails(product: products[indexPath.row])
        
        return cell
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return productsByDate.keys.count
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        let view = tableView.dequeueReusableHeaderFooterView(withIdentifier:
                    "sectionHeader") as! PaymentSectionTableViewHeaderFooterView
        
        var i = 0;
        for (kind, _) in productsByDate {
            
            if i == section{
                view.labelDate.text = kind
                
                return view
            }
            
            i+=1
        }
        
        return view
    }
}
