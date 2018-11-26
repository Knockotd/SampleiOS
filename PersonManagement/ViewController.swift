//
//  ViewController.swift
//  PersonManagement
//
//  Created by 503-26 on 21/11/2018.
//  Copyright © 2018 person. All rights reserved.
//

import UIKit
import Alamofire
// swift에서 import는 네임스페이스를 가져오는 역할
// java에서 import는 이름을 줄여쓰기 위한 역할
// c에서 include는 파일의 내용을 가져오는 역할
// c나 swift에서는 import나 include를 안 하면 그 기능을 사용할 수 없음
// java는 import를 하지 않고 전체 이름을 이용해서 사용할 수 있음 'java.leng.String'
// html에서 script src 도 c언어의 include 개념입니다.
// c, javascript는 파일을 가져오는 개념이라서 2번하면 구분을 못해서 안된다.
// swift나 java는 2개 해도 상관없다. 경고가 생길 뿐이다.
// Alamofire는 URL 통신을 쉽게 할 수 있도록 해주는 외부 라이브러리 이고 항상 설치해서 사용해야한다.
class ViewController: UIViewController {
    
    var window : UIWindow?
    
    var id : String! //!나 ?는 나주에 값을 저장할 수 있도록 선언
    //!나 ?가 없으면 무조건 값을 가지고 있어야 합니다.
    var nickname : String!
    var image : String!
    
    //UserDefaults 객체에 대한 참조 변수
    var userDefaults : UserDefaults!
    
    @IBOutlet weak var loginbtn: UIButton!
    @IBAction func login(_ sender: Any) {
        if loginbtn.title(for: .normal) == "로그인"{
            //로그인 대화상자 생성
            let alert = UIAlertController(title: "로그인", message: nil, preferredStyle: .alert)

            //대화상자에 입력을 받을 수 있는 텍스트 필드를 2개 추가
            //입력필드 추가
            alert.addTextField(){(tf) in tf.placeholder="아이디를 입력하세요"}
            alert.addTextField(){(tf) in tf.placeholder="비밀번호를 입력하세요"
                tf.isSecureTextEntry = true}
            //버튼 생성
            alert.addAction(UIAlertAction(title: "취소", style: .cancel))
            alert.addAction(UIAlertAction(title: "로그인", style: .default){(_) in //입력한 id와 pw를 가져오기
                let id = alert.textFields![0].text
                let pw = alert.textFields![1].text
                //웹에 요청
                let request = Alamofire.request("http://192.168.0.215:8080/aisdugo/crowds/login?id=\(id!)&pw=\(pw!)", method: .get, parameters: nil)
                //결과 사용
                request.responseJSON{
                    response in
                    //결과 확인
                    print(response.result.value!)
                    if let jsonObject = response.result.value as? [String:Any]{
                        //result 키의 내용을 가져오기
                     let result = jsonObject["result"] as! NSDictionary
                        let id = result["id"] as! NSString
                        if id == "NULL"{
                            self.title = "로그인실패"
                        }else{
                            //로그인 성공했을 때 로그인 정보 저장
                            self.userDefaults.set(id as String, forKey: "id")
                            self.userDefaults.set(result["nickname"] as! String, forKey: "nickname")
                            self.userDefaults.set(result["image"] as! NSString, forKey: "image")
                            print(self.userDefaults.object(forKey: "image")!)
                            self.title = "\(self.userDefaults.object(forKey: "nickname")!)님 로그인"
                            //image에 저장된 데이터로 서버에서 이미지를 다운로드 받아 타이틀로 설정
                            let imagerequest = Alamofire.request("http://192.168.0.215:8080/aisdugo/images/\(self.userDefaults.object(forKey: "image")!)", method: .get, parameters: nil)
                            imagerequest.response{
                                response in
                                //다운로드 받은 데이터를 가지고 Image 생성
                                let images = UIImage(data: response.data!)
                                //이미지를 출력하기 위해서 ImageView 만들기
                                let imageView = UIImageView.init(frame: CGRect.init(x: 0, y: 0, width: 40, height: 40))
                                imageView.contentMode = .scaleAspectFit
                                imageView.image = images
                                //네비게이션 바에 배치
                                self.navigationItem.titleView = imageView
                            }
                            self.loginbtn.setTitle("로그아웃", for: .normal)
                        }
                    }
                    }
            })
            //로그인 대화상자 출력
            self.present(alert, animated: true)
            
        }else{
            //로그인 정보를 삭제
            id = nil
            userDefaults.set(id, forKey: "id")
            nickname = nil
            image = nil
            
            //네비게이션 바의 타이틀과 버튼의 타이틀을 변경
            self.title = "로그인이 되어있지 않음"
            loginbtn.setTitle("로그인", for: .normal)
        }
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        //viewDidLoad에 대한 참조를 생성
        userDefaults = UserDefaults.standard
        
    }
    @IBAction func foodpoisoningAPI(_ sender: Any) {
        //하위 뷰 컨트롤러 객체 만들기
        let foodPoisoningController = self.storyboard?.instantiateViewController(withIdentifier: "FoodPoisoningController")
        
        //네비게이션 컨트롤러가 있을 때는 바로 푸시를 하면 됩니다.
        //없을 때는 네비게이션 컨트롤러를 만들고 네비게이션 컨트롤러를 present로 출력
        //뒤로 버튼을 새로 만들기
        
        self.navigationItem.backBarButtonItem = UIBarButtonItem.init(title: "메인화면", style: .done, target: nil, action: nil)
        //네비게이션으로 이동
        self.navigationController?.pushViewController(foodPoisoningController!, animated: true)
    }

    override func viewWillAppear(_ animated: Bool) {
        //상위 클래스의 메소드를 호출
        super.viewWillAppear(animated)
        
        userDefaults.set(id, forKey: "id")
        //로그인 여부 확인
        if userDefaults.object(forKey: "id") == nil{
            self.title = "로그인이 되어있지 않음"
            self.loginbtn.setTitle("로그인", for: .normal)
        }else{
            self.title = "로그인 된 상태"
            self.loginbtn.setTitle("로그아웃", for: .normal)
        }
    }


}

