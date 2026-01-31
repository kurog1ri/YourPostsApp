//
//  FeedViewController.swift
//  YourPostsApp
//

import UIKit

final class FeedViewController: UIViewController {

    private let viewModel = FeedViewModel()

    // MARK: - UI Elements

    private lazy var collectionView: UICollectionView = {
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: createLayout())
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.backgroundColor = .systemBackground
        collectionView.delegate = self
        return collectionView
    }()

    private let activityIndicator: UIActivityIndicatorView = {
        let indicator = UIActivityIndicatorView(style: .large)
        indicator.translatesAutoresizingMaskIntoConstraints = false
        indicator.hidesWhenStopped = true
        return indicator
    }()

    private var dataSource: UICollectionViewDiffableDataSource<Int, Int>!

    // MARK: - Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        configureDataSource()
        loadPosts()
    }

    // MARK: - Setup

    private func setupUI() {
        title = "Posts"
        view.backgroundColor = .systemBackground

        view.addSubview(collectionView)
        view.addSubview(activityIndicator)

        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: view.topAnchor),
            collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            collectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor),

            activityIndicator.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            activityIndicator.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
    }

    private func createLayout() -> UICollectionViewLayout {
        var configuration = UICollectionLayoutListConfiguration(appearance: .plain)
        configuration.showsSeparators = true
        return UICollectionViewCompositionalLayout.list(using: configuration)
    }

    private func configureDataSource() {
        let cellRegistration = UICollectionView.CellRegistration<PostCell, Int> { [weak self] (cell: PostCell, indexPath: IndexPath, postId: Int) in
            guard let self, let post = self.viewModel.post(for: postId) else { return }

            let isExpanded = self.viewModel.isExpanded(postId: postId)
            cell.configure(with: post, isExpanded: isExpanded)

            cell.onExpandTapped = {
                self.viewModel.toggleExpand(postId: postId)
                self.reconfigureItem(postId)
            }
        }

        dataSource = UICollectionViewDiffableDataSource<Int, Int>(collectionView: collectionView) { (collectionView: UICollectionView, indexPath: IndexPath, postId: Int) -> UICollectionViewCell? in
            collectionView.dequeueConfiguredReusableCell(using: cellRegistration, for: indexPath, item: postId)
        }
    }

    // MARK: - Data Loading

    private func loadPosts() {
        activityIndicator.startAnimating()

        Task {
            do {
                try await viewModel.fetchPosts()
                applySnapshot()
            } catch {
                showError(error)
            }
            activityIndicator.stopAnimating()
        }
    }

    private func applySnapshot() {
        var snapshot = NSDiffableDataSourceSnapshot<Int, Int>()
        snapshot.appendSections([0])
        snapshot.appendItems(viewModel.posts.map { $0.postId })
        dataSource.apply(snapshot, animatingDifferences: true)
    }

    private func reconfigureItem(_ postId: Int) {
        var snapshot = dataSource.snapshot()
        snapshot.reconfigureItems([postId])
        dataSource.apply(snapshot, animatingDifferences: true)
    }

    // MARK: - Error Handling

    private func showError(_ error: Error) {
        let message = (error as? LocalizedError)?.errorDescription ?? error.localizedDescription
        let alert = UIAlertController(title: "Error", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        present(alert, animated: true)
    }
}

// MARK: - UICollectionViewDelegate

extension FeedViewController: UICollectionViewDelegate {

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        collectionView.deselectItem(at: indexPath, animated: true)

        guard let postId = dataSource.itemIdentifier(for: indexPath) else { return }

        let detailVC = PostDetailViewController(postId: postId)
        navigationController?.pushViewController(detailVC, animated: true)
    }
}
