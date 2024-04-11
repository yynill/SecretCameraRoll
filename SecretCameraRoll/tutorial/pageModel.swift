//
//  pageModel.swift
//  SecretCameraRoll
//
//  Created by Yves Nill on 05.02.24.
//

import Foundation

struct Page: Identifiable, Equatable {
    let id = UUID()
    var name: String
    var description: String
    var imageUrl: String
    var tag: Int
    
    static var samplePage = Page(name: "A Normal Calculator", description: "except it's not...", imageUrl: "img1", tag: 0)
    
    static var samplePages: [Page] = [
        Page(name: "A Normal Calculator!", description: "except it's not...", imageUrl: "img1", tag: 0),
        Page(name: "The Calculator Chronicles", description: "Just like your typical calculator, this bad boy has the power to help you cheat on every test. But hold on, that's not the only secret this calculator is concealing for you!", imageUrl: "img2", tag: 1),
        Page(name: "Secret Equals", description: "Mastered pressing '='? Try holding it for 3 sec. Your fingers are now on a secret mission.", imageUrl: "img3", tag: 2),
        Page(name: "Change your Hotspot", description: "What's this? Secret password page! Make it sneakier than your friend's hotspot: 76_W9sA3...\n\n(Yo! 1-9. like normal people!)", imageUrl: "img4", tag: 3),
        Page(name: "Unlock the Camera Roll", description: "Back on the calculator, input your password (clear with AC first) - voila! Access granted to your secrets. What's inside?", imageUrl: "img5", tag: 4),
        Page(name: "Oh no?!", description: "That's embarrassing! My wild Ryan Reynolds selfie collection?", imageUrl: "img6", tag: 5),
        Page(name: "Export", description: "I gotta show my friends. Select, hit export, and full send. Your friend will thank you for the giggles.", imageUrl: "img7", tag: 6),
        Page(name: "Delete", description: "Okay, I delete those embarrassing photos (don't judge). Now it's cleaned up for you.\n\n May your numbers be calculated, your secrets be secure, and your Ryan Reynolds moments forever cherished.", imageUrl: "img8", tag: 7),

    ]
}

//  Who knew calculators could be this entertaining?
