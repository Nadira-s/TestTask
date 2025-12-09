import UIKit

final class PostCell: UITableViewCell {

    private let avatarView = UIImageView()
    private let titleLabel = UILabel()
    private let bodyLabel = UILabel()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupUI()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setupUI() {
        avatarView.layer.cornerRadius = 25
        avatarView.clipsToBounds = true
        avatarView.backgroundColor = .secondarySystemBackground

        titleLabel.font = .boldSystemFont(ofSize: 16)
        titleLabel.numberOfLines = 2

        bodyLabel.font = .systemFont(ofSize: 14)
        bodyLabel.numberOfLines = 0
        bodyLabel.textColor = .secondaryLabel

        let container = UIStackView(arrangedSubviews: [avatarView, titleLabel, bodyLabel])
        container.axis = .vertical
        container.spacing = 8

        avatarView.heightAnchor.constraint(equalToConstant: 50).isActive = true
        avatarView.widthAnchor.constraint(equalToConstant: 50).isActive = true

        contentView.addSubview(container)

        container.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            container.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 12),
            container.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 12),
            container.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -12),
            container.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -12)
        ])
    }

    func configure(with post: PostEntity) {
        titleLabel.text = post.title
        bodyLabel.text = post.body

        let imageURL = URL(string: "https://picsum.photos/200?random=\(post.id)")!
        loadImage(from: imageURL)
    }

    private func loadImage(from url: URL) {
        URLSession.shared.dataTask(with: url) { data, _, _ in
            guard let data = data else { return }
            DispatchQueue.main.async {
                self.avatarView.image = UIImage(data: data)
            }
        }.resume()
    }
}

