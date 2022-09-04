//
//  View+Discover.swift
//  Tower
//
//  Created by Ian Keen on 2022-08-14.
//

import Foundation
import SwiftUI

extension View {
    public func discover<T: UIView>(
        tag: Int = .random(in: (.min)...(.max)),
        where predicate: @escaping (T) -> Bool = { _ in true },
        _ closure: @escaping (T) -> Void
    ) -> some View {
        self.overlay(
            DiscoveryView(tag: tag)
                .frame(width: 0, height: 0)
                .onAppear {
                    DispatchQueue.main.async {
                        let keyWindow = UIApplication.shared.windows.first(where: \.isKeyWindow)
                        let root = keyWindow?.viewWithTag(tag)

                        guard
                            let host = root.flatMap(findViewHost(from:)),
                            let discovered = findClosestView(T.self, host: host, where: predicate)
                        else {
                            return print("⚠️ Unable to find a view of type '\(T.self)'")
                        }

                        closure(discovered)
                    }
                }
        )
    }
}

extension View {
    public func discover<T: UIViewController>(
        where predicate: @escaping (T) -> Bool = { _ in true },
        _ closure: @escaping (T) -> Void
    ) -> some View {
        var match: T?

        return discover(
            where: { (view: UIView) in
                guard let controller = view.findViewController() else { return false }

                let responderChain = sequence(first: controller, next: \.next)

                for item in responderChain {
                    if let controller = item as? T, predicate(controller) {
                        match = controller
                        return true
                    }
                }

                return false
            },
                 { _ in
                     guard let controller = match else {
                         return print("⚠️ Unable to find a view controller of type '\(T.self)'")
                     }

                     closure(controller)
                 }
        )
    }
}

private extension UIView {
    func findViewController() -> UIViewController? {
        if let next = next as? UIViewController {
            return next
        } else if let next = next as? UIView {
            return next.findViewController()
        } else {
            return nil
        }
    }
}

private struct DiscoveryView: UIViewRepresentable {
    var tag: Int

    func makeUIView(context: Context) -> some UIView {
        let view = UIView()
        view.frame = .zero
        view.isUserInteractionEnabled = false
        view.backgroundColor = .clear
        view.tag = tag
        return view
    }
    func updateUIView(_ uiView: UIViewType, context: Context) { }
}

private func findViewHost(from entry: UIView) -> UIView? {
    var superview = entry.superview
    while let s = superview {
        if NSStringFromClass(type(of: s)).contains("ViewHost") {
            return s
        }
        superview = s.superview
    }
    return nil
}

private func findClosestView<T: UIView>(_: T.Type = T.self, host: UIView, where predicate: @escaping (T) -> Bool) -> T? {
    // find the view hosts index in it's superview
    // search from that index back to 0
    // - look down the hierarchy at each item for T
    guard
        let superview = host.superview,
        let index = superview.subviews.firstIndex(of: host)
    else { return nil }

    let branches = superview.subviews[0...index].reversed()

    return branches.lazy.compactMap({ $0.firstView(T.self, where: predicate) }).first
}

private extension UIView {
    func firstView<T: UIView>(_: T.Type = T.self, where predicate: @escaping (T) -> Bool = { _ in true }) -> T? {
        if let result = self as? T, predicate(result) {
            return result
        }

        return subviews.lazy
            .compactMap { $0.firstView(where: predicate) }
            .first
    }
}
