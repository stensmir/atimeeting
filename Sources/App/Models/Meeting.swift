//
//  Meeting.swift
//  App
//
//  Created by Yuriy Durnev on 15.04.2018.
//

import Vapor
import FluentSQLite

final class Meeting: Codable {
   
    var id: Int?
    var title: String
    var description: String
    var dateStart: String
    var dateEnd: String
    var userName: String
    var floor: Int
    var room: String
    
    init(title: String,
         description: String,
         dateStart: String,
         dateEnd: String,
         userName: String,
         floor: Int,
         room: String)
    {
        self.title = title
        self.description = description
        self.dateStart = dateStart
        self.dateEnd = dateEnd
        self.userName = userName
        self.floor = floor
        self.room = room
    }
}

extension Meeting: SQLiteModel {}
extension Meeting: Migration {}
extension Meeting: Content {}
