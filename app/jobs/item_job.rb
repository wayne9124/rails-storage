class ItemJob < ApplicationJob
  queue_as :default

  def perform(*args)
    domain = "http://aomp.judicial.gov.tw/abbs/wkw/"

    page = 1
    #taipei first page
    house = "http://aomp.judicial.gov.tw/abbs/wkw/WHD2A03.jsp?pageTotal=19&pageSize=15&rowStart=31&saletypeX=1&proptypeX=C52&courtX=TPD&order=odcrm&query_typeX=session&saleno=&hsimun=all&ctmd=all&sec=all&crmyy=&crmid=&crmno=&dpt=&saledate1=&saledate2=&minprice1=&minprice2=&sumprice1=&sumprice2=&area1=&area2=&registeno=&checkyn=all&emptyyn=all&order=odcrm&owner1=&landkd=&rrange=%A4%A3%A4%C0&comm_yn=&pageNow=#{page}&CA383A3EB717375B0E5B47314BB1495E=5813EFB19879C96B4FFCF0B7E09FB1D1"
    land = "WHD2A03.jsp?5E533D8BF77BAB4CB6852A601A7F83DF=651298826A83CED5ED05F54C9FF00C0E&hsimun=all&ctmd=all&sec=all&saledate1=&saledate2=&crmyy=&crmid=&crmno=&dpt=&minprice1=&minprice2=&saleno=&area1=&area2=&landkd=&checkyn=all&emptyyn=all&rrange=%A4%A3%A4%C0&comm_yn=&owner1=&order=odcrm&courtX=TPD&proptypeX=C51&saletypeX=1&query_typeX=db"

    url = domain+house
    doc = Nokogiri::HTML(open(url)).css("body table table")[1].css("tr")

    # puts doc[1]
    #.css("td")[4].css("a").attr("href").value
    # len = doc.length
    # puts doc[1].css("td")[4].css("a").attr("href").value
    domain_url = [] #存物件網址
    doc.each_with_index do |url, index|
      #第零比資料沒有東西
      domain_url << domain + doc[index].css("td")[4].css("a").attr("href").value if index > 0
    end
    domain_url.each_with_index {|u, i| catch_data(domain_url[i]) }

    # doc = Nokogiri::HTML(open(domain+house)).css("tbody td a").attr("href").text
    # puts doc
  end
  def catch_data(url)
    json = {}
    doc = Nokogiri::HTML(open(url)).css("body font pre").text
    # │1 │新北市│深坑區  │萬順寮│草地尾│16-16
    # │2 │新X市│深A區  │萬B寮│c地尾 │16-16   Array
    address =  doc.scan(/│\d\s+│\p{word}+│\p{word}+\s+│\p{word}+\s*│\p{word}+\s*│\p{word}+-?\p{word}*\s+│/)
    address.map {|ad| ad.gsub!(" ", "")}

    address.each do |a|
      str = "" # init
      tmp = a.split("│").reverse
      tmp[0] += "地號"; tmp[1] += "小段"; tmp[2] += "段"
      tmp.reverse.each_with_index do |k,v|
        str += k if v > 1
      end
      #update column will OK
      puts str
    end
    json[:word] = "#{doc.match(/忠(\p{word}+)司/)[1]}#{doc.match(/執\p{word}+字/)}"
  end
end
