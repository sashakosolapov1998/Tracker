//
//  OnboardingPageViewController.swift
//  Tracker
//
//  Created by Александр Косолапов on 22/7/25.
//

import UIKit

protocol OnboardingDelegate: AnyObject {
    func didFinishOnboarding()
}

final class OnboardingPageController: UIPageViewController {
    
    weak var onboardingDelegate: OnboardingDelegate?
    var onboardingCompletion: (() -> Void)?
    
    private let pagesData: [OnboardingPage] = [
        .init(imageName: "BluePage",
              title: "Отслеживайте только то, что хотите",
              buttonTitle: "Вот это технологии!"
             ),
        .init(imageName: "RedPage",
              title: "Даже если это не литры воды и йога",
              buttonTitle: "Вот это технологии!"
             )
    ]
    
    private lazy var pages: [UIViewController] = pagesData.map {
        let vc = OnboardingViewController(page: $0)
        vc.delegate = self
        return vc
    }
    
    private lazy var pageControl: UIPageControl = {
        let pageControl = UIPageControl()
        pageControl.numberOfPages = pages.count
        pageControl.currentPage = 0
        pageControl.currentPageIndicatorTintColor = .ypBlack
        pageControl.pageIndicatorTintColor = UIColor.ypBlack.withAlphaComponent(0.3)
        return pageControl
    }()
    
    init() {
        super.init(transitionStyle: .scroll, navigationOrientation: .horizontal, options: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print("📘 OnboardingPageController открыт") // убрать
        
        dataSource = self
        delegate = self
        
        if let first = pages.first {
            setViewControllers([first], direction: .forward, animated: false)
        }
        
        view.addSubview(pageControl)
        setupPageControlConstraints()
    }
    private func setupPageControlConstraints() {
        pageControl.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            pageControl.topAnchor.constraint(equalTo: view.topAnchor, constant: 638),
            pageControl.centerXAnchor.constraint(equalTo: view.centerXAnchor)
        ])
    }
}

extension OnboardingPageController: UIPageViewControllerDataSource {
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        guard let index = pages.firstIndex(of: viewController) else { return nil }
        return index > 0 ? pages[index - 1] : nil
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        guard let index = pages.firstIndex(of: viewController) else { return nil }
        return index < pages.count - 1 ? pages[index + 1] : nil
    }
}

extension OnboardingPageController: UIPageViewControllerDelegate {
    func pageViewController(_ pageViewController: UIPageViewController, didFinishAnimating finished: Bool, previousViewControllers: [UIViewController], transitionCompleted completed: Bool) {
        if let currentVC = viewControllers?.first,
           let index = pages.firstIndex(of: currentVC) {
            pageControl.currentPage = index
        }
    }
}

extension OnboardingPageController: OnboardingDelegate {
    func didFinishOnboarding() {
        onboardingCompletion?()
    }
}
