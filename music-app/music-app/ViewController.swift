//
//  ViewController.swift
//  music-app
//
//  Created by Caroline on 31.05.16.
//  Copyright © 2016 FHNW. All rights reserved.
//

import UIKit

class ViewController: UIViewController, SPTAudioStreamingPlaybackDelegate {
    

    @IBOutlet weak var loginButton: UIButton!
    var session: SPTSession?
    var player: SPTAudioStreamingController?
    
    let clientId = "3c03916c647a499e85ea0f9e7003db3e"
    let callbackUrl = "music-app://returnafterlogin"
    var loginUrl: NSURL?
    
    @IBOutlet weak var artworkImageView: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setup()
        loginButton.hidden = true
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(ViewController.updateAfterFirstLogin), name: "loginSuccessfull", object: nil)
        let userDefaults = NSUserDefaults.standardUserDefaults()
        
        if let sessionObj:AnyObject = userDefaults.objectForKey("SpotifySession"){
            //session available
            let sessionDataObj = sessionObj as! NSData
            
            let session = NSKeyedUnarchiver.unarchiveObjectWithData(sessionDataObj) as! SPTSession
            
            if !session.isValid(){
                SPTAuth.defaultInstance().renewSession(session, callback: {(error:NSError!, renewedSession:SPTSession!) -> Void in
                    if error == nil{
                            let sessionData = NSKeyedArchiver.archivedDataWithRootObject(session)
                        userDefaults.setObject(sessionData, forKey: "SpotifySession")
                        userDefaults.synchronize()
                        
                        self.session = renewedSession
                        self.playUsingSession(renewedSession)
                    }else{
                        print("error refreshing session")
                    }
                    
                    })
            }else{
                print("session valid")
                self.session = session
                playUsingSession(session)
            }
            
        }else{
            loginButton.hidden = false
        }
    }
    
    @IBAction func authorize(sender: AnyObject) {
        if let url = loginUrl {
            self.openURL(url)
        }
    }
    
    func updateAfterFirstLogin(){
        loginButton.hidden = true
        let userDefaults = NSUserDefaults.standardUserDefaults()
        if let sessionObj:AnyObject = userDefaults.objectForKey("SpotifySession"){
            let sessionDataObj = sessionObj as! NSData
            let firstTimeSession = NSKeyedUnarchiver.unarchiveObjectWithData(sessionDataObj) as! SPTSession
            self.session = firstTimeSession
            playUsingSession(firstTimeSession)
        }
    }
    
    func setup() {
        SPTAuth.defaultInstance().clientID = clientId
        SPTAuth.defaultInstance().redirectURL = NSURL(string: callbackUrl)
        SPTAuth.defaultInstance().requestedScopes = [SPTAuthStreamingScope] as [AnyObject]
        loginUrl = SPTAuth.defaultInstance().loginURL
    }
    
    func openURL(url: NSURL) {
        if UIApplication.sharedApplication().openURL(url) {
            if SPTAuth.defaultInstance().canHandleURL(url) {
                SPTAuth.defaultInstance().handleAuthCallbackWithTriggeredAuthURL(url, callback: {
                    (error, session) in
                    if error != nil {
                        print("*** Auth error \(error)")
                        return
                    }
                    self.playUsingSession(session)
                })
            }
        }
    }
    
        func playUsingSession(session: SPTSession) {
            if player == nil {
                player = SPTAudioStreamingController(clientId: SPTAuth.defaultInstance().clientID)
                player?.playbackDelegate = self
            }
            
                player?.loginWithSession(session, callback: {
                    error in
                    if error != nil {
                        print("*** Logging in got error: \(error)")
                        return
                    }
                    
                    let trackURI = NSURL(string: "spotify:track:58s6EuEYJdlb0kO7awm3Vp")
                    if let player = self.player { player.playURIs([trackURI!], withOptions: nil, callback: { 
                        error in
                        if error != nil { 
                            print("*** Starting playback got error: \(error)") 
                        }
                        return
                    }) 
                    } 
                })
}
    
    func updateCoverArt(){
        if player?.currentTrackMetadata == nil {
            artworkImageView.image = UIImage()
            return
        }
        

        let uri = player?.currentTrackMetadata[SPTAudioStreamingMetadataAlbumURI] as! String
        
        SPTAlbum.albumWithURI(NSURL(string: uri), session: session) { (error:NSError!, albumObj:AnyObject!) -> Void in
            let album = albumObj as! SPTAlbum
            
            if let imgURL = album.largestCover.imageURL as NSURL! {
                dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), {
                    () -> Void in
                    var error:NSError? = nil
                    var coverImage = UIImage()
                    
                    if let imageData = NSData(contentsOfURL: imgURL){
                        coverImage = UIImage(data: imageData)!
                    }
                    
                    dispatch_async(dispatch_get_main_queue(), { () -> Void in
                        self.artworkImageView.image = coverImage
                    })
                })
            }
        }
    }
    
    func audioStreaming(audioStreaming: SPTAudioStreamingController!, didStartPlayingTrack trackUri: NSURL!) {
        updateCoverArt()
    }

}
