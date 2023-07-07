//
//  MultipleStatementInsert.swift
//  HYReadBook
//
//  Created by Joey on 2023/3/10.
//

import Foundation
import WCDBSwift
public final class MultipleStatementInsert: Statement {
    public private(set) var description: String = ""
    public var statementType: StatementType {
        return .insert
    }

    public init() {}

    @discardableResult
    public func insert(intoTable table: String,
                       with columnConvertibleList: ColumnConvertible...,
                       onConflict conflict: Conflict? = nil) -> MultipleStatementInsert {
        return insert(intoTable: table, with: columnConvertibleList, onConflict: conflict)
    }

    @discardableResult
    public func insert(intoTable table: String,
                       with columnConvertibleList: [ColumnConvertible]? = nil,
                       onConflict conflict: Conflict? = nil) -> MultipleStatementInsert {
        description.append("INSERT")
        if conflict != nil {
            description.append(" OR \(conflict!.description)")
        }
        description.append(" INTO \(table)")
        if columnConvertibleList != nil {
            description.append("(\(columnConvertibleList!.im_joined()))")
        }
        return self
    }

    @discardableResult
    public func values(_ expressionConvertibleList: ExpressionConvertible...) -> MultipleStatementInsert {
        return values(expressionConvertibleList)
    }

    @discardableResult
    public func values(_ expressionConvertibleList: [ExpressionConvertible]) -> MultipleStatementInsert {
        if !expressionConvertibleList.isEmpty {
            description.append(" VALUES \(expressionConvertibleList.im_joined())")
        }
        return self
    }
    
    @discardableResult
    public func multipleValues(_ expressionConvertibleList: [String]) -> MultipleStatementInsert {
        if !expressionConvertibleList.isEmpty {
            description.append(" VALUES ")
            for (idx, part) in expressionConvertibleList.enumerated() {
                if idx == 0 {
                    description.append(part)
                }else {
                    description.append(", \(part)")
                }
            }
        }
        return self
    }
    
    @discardableResult
    public func partValues(_ expressionConvertibleList: ExpressionConvertible...) -> String {
        return partValues(expressionConvertibleList)
    }
    
    @discardableResult
    public func partValues(_ expressionConvertibleList: [ExpressionConvertible]) -> String {
        return "(\(expressionConvertibleList.im_joined()))"
    }
    
}


extension Array {
    public func im_joined(_ map: (Element) -> String, separateBy separator: String = ", ") -> String {
        var flag = false
        return reduce(into: "") { (output, element) in
            if flag {
                output.append(separator)
            } else {
                flag = true
            }
            output.append(map(element))
        }
    }
}

extension Array where Element==ColumnConvertible {
    public func im_joined(separateBy separator: String = ", ") -> String {
        return im_joined({ $0.asColumn().description }, separateBy: separator)
    }
}

extension Array where Element==ExpressionConvertible {
    public func im_joined(separateBy separator: String = ", ") -> String {
        return im_joined({ $0.asExpression().description }, separateBy: separator)
    }
}
