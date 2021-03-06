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
    
    var transactions = [Transaction]()
    
    var sectionDates = [String]()
    var sectionSize = [Int]()
    
    var refreshControl = UIRefreshControl()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        coreDataHelper = CoreDataHelper.getInstance()
        
        tableViewPaymentHistory.register(UINib(nibName: "PaymentHistoryTableViewCell", bundle: nil), forCellReuseIdentifier: "cell")
        tableViewPaymentHistory.register(PaymentSectionTableViewHeaderFooterView.self,
                                         forHeaderFooterViewReuseIdentifier: "sectionHeader")
        tableViewPaymentHistory.rowHeight = UITableView.automaticDimension
        tableViewPaymentHistory.delegate = self
        tableViewPaymentHistory.dataSource = self
        tableViewPaymentHistory.reloadData()
        
        refreshControl.attributedTitle = NSAttributedString(string: "Pull to refresh")
        refreshControl.addTarget(self, action: #selector(self.refresh(_:)), for: .valueChanged)
        tableViewPaymentHistory.addSubview(refreshControl)
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        labelBalance.text = "$\(String(format: "%.2f", SettingsManager().getBalance()))"
        
        getHistory()
        
    }
    
    @objc func refresh(_ sender: AnyObject) {
       
        getHistory()
        
        refreshControl.endRefreshing()
    }
    
    func getHistory() {
        
        Transaction().getPaymentHistory(id: SettingsManager().getId()) { (transactions) in
            
            if let transactions = transactions{
                
                if transactions.count == 0{
                    self.tableViewPaymentHistory.isHidden = true
                }else {
                
                    self.tableViewPaymentHistory.isHidden = false
                    self.labelNoRecords.isHidden = true
                    
                    // products are already sorted so we need to get the dates and count of items for each day for the table view section title and size
                    
                    self.transactions = transactions
                    
                    let formatter = DateFormatter()
                    formatter.dateFormat = "dd-MM-yyyy"
                    
                    self.sectionDates = [String]()
                    self.sectionSize = [Int]()
                    
                    for p in transactions{
                        
                        if !self.sectionDates.contains(formatter.string(from:p.date)){
                            self.sectionDates.append(formatter.string(from:p.date))
                            self.sectionSize.append(1)
                        }else {
                            
                            self.sectionSize[self.sectionDates.firstIndex(of: formatter.string(from:p.date))!] += 1
                        }
                       
                    }
                    
                    self.tableViewPaymentHistory.reloadData()
                    self.constraintTableHeight.constant = self.tableViewPaymentHistory.contentSize.height
                    self.tableViewPaymentHistory.setNeedsUpdateConstraints()
                }
            }else {
                self.tableViewPaymentHistory.isHidden = true
            }
        }
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return sectionSize[section]
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! PaymentHistoryTableViewCell
        
        cell.setDetails(transaction: transactions[indexPath.row])
        
        return cell
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return sectionDates.count
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        let view = tableView.dequeueReusableHeaderFooterView(withIdentifier:
                    "sectionHeader") as! PaymentSectionTableViewHeaderFooterView
        
        view.labelDate.text = sectionDates[section]
        
        return view
    }
}
