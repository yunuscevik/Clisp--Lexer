# Clisp--Lexer


Proje çalıştırıldıktan sonra main fonksiyonu içerisinde kullanıcıdan input olarak dosya ismi alır.

"file name" parametresi alan lexer fonksiyonu çağırılır ve kullanıcıdan alınan dosya ismi bu parametreye verilir.

Klasör içerisinde "g++Sample.coffee" dosyası ile test işlemi gerçekleştirilmiştir ve çıktı klasör içerisinde yer almaktadır.

Ayrıca proje içerisinde yer alan "printList" fonksiyonuna paramete olarak ekrana bastırılacak liste verildiği taktirde 
alt alta formatlanmış bir çıktı elde edilmektedir.

Projenin kod blokları ile ilgili açıklamalar "141044080.cl" dosyası içerisinde yorum satırı olarak belirtilmiştir.

Ayrıca negative integer değerler içinde kontroller yapılmıştır ve gerekli errorler belirtilmiştir.

Sample: 

(deffun sumup (x)
	(if (equal x 0)
		-1001
		(+ x (sumup (- x 1)))
	)
)
	
(sumup 8)


Sample-Output: 
![alt text](https://github.com/yunuscevik/Clisp--Lexer/blob/master/ScreenShot/g%2B%2BSample-Output.png "Logo Title Text 1")


Sample-Error-Output: 
![alt text](https://github.com/yunuscevik/Clisp--Lexer/blob/master/ScreenShot/g%2B%2BSample-Error-Output.png "Logo Title Text 1")
