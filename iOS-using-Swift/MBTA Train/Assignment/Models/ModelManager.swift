import CoreData
import Foundation

class ModelManager {
    static let shared: ModelManager = ModelManager()
    
    var trains: [Train] {
        (try? fetchAll(type: Train.self, context: context)) ?? []
    }
    var schedules: [Schedule] {
        (try? fetchAll(type: Schedule.self, context: context)) ?? []
    }
    var stops: [Stop] {
        (try? fetchAll(type: Stop.self, context: context)) ?? []
    }
    var train: Train?
    var schedule: Schedule?
    
    private init() {}
    
    lazy var persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "Train")
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        container.viewContext.automaticallyMergesChangesFromParent = true
        print(NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true))
        return container
    }()
    lazy var context = persistentContainer.viewContext
    
    func train(id: String) -> Train? {
        try? fetch(type: Train.self, context: context, predicate: NSPredicate(format: "id == %@", id))
    }
    
    func schedule(id: String) -> Schedule? {
        try? fetch(type: Schedule.self, context: context, predicate: NSPredicate(format: "id == %@", id))
    }
    
    func stop(name: String) -> Stop? {
        try? fetch(type: Stop.self, context: context, predicate: NSPredicate(format: "name == %@", name))
    }
    
    func addTrain(id: String, name: String, source: String, destination: String) {
        //        let train: Train = Train(id: id, name: name, source: source, destination: destination, schedules: [])
        //        trains = trains + [train]
        let train: Train = Train(context: context)
        train.id = id
        train.name = name
        train.source = source
        train.destination = destination
        save()
    }
    
    func updateTrain(id: String, name: String, source: String, destination: String) {
        //        guard let result: Train = trains.first(where: { $0.id == id }) else { return }
        guard let result: Train = train(id: id) else { return }
        result.name = name
        result.source = source
        result.destination = destination
        save()
    }
    
    func deleteTrain(id: String) {
        //        trains = trains.filter { $0.id != id }
        guard let result: Train = train(id: id) else { return }
        context.delete(result)
        save()
    }
    
    func addSchedule(id: String, arrival: Date, departure: Date) {
        //        train?.schedules.append(Schedule(id: id, arrival: arrival, departure: departure, stops: stops))
        let schedule: Schedule = Schedule(context: context)
        schedule.id = id
        schedule.arrival = arrival
        schedule.departure = departure
        train?.addToSchedules(schedule)
        save()
    }
    
    func updateSchedule(id: String, arrival: Date, departure: Date) {
        //        guard let result: Schedule = train?.schedules.first(where: { $0.id == id }) else { return }
        guard let result: Schedule = schedule(id: id) else { return }
        result.arrival = arrival
        result.departure = departure
        save()
    }
    
    func deleteSchedule(id: String) {
        //        train?.schedules = train?.schedules.filter { $0.id != id } ?? []
        guard let result: Schedule = schedule(id: id) else { return }
        context.delete(result)
        save()
    }
    
    func addStop(name: String, address: String, latitude: Double, longitude: Double) {
        //        schedule?.stops.append(Stop(name: name, address: address, latitude: latitude, longitude: longitude))
        let stop: Stop = Stop(context: context)
        stop.name = name
        stop.address = address
        stop.latitude = latitude
        stop.longitude = longitude
        schedule?.addToStops(stop)
        save()
    }
    
    func updateStop(name: String, address: String, latitude: Double, longitude: Double) {
        //        guard let result: Stop = schedule?.stops.first(where: { $0.name == name }) else { return }
        guard let result: Stop = stop(name: name) else { return }
        result.name = name
        result.address = address
        result.latitude = latitude
        result.longitude = longitude
        save()
    }
    
    func deleteStop(name: String) {
        //        schedule?.stops = schedule?.stops.filter { $0.name != name } ?? []
        guard let result: Stop = stop(name: name) else { return }
        context.delete(result)
        save()
    }
    
    func fetch<T: NSManagedObject>(type: T.Type, context: NSManagedObjectContext, predicate: NSPredicate) throws -> T? {
        let request: NSFetchRequest = type.fetchRequest()
        request.predicate = predicate
        request.fetchLimit = 1
        do {
            return (try context.fetch(request) as? [T])?.first
        } catch {
            throw error
        }
    }
    
    func fetchAll<T: NSManagedObject>(type: T.Type,
                                      context: NSManagedObjectContext,
                                      predicate: NSPredicate? = nil,
                                      sortDescriptors: [NSSortDescriptor]? = nil) throws -> [T] {
        let request: NSFetchRequest = type.fetchRequest()
        if let predicate = predicate {
            request.predicate = predicate
        }
        if let sortDescriptors = sortDescriptors {
            request.sortDescriptors = sortDescriptors
        }
        do {
            return (try context.fetch(request) as? [T]) ?? [T]()
        } catch {
            throw error
        }
    }
    
    func initModels() {
        let train: Train = Train(context: context)
        train.id = UUID().uuidString
        train.name = "Default Train"
        train.source = "Soucre"
        train.destination = "destination"
        let schedule: Schedule = Schedule(context: context)
        schedule.id = UUID().uuidString
        schedule.arrival = Date()
        schedule.departure = Date().addingTimeInterval(30)
        train.addToSchedules(schedule)
        let stop: Stop = Stop(context: context)
        stop.name = "Default Stop"
        stop.address = "US"
        stop.latitude = 0
        stop.longitude = 0
        schedule.addToStops(stop)
        save()
    }
    
    func save() {
        if context.hasChanges {
            do {
                try context.save()
                print("Save context - \(context)")
            } catch {
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }
}
