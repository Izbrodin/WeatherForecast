import UIKit

extension UITableView {
    
    func register(cellClass: UITableViewCell.Type) {
        let name = String(describing: cellClass)
        self.register(UINib(nibName: name, bundle: Bundle.main), forCellReuseIdentifier: name)
    }
    
    func dequeueReusableCell<T>(for indexPath: IndexPath) -> T where T: UITableViewCell {
        let name = String(describing: T.self)
        let cell = self.dequeueReusableCell(withIdentifier: name, for: indexPath) as! T
        return cell
    }
    
    func register(headerClass: UITableViewHeaderFooterView.Type) {
        let name = String(describing: headerClass)
        self.register(UINib(nibName: name, bundle: nil), forHeaderFooterViewReuseIdentifier: name)
    }
    
    func dequeueReusableHeaderFooterView<T>() -> T where T: UITableViewHeaderFooterView {
        let name = String(describing: T.self)
        let headerFooterView = self.dequeueReusableHeaderFooterView(withIdentifier: name) as! T
        return headerFooterView
    }
}
