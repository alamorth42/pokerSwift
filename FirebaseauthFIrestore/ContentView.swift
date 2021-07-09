//
//  ContentView.swift
//  FirebaseauthFIrestore
//
//  Created by Bilel Hattay on 05/07/2021.
//

import SwiftUI
import FirebaseAuth
import FirebaseFirestore


struct Joueur {
    var name: String
    var stack: Int
    var Card1: String
    var Card2: String
    var show: Bool
}

struct Board {
    var Flop1: String
    var Flop2: String
    var Flop3: String
    var Turn: String
    var River: String
}

class ViewModelCard: ObservableObject {
    
    let auth = Auth.auth()
    let db = Firestore.firestore()
    
    @State var couleur = ["C", "H", "S", "D"]
    @State var number = ["2", "3", "4", "5", "6", "7", "8", "9", "10", "J", "Q", "K", "A"]
    
    @Published var Joueur1 = Joueur(name: "Achille", stack: 50, Card1: "red_back", Card2: "red_back", show: true)
    @Published var Joueur2 = Joueur(name: "Bilel", stack: 50, Card1: "red_back", Card2: "red_back", show: false)
    @Published var Joueur3 = Joueur(name: "Momo", stack: 50, Card1: "red_back", Card2: "red_back", show: false)
    @Published var Joueur4 = Joueur(name: "Niko", stack: 50, Card1: "red_back", Card2: "red_back", show: false)
    
    @Published var board = Board(Flop1: "", Flop2: "", Flop3: "", Turn: "", River: "")
    
    @Published var ShowFlop = false
    @Published var ShowTurn = false
    @Published var ShowRiver = false
    
    
    // Variable pr changer de vue et pr auth
    var isSignedIn: Bool {
        return auth.currentUser != nil
    }
    
    @Published var signIn: Bool = false
    @Published var inGame: Bool = false
    @Published var errorAlert = ""
    @Published var ShowingAlert = false
    
    
    @Published var MainJoueur = ""
    
    var RealTurn = ""
    var RealRiver = ""
    
    func ShuffleCard() {
        Joueur1.Card1 = "\(String(describing: number.randomElement()!))" + "\(String(describing: couleur.randomElement()!))"
        Joueur1.Card2 = "\(String(describing: number.randomElement()!))" + "\(String(describing: couleur.randomElement()!))"
        
        Joueur2.Card1 = "\(String(describing: number.randomElement()!))" + "\(String(describing: couleur.randomElement()!))"
        Joueur2.Card2 = "\(String(describing: number.randomElement()!))" + "\(String(describing: couleur.randomElement()!))"
        
        Joueur3.Card1 = "\(String(describing: number.randomElement()!))" + "\(String(describing: couleur.randomElement()!))"
        Joueur3.Card2 = "\(String(describing: number.randomElement()!))" + "\(String(describing: couleur.randomElement()!))"
        
        Joueur4.Card1 = "\(String(describing: number.randomElement()!))" + "\(String(describing: couleur.randomElement()!))"
        Joueur4.Card2 = "\(String(describing: number.randomElement()!))" + "\(String(describing: couleur.randomElement()!))"
    }
    
    func ShowCard() {
        Joueur2.show = true
        Joueur3.show = true
        Joueur4.show = true
    }
    
    func HideCard() {
        Joueur2.show = false
        Joueur3.show = false
        Joueur4.show = false
    }
    
    func BringFlop() {
        board.Flop1 = "\(String(describing: number.randomElement()!))" + "\(String(describing: couleur.randomElement()!))"
        board.Flop2 = "\(String(describing: number.randomElement()!))" + "\(String(describing: couleur.randomElement()!))"
        board.Flop3 = "\(String(describing: number.randomElement()!))" + "\(String(describing: couleur.randomElement()!))"
        
        board.Turn = "red_back"
        board.River = "red_back"
        RealTurn = "\(String(describing: number.randomElement()!))" + "\(String(describing: couleur.randomElement()!))"
        RealRiver = "\(String(describing: number.randomElement()!))" + "\(String(describing: couleur.randomElement()!))"
        ShowFlop = true
    }
    
    func BringTurn() {
        board.Turn = RealTurn
        ShowTurn = true
    }
    
    func BringRiver() {
        board.River = RealRiver
        ShowRiver = true
    }
    
    // Auth
    
    // Fonction de Base Authentification
      func SignIn(email: String, password: String) {
          auth.signIn(withEmail: email, password: password) { [weak self] (result, error) in
              guard result != nil, error == nil else {
                  
                  // Sign In FAILED
                  print(error?.localizedDescription)
                  self?.errorAlert = error?.localizedDescription ?? ""
                  self?.ShowingAlert = true
                  return
              }
              
              // Sign IN SUCCEED
              DispatchQueue.main.async {
                  self?.signIn = true
                  self?.inGame = true
              }
          }
      }
      
      func SignUp(email: String, password: String, Pseudo: String) {
          auth.createUser(withEmail: email, password: password) { [weak self] (result, error) in
              guard result != nil, error == nil else {
                  
                  // Sign In FAILED
                  print(error?.localizedDescription)
                  self?.errorAlert = error?.localizedDescription ?? ""
                  self?.ShowingAlert = true
                  return
              }
              
              // Sign IN SUCCEED
              DispatchQueue.main.async {
             //     self?.SetupDataSignUp(Pseudo: Pseudo)
                  self?.signIn = true
                  self?.inGame = true
              }
          }
      }
      
//    func SetupDataSignUp(Pseudo: String) {
//
//
//        let InfosUsersData: [String: Any] = [
//            "Pseudo": Pseudo
//        ]
//
//        db.collection("InfosUsers").document(auth.currentUser!.uid).setData(InfosUsersData, merge: true) { err in
//            if let err = err {
//                print("Error writing document: \(err)")
//                self.errorAlert = err.localizedDescription
//                self.ShowingAlert = true
//            } else {
//                print("Document successfully written InfosUsers!")
//
//                // Ref infos users inutile si on utilise auth.currentUsers.uid
//                var InfosUsersRef: DocumentReference
//                let documentRefString = self.db.collection("InfosUsers").document(self.auth.currentUser!.uid)
//                InfosUsersRef = self.db.document(documentRefString.path)
//
//                let UsersData: [String: Any] = [
//                    "Pseudo": Pseudo,
//                    "Username": Username,
//                    "Infos": InfosUsersRef
//                ]
//
//                self.db.collection("Users").document(self.auth.currentUser!.uid).setData(UsersData, merge: true) { err in
//                    if let err = err {
//                        print("Error writing document: \(err)")
//                        self.errorAlert = err.localizedDescription
//                        self.ShowingAlert = true
//                    } else {
//                        print("Document successfully written USERS!")
//                    }
//                }
//
//            }
//        }
//    }
      func SignOut() {
          
          do {
              try auth.signOut()
          } catch {
              // Sign Out failed
              print("error sign out")
              return
          }
          
          signIn = false
      }
    
    
}

struct ContentView: View {
    
    @EnvironmentObject var ViewModel : ViewModelCard
    
    var body: some View {
        
        SwitchFiltresView().onAppear {
            self.ViewModel.signIn = self.ViewModel.isSignedIn
        }
    }
    
    func SwitchFiltresView() -> AnyView {
        if (self.ViewModel.signIn == true) {
            
            if (self.ViewModel.inGame == true) {
                return AnyView(GameView())
            } else {
                return AnyView(LobbyView())
            }
        }
        else {
           // return AnyView(SignUpView())
            return AnyView(LobbyView())
        }
    }
}

struct SignUpView: View {
    
    @EnvironmentObject var ViewModel : ViewModelCard
    
    @State var email = ""
    @State var password = ""
    @State var username = ""
    
    var body: some View {
        VStack {
            TextField("email", text: $email).multilineTextAlignment(.center)
            TextField("password", text: $password).multilineTextAlignment(.center)
            TextField("username", text: $username).multilineTextAlignment(.center)
            HStack {
                Spacer()
                Button {
                    if (email != "" && password != "" && username != "") {
                        self.ViewModel.SignUp(email: email, password: password, Pseudo: username)
                    } else {
                        print("Error")
                    }
                } label: {
                    Text("S'inscrire")
                }
                Spacer()
                Button {
                    if (email != "" && password != "") {
                        self.ViewModel.SignIn(email: email, password: password)
                    } else {
                        print("Error")
                    }
                } label: {
                    Text("Se connecter")
                }
                Spacer()
            }.padding(.top, 20)
            Spacer()
            
        }.padding(.top, 20)
    }
}
struct LobbyView: View {
    
    @EnvironmentObject var ViewModel : ViewModelCard
    
    @State var CreateGame = false
    @State var JoinGame = false
    
    @State var IDPartiSearch = ""
    @State var Message = ""
    
    var body: some View {
        ZStack {
            HStack(spacing: 50) {
                Button {
                    self.CreateGame = true
                    
                    // Creer une partie ds la DB + mettre un observer dessus pour voir les inscriptions
                } label: {
                    Text("Creer")
                }
                Button {
                    self.JoinGame = true
                } label: {
                    Text("Rejoindre")
                }

            }
            VStack(spacing: 15) {
                Text("ID de la partie")
                Text("Joueur 1: \(self.ViewModel.Joueur1.name)")
                Text("Joueur 2: \(self.ViewModel.Joueur2.name)")
                Text("Joueur 3: \(self.ViewModel.Joueur3.name)")
                Text("Joueur 4: \(self.ViewModel.Joueur4.name)")
                Button {
                    self.ViewModel.inGame = true
                    self.ViewModel.signIn = true
                } label: {
                    Text("Lancer la Game")
                }
            }.frame(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height).offset(y: self.CreateGame == true ? 0 : UIScreen.main.bounds.height).animation(.default).background((self.CreateGame ? Color.gray : Color.clear).onTapGesture {
                self.CreateGame.toggle()
            })
            VStack {
                TextField("Entrez l'ID de la partie", text: $IDPartiSearch).multilineTextAlignment(.center).padding(.top, 50)
                Button {
                    self.ViewModel.inGame = true
                    self.ViewModel.signIn = true
                    
                    // Si c'est bien rejoint mettre dans Message "Vous avez bien rejoin la partie elle est en attente de lancement puis mettre un obersever dessus pour savoir quyand elle commence pr mettre la bonne vue"
                } label: {
                    Text("Rejoindre")
                }.padding(.top, 20)
                Text(Message).padding(.top, 20)
                Spacer()
            }.frame(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height).offset(y: self.JoinGame == true ? 0 : UIScreen.main.bounds.height).animation(.default).background((self.JoinGame ? Color.gray : Color.clear).onTapGesture {
                self.JoinGame.toggle()
            })
        }.edgesIgnoringSafeArea(.all)
    }
}

struct GameView: View {
    
    @EnvironmentObject var ViewModel : ViewModelCard
    
    var body: some View {
        ZStack {
            //Image("projecteur").resizable().frame(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height)
            Image("table").resizable().padding(.bottom, 100).padding(.leading, 120).padding(.trailing, 120).padding(.top, 80)
            VStack(spacing: 0) {
                HStack {
                    HStack {
                        Image(ViewModel.Joueur4.show == true ? ViewModel.Joueur4.Card1: "red_back").resizable().frame(width: 50, height: 70)
                        Image(ViewModel.Joueur4.show == true ? ViewModel.Joueur4.Card2: "red_back").resizable().frame(width: 50, height: 70)
                    }
                    VStack {
                        Text(ViewModel.Joueur4.name)
                        Text("\(ViewModel.Joueur4.stack) EUROS")
                    }
                }.padding(.top, 20)
                Spacer()
                HStack {
                    VStack {
                        HStack {
                            Image(ViewModel.Joueur3.show == true ? ViewModel.Joueur3.Card1: "red_back").resizable().frame(width: 50, height: 70)
                            Image(ViewModel.Joueur3.show == true ? ViewModel.Joueur3.Card2: "red_back").resizable().frame(width: 50, height: 70)
                        }
                        Text(ViewModel.Joueur3.name)
                        Text("\(ViewModel.Joueur3.stack) EUROS")
                    }
                    Spacer()
                    VStack {
                        Spacer()
                        HStack {
                            Image(ViewModel.ShowFlop == true ? ViewModel.board.Flop1: "").resizable().frame(width: 50, height: 70)
                            Image(ViewModel.ShowFlop == true ? ViewModel.board.Flop2: "").resizable().frame(width: 50, height: 70)
                            Image(ViewModel.ShowFlop == true ? ViewModel.board.Flop3: "").resizable().frame(width: 50, height: 70)
                            Image(ViewModel.ShowFlop == true ? ViewModel.board.Turn: "").resizable().frame(width: 50, height: 70)
                            Image(ViewModel.ShowFlop == true ? ViewModel.board.River: "").resizable().frame(width: 50, height: 70)
                        }
                        Spacer()
                        Spacer()
                    }
                    Spacer()
                    VStack {
                        HStack {
                            Image(ViewModel.Joueur2.show == true ? ViewModel.Joueur2.Card1: "red_back").resizable().frame(width: 50, height: 70)
                            Image(ViewModel.Joueur2.show == true ? ViewModel.Joueur2.Card2: "red_back").resizable().frame(width: 50, height: 70)
                        }
                        Text(ViewModel.Joueur2.name)
                        Text("\(ViewModel.Joueur2.stack) EUROS")
                    }
                }.padding(.leading, 35).padding(.trailing, 35).padding(.top, 20)
                Spacer()
                HStack {
                    HStack {
                        Image(ViewModel.Joueur1.Card1).resizable().frame(width: 50, height: 70)
                        Image(ViewModel.Joueur1.Card2).resizable().frame(width: 50, height: 70)
                    }
                    VStack {
                        Text(ViewModel.Joueur1.name)
                        Text("\(ViewModel.Joueur1.stack) EUROS")
                    }
                }.padding(.bottom, 20)
                
            }.frame(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height).animation(.linear)
            VStack {
                Spacer()
                HStack {
                    Button(action: {
                        if (ViewModel.Joueur2.show == true) {
                            ViewModel.HideCard()
                        } else {
                            ViewModel.ShowCard()
                        }
                    }, label: {
                        Text("Show")
                    }).frame(height: 30).padding(.leading, 30)
                    Button(action: {
                        ViewModel.BringFlop()
                    }, label: {
                        Text("Flop")
                    }).frame(height: 30)
                    Button(action: {
                        ViewModel.BringTurn()
                    }, label: {
                        Text("Turn")
                    }).frame(height: 30)
                    Button(action: {
                        ViewModel.BringRiver()
                    }, label: {
                        Text("River")
                    }).frame(height: 30)
                    Spacer()
                }
                HStack {
                    Button(action: {
                        ViewModel.ShuffleCard()
                    }, label: {
                        Text("Shuffle")
                    }).frame(height: 30).padding(.leading, 30)
                    Spacer()
                }.padding(.bottom, 20)
            }
        }
    }
}


