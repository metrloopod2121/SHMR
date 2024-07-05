//
//  CalendarView.swift
//  To Do App
//
//  Created by 𝕄𝕒𝕥𝕧𝕖𝕪 ℙ𝕠𝕕𝕘𝕠𝕣𝕟𝕚𝕪 on 05.07.2024.
//

import SwiftUI

struct CalendarView: UIViewControllerRepresentable {
    @ObservedObject var viewModel: MainViewModel
    
    
    func makeUIViewController(context: Context) -> CalendarViewController {
        let viewController = CalendarViewController()
        viewController.tasks = viewModel.sortedItems 
        return viewController
    }
    
    func updateUIViewController(_ uiViewController: CalendarViewController, context: Context) {
        uiViewController.tasks = viewModel.sortedItems 
        uiViewController.tasksTableView.reloadData()
    }
}
