//
//  FoodPoisoningController.swift
//  PersonManagement
//
//  Created by 503-26 on 26/11/2018.
//  Copyright © 2018 person. All rights reserved.
//

import UIKit

class FoodPoisoningController: UITableViewController {
    
    // 현재 출력 중인 마지막 페이지 번호를 저장할 변수를 선언
    var page = 1
    //데이터를 다운로드 받는 메소드
    func download(){
        //URL을 생성해서 다운로드 받기
        //다운로드 받을 URL 만들기
        let url = "http://apis.data.go.kr/B550928/dissForecastInfoSvc/getDissForecastInfo?serviceKey=m%2BAB97QjVAk8g8IGN9PTm5H%2BdfLsRRkZVWVXfhPqgvcko5uRCLo7ai4ak%2FS57jyNOqKLxq7xiDzPRyUqDrQbZw%3D%3D&numOfRows=10&pageNo=\(page)&type=json&dissCd=3&znCd=28"
        let apiURI : URL! = URL(string: url)
        
        //REST API를 호출
        let apidata = try! Data(contentsOf: apiURI)
        
        //데이터 전송 결과를 로그로 출력
        //let log = NSString(data: apidata, encoding: String.Encoding.utf8.rawValue)! as String
        //print("API Result=\( log )")
        
        //예외처리
        do{
            //전체 데이터를 디셔너리로 만들기
            let apiDict =
                try JSONSerialization.jsonObject(with: apidata, options: []) as! NSDictionary
            //response 키의 값을 디셔너리로 가져오기
            let response = apiDict["response"] as! NSDictionary
            let body = response["body"] as! NSDictionary
            let items = body["items"] as! NSArray
            //배열을 순회
            for row in items{
                //하나하나 가져오는 걸 디셔너리로 풀어줌
                let imsi = row as! NSDictionary
                
                //실수로 바꿀 때는 (~~ as! NSString).doubleValue
                //자료형은 API의 것으로 따르는데 API에서 안 알려주는 경우도 있어서 에러를 봐가면서 수정해야한다.
                //옵셔널은 사용할 때 벗기기
                var foodPoisoning = FoodPoisoning()
                foodPoisoning.day = imsi["dt"] as? String
                foodPoisoning.city = imsi["znCd"] as? String
                foodPoisoning.cnt = imsi["cnt"] as? Int
                let t = imsi["risk"]
                foodPoisoning.risk = "\(t!)"
                foodPoisoning.des = imsi["dissRiskXpln"] as? String
                //이미지 URL을 가지고 이미지 데이터를 다운로드 받아서 저장
                /*
                 let url = URL(string: foodPoisoning.~!)
                 //데이터 다운로드
                 let imageData = try Data(contentsOf: url!)
                 //저장
                 movie.image = UIImage(data: imageData)
                 */
                self.list.append(foodPoisoning)
                //self.list.insert(foodPoisoning, at: 0)
            }
            //print(self.list)
            //데이터 뷰 재출력 -- 굉장히 중요
            self.tableView.reloadData()
            
            //전체 데이터를 표시한 경우에는 refreshController을 숨김
            let totalCount = (body["totalCount"] as? NSInteger)!
            if totalCount <= self.list.count{
                self.refreshControl?.isHidden = true
            }
        }catch{
            print("파싱 예외 발생")
        }
    }
    
    //refreshControl 이 화면에 보여질 때 호출될 메소드
    @objc func hadleRequest(_ refreshControl:UIRefreshControl){
        //페이지 번호를 1 증가 시키고 데이터를 다시 받아오기
        self.page = self.page+1
        self.download()
        //refreshControl 애니메이션 중지
        refreshControl.endRefreshing()
    }
    //파싱한 결과를 저장할 List 변수 - 지연생성 이용
    //지연생성 - 처음부터 만들어두지 않고 처음 사용할 때 생성
    lazy var list : [FoodPoisoning] = {
        var datalist = [FoodPoisoning]()
        return datalist
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.refreshControl = UIRefreshControl()
        self.refreshControl?.addTarget(self, action: #selector(FoodPoisoningController.hadleRequest(_:)), for: .valueChanged)
        self.refreshControl?.tintColor = UIColor.red
    }
    
    //화면에 뷰가 보여질 때 호출되는 메소드
    override func viewDidAppear(_ animated: Bool) {
        //추상 메소드가 아니면 상위 클래스의 메소드를 호출하고 기능 추가
        super.viewDidAppear(animated)

    }

    // MARK: - Table view data source
    //섹션의 개수를 설정하는 메소드
    //없으면 1을 리턴하는 것으로 간주
    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }
    //그룹 별 행의 개수를 설정하는 메소드
    //없으면 에러 -- 필수라서
    //단, TableViewController의 경우는 이 메소드도 없으면 1을 리턴한 것으로 간주
    //배열의 개수로 리턴
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return list.count
    }
    //셀의 모양을 만드는 메소드 -- 필수
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        //사용자 정의 셀 만들기
        let cell = tableView.dequeueReusableCell(withIdentifier: "FoodPoisoningCell", for: indexPath) as! FoodPoisoningCell
        //행번호에 해당하는 데이터 찾기
        let foodPoisoning = self.list[indexPath.row]
        //데이터 출력
        cell.lblDay.text = foodPoisoning.day!
        cell.lblCity.text = foodPoisoning.city!
        cell.lblRisk.text = foodPoisoning.risk!
        cell.lblCnt.text = "\(foodPoisoning.cnt!)"
        cell.lblDes.text = foodPoisoning.des!
        //실수는
        //cell.~.text = "\(~.~)"
        //이미지는
        //cell.~.image = ~.~!
        
        self.navigationItem.title = "식중독 예측 정보"
        return cell
    }
    //셀의 높이를 설정하는 메소드
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat{
        return 96
    }
    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
