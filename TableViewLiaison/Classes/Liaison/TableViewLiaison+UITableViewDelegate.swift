//
//  TableViewLiaison+UITableViewDelegate.swift
//  TableViewLiaison
//
//  Created by Dylan Shine on 4/25/18.
//

import UIKit

extension TableViewLiaison: UITableViewDelegate {
    
    public func tableView(_ tableView: UITableView, willSelectRowAt indexPath: IndexPath) -> IndexPath? {
        return perform(.willSelect, at: indexPath)
    }
    
    public func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        perform(.didSelect, at: indexPath)
    }
    
    public func tableView(_ tableView: UITableView, willDeselectRowAt indexPath: IndexPath) -> IndexPath? {
        return perform(.willDeselect, at: indexPath)
    }
    
    public func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        perform(.didDeselect, at: indexPath)
    }
    
    public func tableView(_ tableView: UITableView, targetIndexPathForMoveFromRowAt sourceIndexPath: IndexPath, toProposedIndexPath proposedDestinationIndexPath: IndexPath) -> IndexPath {
        
        if canMove(to: proposedDestinationIndexPath) {
            return proposedDestinationIndexPath
        }
        
        return sourceIndexPath
    }
    
    public func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        row(for: indexPath)?.perform(.willDisplay,
                                     liaison: self,
                                     cell: cell,
                                     indexPath: indexPath)
        
        showPaginationSpinner(after: indexPath)
    }
    
    public func tableView(_ tableView: UITableView, didEndDisplaying cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        row(for: indexPath)?.perform(.didEndDisplaying,
                                     liaison: self,
                                     cell: cell,
                                     indexPath: indexPath)
    }
    
    public func tableView(_ tableView: UITableView, willBeginEditingRowAt indexPath: IndexPath) {
        perform(.willBeginEditing, at: indexPath)
    }
    
    public func tableView(_ tableView: UITableView, didEndEditingRowAt indexPath: IndexPath?) {
        guard let indexPath = indexPath else { return }
        perform(.didEndEditing, at: indexPath)
    }
    
    public func tableView(_ tableView: UITableView, didHighlightRowAt indexPath: IndexPath) {
        perform(.didHighlight, at: indexPath)
    }
    
    public func tableView(_ tableView: UITableView, didUnhighlightRowAt indexPath: IndexPath) {
        perform(.didUnhighlight, at: indexPath)
    }
    
    public func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        return sections.element(at: section)?.view(componentView: .header, for: self, in: section)
    }
    
    public func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        return sections.element(at: section)?.view(componentView: .footer, for: self, in: section)
    }
    
    public func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return row(for: indexPath)?.height ?? UITableView.automaticDimension
    }
    
    public func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return row(for: indexPath)?.estimatedHeight ?? UITableView.automaticDimension
    }
    
    public func tableView(_ tableView: UITableView, shouldIndentWhileEditingRowAt indexPath: IndexPath) -> Bool {
        return row(for: indexPath)?.indentWhileEditing ?? false
    }
    
    public func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCell.EditingStyle {
        return row(for: indexPath)?.editingStyle ?? .none
    }
    
    public func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        return row(for: indexPath)?.editActions
    }
    
    public func tableView(_ tableView: UITableView, accessoryButtonTappedForRowWith indexPath: IndexPath) {
        perform(.accessoryButtonTapped, at: indexPath)
    }
    
    public func tableView(_ tableView: UITableView, titleForDeleteConfirmationButtonForRowAt indexPath: IndexPath) -> String? {
        return row(for: indexPath)?.deleteConfirmationTitle
    }
    
    public func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return sections.element(at: section)?.calculate(height: .height, for: .header) ?? UITableView.automaticDimension
    }
    
    public func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return sections.element(at: section)?.calculate(height: .height, for: .footer) ?? UITableView.automaticDimension
    }
    
    public func tableView(_ tableView: UITableView, estimatedHeightForHeaderInSection section: Int) -> CGFloat {
        return sections.element(at: section)?.calculate(height: .estimatedHeight, for: .header) ?? 0
    }
    
    public func tableView(_ tableView: UITableView, estimatedHeightForFooterInSection section: Int) -> CGFloat {
        return sections.element(at: section)?.calculate(height: .estimatedHeight, for: .footer) ?? 0
    }
    
    public func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
        sections.element(at: section)?.perform(.willDisplay,
                                               componentView: .header,
                                               liaison: self,
                                               view: view,
                                               section: section)
    }
    
    public func tableView(_ tableView: UITableView, willDisplayFooterView view: UIView, forSection section: Int) {
        sections.element(at: section)?.perform(.willDisplay,
                                               componentView: .footer,
                                               liaison: self,
                                               view: view,
                                               section: section)
    }
    
    public func tableView(_ tableView: UITableView, didEndDisplayingHeaderView view: UIView, forSection section: Int) {
        sections.element(at: section)?.perform(.didEndDisplaying,
                                               componentView: .header,
                                               liaison: self,
                                               view: view,
                                               section: section)
    }
    
    public func tableView(_ tableView: UITableView, didEndDisplayingFooterView view: UIView, forSection section: Int) {
        sections.element(at: section)?.perform(.didEndDisplaying,
                                               componentView: .footer,
                                               liaison: self,
                                               view: view,
                                               section: section)
    }
    
}
