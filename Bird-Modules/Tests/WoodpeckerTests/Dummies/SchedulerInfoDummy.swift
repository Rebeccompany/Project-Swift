//
//  SchedulerInfoDummy.swift
//  
//
//  Created by Marcos Chevis on 22/08/22.
//

import Foundation
import Models


enum SchedulerInfoDummy {
    
    static var today = Date(timeIntervalSince1970: 0)
    
    // Learning Has Not Been Presented Cards
    static let LNHB: [OrganizerCardInfo] = [OrganizerCardInfo(id: UUID(uuidString: "1ade5a1a-da3d-4d9e-b582-369b64163b83")!,
                                                              woodpeckerCardInfo: WoodpeckerCardInfo(step: 0,
                                                                                                     isGraduated: false,
                                                                                                     easeFactor: 2.5,
                                                                                                     streak: 0,
                                                                                                     interval: 0,
                                                                                                     hasBeenPresented: false),
                                                              dueDate: nil,
                                                              lastUserGrade: .none),
    
                                          OrganizerCardInfo(id: UUID(uuidString: "3256fb64-b920-4dff-bdf3-f64904e285fc")!,
                                                            woodpeckerCardInfo: WoodpeckerCardInfo(step: 0,
                                                                                                   isGraduated: false,
                                                                                                   easeFactor: 2.5,
                                                                                                   streak: 0,
                                                                                                   interval: 0,
                                                                                                   hasBeenPresented: false),
                                                            dueDate: nil,
                                                            lastUserGrade: .none),
                                          OrganizerCardInfo(id: UUID(uuidString: "a753895a-698f-4a20-af62-ce039f616c8a")!,
                                                            woodpeckerCardInfo: WoodpeckerCardInfo(step: 0,
                                                                                                   isGraduated: false,
                                                                                                   easeFactor: 2.5,
                                                                                                   streak: 0,
                                                                                                   interval: 0,
                                                                                                   hasBeenPresented: false),
                                                            dueDate: nil,
                                                            lastUserGrade: .none),
                                          OrganizerCardInfo(id: UUID(uuidString: "a03e5365-fc40-415c-bdcf-fbfff76d05b8")!,
                                                            woodpeckerCardInfo: WoodpeckerCardInfo(step: 0,
                                                                                                   isGraduated: false,
                                                                                                   easeFactor: 2.5,
                                                                                                   streak: 0,
                                                                                                   interval: 0,
                                                                                                   hasBeenPresented: false),
                                                            dueDate: nil,
                                                            lastUserGrade: .none)]
    // Learning Has Been Presented Cards
    static let LHB: [OrganizerCardInfo] = [OrganizerCardInfo(id: UUID(uuidString: "d65b96e0-fbda-47f6-a407-3828a27a3af6")!,
                                                           woodpeckerCardInfo: WoodpeckerCardInfo(step: 0,
                                                                                                  isGraduated: false,
                                                                                                  easeFactor: 2.5,
                                                                                                  streak: 0,
                                                                                                  interval: 0,
                                                                                                  hasBeenPresented: true),
                                                             dueDate: nil,
                                                             lastUserGrade: .none),
                                         OrganizerCardInfo(id: UUID(uuidString: "67c2314e-752e-4f8c-87e9-d8c8abba5bd6")!,
                                                           woodpeckerCardInfo: WoodpeckerCardInfo(step: 0,
                                                                                                  isGraduated: false,
                                                                                                  easeFactor: 2.5,
                                                                                                  streak: 0,
                                                                                                  interval: 0,
                                                                                                  hasBeenPresented: true),
                                                           dueDate: nil,
                                                           lastUserGrade: .none),
                                         OrganizerCardInfo(id: UUID(uuidString: "e95cc2d4-71ea-47a2-89f3-3d792361a986")!,
                                                           woodpeckerCardInfo: WoodpeckerCardInfo(step: 0,
                                                                                                  isGraduated: false,
                                                                                                  easeFactor: 2.5,
                                                                                                  streak: 0,
                                                                                                  interval: 0,
                                                                                                  hasBeenPresented: true),
                                                           dueDate: nil,
                                                           lastUserGrade: .none),
                                         OrganizerCardInfo(id: UUID(uuidString: "de368b8a-3520-4824-bb0b-f8f82eed4ea8")!,
                                                           woodpeckerCardInfo: WoodpeckerCardInfo(step: 0,
                                                                                                  isGraduated: false,
                                                                                                  easeFactor: 2.5,
                                                                                                  streak: 0,
                                                                                                  interval: 0,
                                                                                                  hasBeenPresented: true),
                                                           dueDate: nil,
                                                           lastUserGrade: .none)]
    
    // Reviewing Past Cards
    static let RDP: [OrganizerCardInfo] = [OrganizerCardInfo(id: UUID(uuidString: "7fb8bcee-518a-4501-a36b-ca517235ed77")!,
                                                           woodpeckerCardInfo: WoodpeckerCardInfo(step: 0,
                                                                                                  isGraduated: true,
                                                                                                  easeFactor: 2.5,
                                                                                                  streak: 0,
                                                                                                  interval: 0,
                                                                                                  hasBeenPresented: true),
                                                           dueDate: Self.today - 86400,
                                                             lastUserGrade: .none),
                                         OrganizerCardInfo(id: UUID(uuidString: "34e3f54c-17f4-42fe-913e-10e791b3e01d")!,
                                                           woodpeckerCardInfo: WoodpeckerCardInfo(step: 0,
                                                                                                  isGraduated: true,
                                                                                                  easeFactor: 2.5,
                                                                                                  streak: 0,
                                                                                                  interval: 0,
                                                                                                  hasBeenPresented: true),
                                                           dueDate: Self.today - 86400,
                                                           lastUserGrade: .none),
                                         OrganizerCardInfo(id: UUID(uuidString: "6e327801-64b2-4068-a97f-830be9bde6ea")!,
                                                           woodpeckerCardInfo: WoodpeckerCardInfo(step: 0,
                                                                                                  isGraduated: true,
                                                                                                  easeFactor: 2.5,
                                                                                                  streak: 0,
                                                                                                  interval: 0,
                                                                                                  hasBeenPresented: true),
                                                           dueDate: Self.today - 86400,
                                                           lastUserGrade: .none),
                                         OrganizerCardInfo(id: UUID(uuidString: "0c4e3a3f-51f3-4dc6-bacb-3fe583723821")!,
                                                           woodpeckerCardInfo: WoodpeckerCardInfo(step: 0,
                                                                                                  isGraduated: true,
                                                                                                  easeFactor: 2.5,
                                                                                                  streak: 0,
                                                                                                  interval: 0,
                                                                                                  hasBeenPresented: true),
                                                           dueDate: Self.today - 86400,
                                                           lastUserGrade: .none)]
    // Reviewing Self.today Cards
    static let RDT: [OrganizerCardInfo] = [OrganizerCardInfo(id: UUID(uuidString: "032c2fbf-24eb-4e3a-bb14-f9b3fb87f117")!,
                                                           woodpeckerCardInfo: WoodpeckerCardInfo(step: 0,
                                                                                                  isGraduated: true,
                                                                                                  easeFactor: 2.5,
                                                                                                  streak: 0,
                                                                                                  interval: 0,
                                                                                                  hasBeenPresented: true),
                                                           dueDate: Self.today,
                                                             lastUserGrade: .none),
                                         OrganizerCardInfo(id: UUID(uuidString: "c9fe26aa-cbc6-499a-abc8-d33f46adfd83")!,
                                                           woodpeckerCardInfo: WoodpeckerCardInfo(step: 0,
                                                                                                  isGraduated: true,
                                                                                                  easeFactor: 2.5,
                                                                                                  streak: 0,
                                                                                                  interval: 0,
                                                                                                  hasBeenPresented: true),
                                                           dueDate: Self.today,
                                                           lastUserGrade: .none),
                                         OrganizerCardInfo(id: UUID(uuidString: "507b3a8b-0bea-4be2-82e1-92bded33530e")!,
                                                           woodpeckerCardInfo: WoodpeckerCardInfo(step: 0,
                                                                                                  isGraduated: true,
                                                                                                  easeFactor: 2.5,
                                                                                                  streak: 0,
                                                                                                  interval: 0,
                                                                                                  hasBeenPresented: true),
                                                           dueDate: Self.today,
                                                           lastUserGrade: .none),
                                         OrganizerCardInfo(id: UUID(uuidString: "bce18b31-fbad-495e-990d-f10197c3c6fb")!,
                                                           woodpeckerCardInfo: WoodpeckerCardInfo(step: 0,
                                                                                                  isGraduated: true,
                                                                                                  easeFactor: 2.5,
                                                                                                  streak: 0,
                                                                                                  interval: 0,
                                                                                                  hasBeenPresented: true),
                                                           dueDate: Self.today,
                                                           lastUserGrade: .none)]
    
    // Reviewing Future Cards
    static let RDF: [OrganizerCardInfo] = [OrganizerCardInfo(id: UUID(uuidString: "bffa624c-1336-44cd-b05c-67d36d8a61a0")!,
                                                           woodpeckerCardInfo: WoodpeckerCardInfo(step: 0,
                                                                                                  isGraduated: true,
                                                                                                  easeFactor: 2.5,
                                                                                                  streak: 0,
                                                                                                  interval: 0,
                                                                                                  hasBeenPresented: true),
                                                           dueDate: Self.today + 86400,
                                                             lastUserGrade: .none),
                                         OrganizerCardInfo(id: UUID(uuidString: "8c68d0c9-0b04-47af-bed4-3b37ee232bd1")!,
                                                           woodpeckerCardInfo: WoodpeckerCardInfo(step: 0,
                                                                                                  isGraduated: true,
                                                                                                  easeFactor: 2.5,
                                                                                                  streak: 0,
                                                                                                  interval: 0,
                                                                                                  hasBeenPresented: true),
                                                           dueDate: Self.today + 86400,
                                                           lastUserGrade: .none),
                                         OrganizerCardInfo(id: UUID(uuidString: "ede7fb44-b4ad-412f-8a76-28e0a391f506")!,
                                                           woodpeckerCardInfo: WoodpeckerCardInfo(step: 0,
                                                                                                  isGraduated: true,
                                                                                                  easeFactor: 2.5,
                                                                                                  streak: 0,
                                                                                                  interval: 0,
                                                                                                  hasBeenPresented: true),
                                                           dueDate: Self.today + 86400,
                                                           lastUserGrade: .none),
                                         OrganizerCardInfo(id: UUID(uuidString: "7edf4906-8692-4fb0-90ed-04e1a82675f7")!,
                                                           woodpeckerCardInfo: WoodpeckerCardInfo(step: 0,
                                                                                                  isGraduated: true,
                                                                                                  easeFactor: 2.5,
                                                                                                  streak: 0,
                                                                                                  interval: 0,
                                                                                                  hasBeenPresented: true),
                                                           dueDate:  Self.today + 86400,
                                                           lastUserGrade: .none)]
}
