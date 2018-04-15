import Routing
import Vapor
import Fluent

/// Register your application's routes here.
///
/// [Learn More →](https://docs.vapor.codes/3.0/getting-started/structure/#routesswift)
public func routes(_ router: Router) throws {
    
    router.post("api", "meetings") { req -> Future<Meeting> in
        return try req.content.decode(Meeting.self)
    }
    
    router.get("api", "meetings") { req -> Future<[Meeting]> in
        return Meeting.query(on: req).all()
    }
    
    router.get("api", "meetings", Meeting.parameter) { req -> Future<Meeting> in
        return try req.parameter(Meeting.self)
    }
    
    router.put("api", "meetings", Meeting.parameter) { req -> Future<Meeting> in
        return try flatMap(to: Meeting.self,
                           req.parameter(Meeting.self),
                           req.content.decode(Meeting.self)) {
                            meeting, updatedMeeting in
                            meeting.title = updatedMeeting.title
                            meeting.description = updatedMeeting.description
                            meeting.dateStart = updatedMeeting.dateStart
                            meeting.dateEnd = updatedMeeting.dateEnd
                            meeting.userName = updatedMeeting.userName
                            meeting.floor = updatedMeeting.floor
                            meeting.room = updatedMeeting.room
                            
                            return meeting.save(on: req)
        }
    }
    
    router.delete("api", "meetings", Meeting.parameter) { req -> Future<HTTPStatus> in
        return try req.parameter(Meeting.self)
            .flatMap(to: HTTPStatus.self) { meeting in
                return meeting.delete(on: req)
                    .transform(to: HTTPStatus.noContent)
        }
    }
    
    router.get("api", "meetings, search") { req -> Future<[Meeting]> in
        guard let searchTerm = req.query[String.self, at: "term"] else {
            throw Abort(.badRequest)
        }
        return try Meeting.query(on: req).group(.or) { or in
            try or.filter(\.title == searchTerm)
            try or.filter(\.description == searchTerm)
        }.all()
    }
}
