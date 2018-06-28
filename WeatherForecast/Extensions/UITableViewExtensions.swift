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
}
