//
//  SinglePlaylistViewController.swift
//  NotraMuse
//
//  Created by Nelson  on 11/22/22.
//

import UIKit
import Parse
import AlamofireImage
import AVFoundation

class SinglePlaylistViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, CellDeleteDelegate {
    

    @IBOutlet weak var tableView: UITableView!
    
    var playlist: PFObject!
    var tracks = [PFObject]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
    }
    
    override func viewDidAppear(_ animated: Bool) {
        tableView.delegate = self
        tableView.dataSource = self
        print("On the new detail page")
        print(playlist as Any)
        userTrackPlaylist()
    }
    
    func Deletrack() {
        print("Doing the reload")
        userTrackPlaylist()
    }
    
    func userTrackPlaylist(){
        let query = PFQuery(className: "PlaylistAlbumTrack")
        
        query.whereKey("userID", equalTo: PFUser.current()!);
        query.whereKey("userPlaylistAlbumID", equalTo: playlist!);
        
        query.findObjectsInBackground{ (userTracks, error) in
                if error == nil {
                    print(userTracks! as Any)
                    self.tracks = userTracks!
                    self.tableView.reloadData()
                }else{
                    print("Error during request of tracks")
                }
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tracks.count + 1
    }
        
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.row == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "SinglePlaylistInfoTableViewCell", for: indexPath) as! SinglePlaylistInfoTableViewCell
            cell.playlistLabel.text = playlist["namePlaylist"] as? String
            let playlistImg = playlist["playlistImageURL"] as! String
            let url = URL(string: playlistImg)!
            cell.playlistImage.af.setImage(withURL: url)
            cell.usernameLabel.text = playlist["creatorName"] as? String
            return cell
        }
        else{
            let cell = tableView.dequeueReusableCell(withIdentifier: "SinglePlaylistSongTableViewCell", for: indexPath) as! SinglePlaylistSongTableViewCell
            let currentTrack = tracks[indexPath.row - 1]
            let duration = currentTrack["trackDurationTime"] as? String
            
            print(duration as Any)
            cell.delegate = self
            cell.songDurationLabel.text = currentTrack["trackDurationTime"] as? String
            cell.songTitleLabel.text = currentTrack["trackName"] as? String
            cell.artistNameLabel.text = currentTrack["trackCreatorName"] as? String
            let trackImageURL = currentTrack["trackPosterURL"] as! String
            let url = URL(string: trackImageURL)!
            cell.AlbumImage.af.setImage(withURL: url)
            cell.track = currentTrack
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.row == 0{
            
            return 330
        } else{
            let height = (view.frame.size.height - 88) / 8
            return height
        }
        
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
        
        let cell = sender as! SinglePlaylistSongTableViewCell
        let indexPath = tableView.indexPath(for: cell)!
        
        let currentTrack = tracks[indexPath.item - 1]
        let trackName = currentTrack["trackName"]
        let trackImage = currentTrack["trackPosterURL"]
        let trackArtist = currentTrack["trackCreatorName"]
        let trackPreviewTrack = currentTrack["trackPreviewURL"]
        
        let PVC = segue.destination as! PlayerViewController
        
        PVC.track = trackName as! String
        PVC.imageURL = trackImage as! String
        PVC.artistName = trackArtist as! String
        PVC.previewTrackURL = trackPreviewTrack as! String
    }
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        cell.backgroundColor = UIColor.clear
    }


    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
