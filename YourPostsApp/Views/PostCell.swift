//
//  PostCell.swift
//  YourPostsApp
//

import UIKit

final class PostCell: UICollectionViewCell {

    static let reuseIdentifier = "PostCell"

    var onExpandTapped: (() -> Void)?

    // MARK: - UI Elements

    private let titleLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 17, weight: .semibold)
        label.numberOfLines = 0
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    private let previewLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 15)
        label.textColor = .secondaryLabel
        label.numberOfLines = 2
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    private let expandButton: UIButton = {
        let button = UIButton(type: .system)
        button.titleLabel?.font = .systemFont(ofSize: 14, weight: .medium)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()

    // MARK: - Init

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Setup

    private func setupUI() {
        contentView.addSubview(titleLabel)
        contentView.addSubview(previewLabel)
        contentView.addSubview(expandButton)

        expandButton.addTarget(self, action: #selector(expandButtonTapped), for: .touchUpInside)

        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 12),
            titleLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            titleLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),

            previewLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 8),
            previewLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            previewLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),

            expandButton.topAnchor.constraint(equalTo: previewLabel.bottomAnchor, constant: 8),
            expandButton.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            expandButton.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -12)
        ])
    }

    // MARK: - Actions

    @objc private func expandButtonTapped() {
        onExpandTapped?()
    }

    // MARK: - Configure

    func configure(with post: Post, isExpanded: Bool) {
        titleLabel.text = post.title
        previewLabel.text = post.previewText

        if isExpanded {
            previewLabel.numberOfLines = 0
            expandButton.setTitle("Collapse", for: .normal)
        } else {
            previewLabel.numberOfLines = 2
            expandButton.setTitle("Expand", for: .normal)
        }

        updateExpandButtonVisibility()
    }

    private func updateExpandButtonVisibility() {
        previewLabel.layoutIfNeeded()

        let maxSize = CGSize(width: previewLabel.bounds.width, height: .greatestFiniteMagnitude)
        let fullHeight = previewLabel.text?.boundingRect(
            with: maxSize,
            options: [.usesLineFragmentOrigin, .usesFontLeading],
            attributes: [.font: previewLabel.font!],
            context: nil
        ).height ?? 0

        let lineHeight = previewLabel.font.lineHeight
        let twoLinesHeight = lineHeight * 2

        expandButton.isHidden = fullHeight <= twoLinesHeight
    }
}
