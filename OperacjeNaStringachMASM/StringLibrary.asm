include irvine32.inc
.data

MAX_LENGTH = 100

inputString BYTE MAX_LENGTH+1 DUP (?)
inputStringToCompare BYTE MAX_LENGTH+1 DUP (?)

msgPodajPierwszyString BYTE "Podaj pierwszy string: ", 0
msgPodajDrugiString BYTE "Podaj drugi string: ", 0

firstString BYTE "Pierwszy tekst", 0
secondString BYTE " drugi tekst", 0
resultString BYTE MAX_LENGTH+1 DUP(?)

.code
main PROC
	 ; Wczytaj pierwszy input
	; mov edx, offset msgPodajPierwszyString
	; call writestring

	; mov  edx, offset inputString
	; mov  ecx,MAX_LENGTH
	; call ReadString

	; push offset inputString

	; Wczytaj drugi input (zakomentowac push jak uzywany tylko 1 string)
	; mov edx, offset msgPodajDrugiString
	; call writestring

	; mov  edx, offset inputStringToCompare
	; mov  ecx,MAX_LENGTH
	; call ReadString

	; push offset inputStringToCompare


	; Wywolania metod

	 ; call stringLength
	 ; call WriteInt

	 ; call toupper
	 ; mov edx, offset inputString
	 ; call WriteString

	 ; call strcmp
	 ; call WriteInt

	 ; call stricmp
	 ; call WriteInt

	push offset resultString
	push offset secondString
	push offset firstString

	call strcat

	mov edx, offset resultString
	call WriteString



exit
main ENDP

; Zwraca do eax dlugosc stringa
stringLength PROC
	push ebp
	mov ebp, esp
	mov edx, [ebp+8]
	
	mov eax, 0
	count:
		mov ebx, [edx]
		cmp bl, 0
		je endOfString
		inc edx
		inc eax
	jmp count

	endOfString:
		mov esp, ebp
		pop ebp
		ret
stringLength ENDP

; zamienia w napisie, ktorego adres zostal odlozony na stosie napis
; z zamieninymi wszystkimi malymi literami na wielkie, pozostale
; znaki bez zmian
toupper PROC
	push ebp
	mov ebp, esp
	mov edx, [ebp+8]

	push edx ; przygotuj do stringLength
	call stringLength

	; za³aduj ponownie adres stringa
	mov edx, [ebp+8]

	mov ecx, eax

	capslock:
		mov al, [edx]

		cmp al, 'a'
		jl pass
		cmp al, 'z'
		jg pass

		; konwersja na du¿¹ literê
		sub al, 32
		mov [edx], al

		pass:
			inc edx
	loop capslock

	mov esp, ebp
	pop ebp
	ret
toupper ENDP

; porownuje dwa napisy , ktoruch adresy zostaly odlozone
; na stosie i zwraca w eax 1 gdy sa rowne i 0 gdy rozne
strcmp PROC
	push ebp
	mov ebp, esp
	
	mov edx, [ebp+8]
	mov esi, [ebp+12]

	iterate:
		mov eax, [edx]
		mov ebx, [esi]

		cmp al, 0
		jne compare

		cmp bl, 0
		jne compare

		; jesli rowne
		mov eax, 1
		jmp endCompare

		compare:
			inc edx
			inc esi
			cmp al, bl
			je iterate
			mov eax, 0

	endCompare:
		mov esp, ebp
		pop ebp
		ret
strcmp ENDP

; stricmp - jak wyzej tylko ignoruje wielkosc liter
stricmp PROC
	push ebp
	mov ebp, esp

	; Zamiana na duze litery
	push [ebp+8]
	call toupper

	push [ebp+12]
	call toupper

	; Wrszucamy na stos
	mov edx, [ebp+8]
	push edx

	mov esi, [ebp+12]
	push esi

	call strcmp

	mov esp, ebp
	pop ebp
	ret
stricmp ENDP

; strcat - przed wywolaniem na stosie odlozone s¹ adresy 3 tablic,
; procedura ³¹czy napisy z 2 pierwszych tablic i wpisuje do trzeciej
strcat PROC
    push ebp
    mov ebp, esp

    ; adresy tablic
    mov esi, [ebp + 8]   
    mov edx, [ebp + 12]  
    mov edi, [ebp + 16] 

    ; Kopiowanie pierwszej
    copyFirst:
        mov al, [esi]
        cmp al, 0
        je copySecond
        mov [edi], al
        inc esi
        inc edi
        jmp copyFirst

    ; Kopiowanie drugiej
    copySecond:
        mov al, [edx]
        cmp al, 0
        je endStrcat
        mov [edi], al
        inc edx
        inc edi
        jmp copySecond

    endStrcat:
        mov byte ptr [edi], 0  ; Dodanie znaku konca

    mov esp, ebp
    pop ebp
    ret
strcat ENDP


end main


