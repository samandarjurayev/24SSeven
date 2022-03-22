
import UIKit

class DeliveredViewController : UIViewController {
    
    let _view = TypeView()
    
    let viewModel = OrderViewModel()
    var countOfOrders : Int?
    
    init() {
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupViewModel()
        setupTableView()
    }
    
    override func loadView() {
        view = _view
    }
}

extension DeliveredViewController {
    private func setupTableView() {
        _view.tableView.delegate = self
        _view.tableView.dataSource = self
    }
    
    
    private func setupViewModel() {
        viewModel.delegate = self
        viewModel.getUserOrders(type: "delivered", page: 1)
    }
}

extension DeliveredViewController : UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if viewModel.favouritesList?.count == 0 {
            _view.noOrderItem.isHidden = false
        } else {
            _view.noOrderItem.isHidden = true
        }
        
        return viewModel.favouritesList?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: OrderTypeTableViewCell.reuseId, for: indexPath) as? OrderTypeTableViewCell else { return UITableViewCell()}
      
        cell.inspectClosure = { [weak self] in
            guard let self = self else { return }
            let detailsVC = OrderDetailsViewController()
            detailsVC.orderID = self.viewModel.favouritesList?[indexPath.row].id ?? 0
            self.navigationController?.pushViewController(detailsVC, animated: true)
        }
        
        if let pagination = viewModel.pagination {
            if countOfOrders == indexPath.row + 1 && pagination.nextPage != nil {
                viewModel.delegate = self
                viewModel.getUserOrders(type: "delivered", page: pagination.nextPage ?? 1)
            }
        }
        
        cell.orderDescription.statusLabel.textColor = OrderTypes.delivered.color
        cell.cellOrderModel = viewModel.favouritesList?[indexPath.row]
        
        return cell
    }
}

extension DeliveredViewController : UITableViewDelegate {
    
}

extension DeliveredViewController : OrderViewModelProtocol {
    func getUserOrders() {
        countOfOrders = viewModel.items?.count
        _view.tableView.reloadData()
    }
}
