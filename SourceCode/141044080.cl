;**********************************
;* CSE341 - Programming Languages *
;* 141044080 Yunus CEVIK 		  *
;* 		- Lexical analysis - 	  *
;**********************************

(setq KEYWORDS '("and" "or" "not" "equal" "append" "concat" "set" "deffun" "for" "while" "if" "exit"))

(setq OPERATORS '("+"  	;PLUS
				  "-"  	;MINUS
				  "/"  	;SLASH
				  "*"  	;ASTERISK
				  "("  	;LEFT_PARENTHESIS
				  ")"  	;RIGHT_PARENTHESIS
				  "**"	;Power
				  )
)
(setq BINARYVALUE '("true" "false"))

; Read file helper function
(defun read-recursive (strIn strOut)
	(let ((char (read-char strIn nil)))
		(unless (null char)
		  (format strOut "~c" char)
		  (read-recursive strIn strOut))
	)
)

; Read file
(defun read-file (fileName)
	(with-open-file (str fileName)
	  	(with-output-to-string (str-Output)
		    (read-recursive str str-Output)
	    	str-Output
    	)
	)
)

; Delete the "" in the list
(defun deleteEmpty (inList outList)
	(setq firstElement (car inList))
	(if (equal firstElement nil)
		outList
		(if (equal firstElement "")
			(deleteEmpty (cdr inList) outList)
			(progn 
				(setq outList (append outList (list firstElement)))
				(deleteEmpty (cdr inList) outList)
			)
		)
	)
)

; Space Tap and Newline to token separator
(defun tokenizer (string &optional (separator '(#\Space #\Tab #\Newline)))
	(deleteEmpty (tokenizer-helper  string separator) '())
)

(defun tokenizer-helper (string &optional (separator '(#\Space #\Tab #\Newline)) (r nil))
  	(let ((n (position separator string
		     :from-end t
		     :test #'(lambda (x y)
			       (find y x :test #'string=)))))
	    (if n
			(tokenizer-helper  (subseq string 0 n) separator (cons (subseq string (1+ n)) r))
		    	(cons string r)
	    )
   	)
)


; The parenthesis are checked and spaces are placed.
(defun check-Parenthesis-And-Add-Space (returnStr readStrList)
	(setq firstElement (car readStrList))
	(if (equal firstElement nil)
		returnStr
		(if (equal (string firstElement) "(")
			(progn
				(setq returnStr (concatenate 'string returnStr (string firstElement)))
				(setq returnStr (concatenate 'string returnStr " "))
				(check-Parenthesis-And-Add-Space returnStr (cdr readStrList))
			)
			(if (equal (string firstElement) ")")
				(progn
					(setq returnStr (concatenate 'string returnStr " "))
					(setq returnStr (concatenate 'string returnStr (string firstElement)))
					(check-Parenthesis-And-Add-Space returnStr (cdr readStrList))
				)
				(progn
					(setq returnStr (concatenate 'string returnStr  (string firstElement)))
					(check-Parenthesis-And-Add-Space returnStr (cdr readStrList))
				)
			)
		)
	)
)
; Identifier control
(defun isIdentifier (strList)
	(setq val (car strList))
	(if (equal val nil)
		t
		(if (or (and (<= (char-code #\a) (char-code val)) (<= (char-code val) (char-code #\z))) (and (<= (char-code #\A) (char-code val)) (<= (char-code val) (char-code #\Z))))
			(isIdentifier (cdr strList))
			nil
		)
	)
)
; Negative integer value control
(defun isNegIntVal (negList)
	(setq val (car negList))
	(if (equal val nil)
		t
		(if (and (<= (char-code #\1) (char-code val)) (<= (char-code val) (char-code #\9)))
			(isPosIntVal (cdr negList))
			nil
		)
	)
)
; Pozitive integer value control
(defun isPosIntVal (posList)
	(setq val (car posList))
	(if (equal val nil)
		t
		(if (and (<= (char-code #\0) (char-code val)) (<= (char-code val) (char-code #\9)))
			(isPosIntVal (cdr posList))
			nil
		)
	)
)
; Integer value control
(defun isIntegerValue (strList)
	(if (equal "-" (string (car strList)))
		(isNegIntVal (concatenate 'list (cdr strList)))
		(isPosIntVal (concatenate 'list strList))
	)
)

; Determines which type of tokens (KEYWORDS, OPERATORS, BINARYVALUE, IDENTIFIER, INTEGERVALUE)
(defun typeCheck (returnList lexerL)
	(setq token (car lexerL))
	(if (equal token nil)
		returnList
		(if (find token KEYWORDS :test #'string=)
			(progn
				(setq returnList (append returnList (list (list "keyword" token))))
				(typeCheck returnList (cdr lexerL))
			)
			(if (find token OPERATORS :test #'string=)
				(progn
					(setq returnList (append returnList (list (list "operator" token))))
					(typeCheck returnList (cdr lexerL))
				)
				(if (find token BINARYVALUE :test #'string=)
					(progn
						(setq returnList (append returnList (list (list "binaryvalue" token))))
						(typeCheck returnList (cdr lexerL))
					)
					(if (isIdentifier (concatenate 'list token))
						(progn
							(setq returnList (append returnList (list (list "identifier" token))))
							(typeCheck returnList (cdr lexerL))
						)
						(if (isIntegerValue (concatenate 'list token))
							(progn
								(setq returnList (append returnList (list (list "integer" token))))
								(typeCheck returnList (cdr lexerL))
							)
							token
						)
					)
				)
			)
		)
	)
)

; A Lexical analysis list is given as output. Line line..
(defun printList (pList)
	(setq val (car pList))
	(if (not (equal val nil))
		(progn
			(write val)
			(terpri)
			(printList (cdr pList))
		)
	)
)

(defun lexer (fileName)
	  
	(setq read-str (read-file fileName))   ; The file name is taken from the user.
	(setq lexerList (tokenizer (check-Parenthesis-And-Add-Space "" (concatenate 'list read-str)))) ; The parenthesis are checked and spaces are placed. Then token operation is performed.
	;(write lexerList)
	;(terpri)
	(terpri)
	(setq resultList (typeCheck '() lexerList)) ; Determines which type of tokens
	(if (listp resultList)	; Error control
		;(printList resultList)
		(write resultList)
		(progn 
			(write-string "Error: ")
			(write resultList)
			(write-string " -> Lexical analysis failed. Because there is an expression that does not conform to the structure of IntegerValue or Identifier.")
			(terpri)
			(write "Usage =>  IntegerValue -> [-]*[1-9]*[0-9]+ OR Id -> [a-zA-Z]+")
		)
	)
)

;; MAIN FUNCTION
(defun main ()
	(write-string "Please entered a file name : ") 
	(lexer (read-line)) ; Call lexer function with input filename
)

;; CALL MAIN FUNCTION
(main)





