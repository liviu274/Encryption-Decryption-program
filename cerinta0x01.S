.data
    lines: .space 4
    columns: .space 4
    linesNoBorder: .space 4
    columnsNoBorder: .space 4
    lineIndex: .space 4
    columnIndex: .space 4
    positionsAlive: .space 4
    posLineIndex: .space 4
    posColumnIndex: .space 4
    k: .space 4
    index: .space 4
    neighboursAlive: .space 4
    auxValue: .space 4
    o: .space 4
    messageLength: .space 4
    matrixLength: .space 4
    keyIndex: .space 4
    wordIndex: .space 4
    cont: .space 4

    matrix: .space 1600 // 20 * 20 * 4 bytes
                        // = 400 * 4 bytes
                        // = 1600 bytes
    gameSheet: .space 1600

    key: .byte 1
    crypted: .space 4
    message: .space 20

    formatScanfString: .asciz "%s"
    formatScanf: .asciz "%d"
    formatScanfHexa: .asciz "%X"
    formatPrintf: .asciz "%d "
    formatPrintfString: .asciz "%s"
    formatPrintfHexa: .asciz "%02X"
    formatDecriptare: .asciz "%02X "
    newLine: .asciz "\n" 
    beginHexa: .asciz "0x"
.text
.global main

main:

citire_date:

pushl $lines
push $formatScanf
call scanf
pop %ebx
pop %ebx

pushl $columns
push $formatScanf
call scanf
pop %ebx
pop %ebx

addl $2, lines
addl $2, columns


pushl $positionsAlive
push $formatScanf
call scanf
pop %ebx
pop %ebx

movl $0, index
for_citire:
   movl index, %ecx
   cmp %ecx, positionsAlive
   je citire_k

   pushl $posLineIndex
   push $formatScanf
   call scanf
   pop %ebx
   pop %ebx

   pushl $posColumnIndex
   push $formatScanf
   call scanf
   pop %ebx
   pop %ebx

   incl posLineIndex
   incl posColumnIndex

   lea matrix, %edi
   // %eax = posLineIndex * columns + posColumnIndex
   movl $0, %edx
   movl posLineIndex, %eax
   mull columns
   addl posColumnIndex, %eax

   // adaugam valoarea 1 pe pozitia curenta
   movl $1, (%edi, %eax, 4)

   //incrementare index si continuare
   incl index
   jmp for_citire

citire_k:

pushl $k
push $formatScanf
call scanf
pop %ebx
pop %ebx

pushl $o
push $formatScanf
call scanf
pop %ebx
pop %ebx

citire_criptare:

push $message
push $formatScanfString
call scanf
pop %ebx
pop %ebx

// calculam lungimea sirului de caractere

push $message
call strlen
pop %ebx

movl %eax, messageLength

game_engine:

movl lines, %eax
movl %eax, linesNoBorder
movl columns, %eax
movl %eax, columnsNoBorder
decl linesNoBorder
decl columnsNoBorder

movl $0, index
lea matrix, %edi

for_evolutii:
   movl index, %ecx 
   cmp %ecx, k
   je afisare

   movl $1, lineIndex

   for_lines_evolutii:
      // ; for (lineIndex = 1; lineIndex < lines + 1; lineIndex++)
      movl lineIndex, %ecx
      cmp %ecx, linesNoBorder
      je copiere

      movl $1, columnIndex
      for_columns_evolutii:
         // ;  forul care parcurge coloanele
         movl columnIndex, %ecx
         cmp %ecx, columnsNoBorder
         je cont_for_lines_evolutii

         // ;prelucrarea efectiva
         lea matrix, %edi
         // ;eax = lineIndex * columns + columnIndex

         // ;adunam valorile tuturor vecinilor in neighboursAlive
         // ;incepem cu stanga sus si continuam in sensul
         // ;acelor de ceasornic

         stanga_sus:

            movl $0, neighboursAlive
            decl lineIndex            // ;stanga sus
            decl columnIndex

            movl lineIndex, %eax
            movl $0, %edx
            mull columns
            addl columnIndex, %eax

            movl (%edi, %eax, 4), %edx
            addl %edx, neighboursAlive

         mijloc_sus:
            incl columnIndex       //; mijloc sus

            movl lineIndex, %eax
            movl $0, %edx
            mull columns
            addl columnIndex, %eax

            movl (%edi, %eax, 4), %edx
            addl %edx, neighboursAlive

         dreapta_sus:
            incl columnIndex       //; dreapta sus

            movl lineIndex, %eax
            movl $0, %edx
            mull columns
            addl columnIndex, %eax

            movl (%edi, %eax, 4), %edx
            addl %edx, neighboursAlive

         dreapta:
            incl lineIndex         //; dreapta

            movl lineIndex, %eax
            movl $0, %edx
            mull columns
            addl columnIndex, %eax

            movl (%edi, %eax, 4), %edx
            addl %edx, neighboursAlive

         dreapta_jos:
            incl lineIndex         //; dreapta jos

            movl lineIndex, %eax
            movl $0, %edx
            mull columns
            addl columnIndex, %eax

            movl (%edi, %eax, 4), %edx
            addl %edx, neighboursAlive

         mijloc_jos:
            decl columnIndex     //; mijloc jos

            movl lineIndex, %eax
            movl $0, %edx
            mull columns
            addl columnIndex, %eax

            movl (%edi, %eax, 4), %edx
            addl %edx, neighboursAlive

         stanga_jos:
            decl columnIndex    //; stanga jos

            movl lineIndex, %eax
            movl $0, %edx
            mull columns
            addl columnIndex, %eax

            movl (%edi, %eax, 4), %edx
            addl %edx, neighboursAlive

         stanga:
            decl lineIndex    //; stanga

            movl lineIndex, %eax
            movl $0, %edx
            mull columns
            addl columnIndex, %eax

            movl (%edi, %eax, 4), %edx
            addl %edx, neighboursAlive

         incl columnIndex     //;  RESETARE POZITIE INITIALA

         // ;Verificam valoarea celulei curente
         // ;Continuam pe cazurile pt celula vie sau cea moarta

         movl lineIndex, %eax
         movl $0, %edx
         mull columns
         addl columnIndex, %eax

         movl (%edi, %eax, 4), %edx

         cmp $1, %edx
         je alive

         dead:
            lea gameSheet, %edi

            movl neighboursAlive, %edx
            cmp $3, %edx
            je case_revive
            jmp case_still_dead
            // ;daca avem exact 3 vecini in viata scriem o celula vie, altfel celula ramane moarta

            case_revive:
               movl lineIndex, %eax
               movl $0, %edx
               mull columns
               addl columnIndex, %eax

               movl $1, (%edi, %eax, 4)
               jmp cont_dead

            case_still_dead:
               movl lineIndex, %eax
               movl $0, %edx
               mull columns
               addl columnIndex, %eax

               movl $0, (%edi, %eax, 4)

            cont_dead:

            jmp cont_for_columns_evolutii

         alive:
            lea gameSheet, %edi
            movl neighboursAlive, %edx

            cmp $3, %edx
            jle case_continue    //; vecini C (... , 3]

            case_die:
               movl lineIndex, %eax
               movl $0, %edx
               mull columns
               addl columnIndex, %eax

               movl $0, (%edi, %eax, 4)

               jmp cont_alive

            case_continue:
               cmp $2, %edx    
               jl case_die     //; vecini < 2

               movl lineIndex, %eax
               movl $0, %edx
               mull columns
               addl columnIndex, %eax

               movl $1, (%edi, %eax, 4)

            cont_alive:


         cont_for_columns_evolutii:

         // ;incrementare index si cotinuare
         addl $1, columnIndex
         jmp for_columns_evolutii


   cont_for_lines_evolutii:

      // ;incrementare index si continuare
      addl $1, lineIndex
      jmp for_lines_evolutii

cont_for_evolutii:
   
   copiere:

      movl $1, lineIndex
      for_lines_copy:
         // ; for (lineIndex = 1; lineIndex < lines + 1; lineIndex++)
         movl lineIndex, %ecx
         cmp %ecx, linesNoBorder
         je incrementare_for_evolutii

         movl $1, columnIndex
         for_columns_copy:
            // ;  forul care parcurge coloanele
            movl columnIndex, %ecx
            cmp %ecx, columnsNoBorder
            je cont_for_lines_copy

            // ;prelucrarea efectiva
            // ;eax = lineIndex * columns + columnIndex
            movl lineIndex, %eax
            movl $0, %edx
            mull columns
            addl columnIndex, %eax

            lea gameSheet, %edi    // scoatem valoarea din gameSheet
            movl (%edi, %eax, 4), %ebx
            movl %ebx, auxValue

            lea matrix, %edi        //; o scriem in matricea curenta
            movl auxValue, %ebx
            movl %ebx, (%edi, %eax, 4)

            // ;incrementare index si cotinuare
            addl $1, columnIndex
            jmp for_columns_copy


      cont_for_lines_copy:
         // ;incrementare index si continuare
         addl $1, lineIndex
         jmp for_lines_copy



incrementare_for_evolutii:
   //; incrementare index si continuare

   incl index
   jmp for_evolutii


afisare:

movl linesNoBorder, %eax
lea matrix, %edi
movl $1, lineIndex

for_lines:
   // ; for (lineIndex = 1; lineIndex < lines + 1; lineIndex++)
   movl lineIndex, %ecx
   cmp %ecx, linesNoBorder
   je gasire_caz

   movl $1, columnIndex
   for_columns:
      // ;  forul care parcurge coloanele
      movl columnIndex, %ecx
      cmp %ecx, columnsNoBorder
      je cont_for_lines

      // ;prelucrarea efectiva
      // ;eax = lineIndex * columns + columnIndex
      movl lineIndex, %eax
      movl $0, %edx
      mull columns
      addl columnIndex, %eax
      // ;salvam elementul curent in ebx pentru afisare
      movl (%edi, %eax, 4), %ebx
      // ;afisarea efectiva cu functia printf

      pushl %ebx
      push $formatPrintf
      call printf
      pop %ebx
      pop %ebx

      pushl $0
      call fflush
      pop %ebx

      // ;incrementare index si cotinuare
      addl $1, columnIndex
      jmp for_columns


cont_for_lines:
// ;separator linii
mov $4, %eax
mov $1, %ebx
mov $newLine, %ecx
mov $2, %edx
int $0x80

// ;incrementare index si continuare
addl $1, lineIndex
jmp for_lines

gasire_caz:

movl o, %eax
cmp $1, %eax
je decriptare

criptare:
    // ;afisare format hexa ( 0x )
    push $beginHexa
    push $formatPrintfString
    call printf
    pop %ebx
    pop %ebx

    push $0
    call fflush
    pop %ebx

    // ; calculam lungimea matricei liniarizate
    movl lines, %eax
    movl $0, %edx
    mull columns
    movl %eax, matrixLength

    // ; vom aloca dinamic in memorie chei de criptare
    // ; retinand doar 8 biti din aceasta de care avem nevoie
    // ; pt un caracter
    // ; vom folosi un index de pozitie pe tablou

    movl $0, wordIndex
    movl $0, keyIndex

    for_message:
        movl wordIndex, %ecx
        cmp %ecx, messageLength
        je et_exit

        lea message, %edi
        movb (%edi, %ecx, 1), %bl

        // avem litera curenta inregistrata in ebx
        // incepem sa alocam dinamic cheia

        movl $0, index
        movl $0, key
        movl $0, %edx
        for_key:
            movl index, %ecx
            cmp $8, %ecx
            je cont_for_message

            lea matrix, %edi
            movl keyIndex, %eax
            movb (%edi, %eax, 4), %al  // mutam celula
                                       // suprascriem eax
            orb %al, %dl
            shl $1, %edx

            incl keyIndex
            movl keyIndex, %ecx
            cmp %ecx, matrixLength
            je reset_keyIndex
            jmp increment_for_key

            reset_keyIndex:
                movl $0, keyIndex

            increment_for_key:
                incl index
                jmp for_key
    cont_for_message:

        shr $1, %edx
        
        // facem xor intre litera si cheie pentru a cripta
        xorb %dl, %bl
        // adaugam litera criptta in mesajul final
        

        afisare_mesaj:

            push %ebx
            push $formatPrintfHexa
            call printf
            pop %ebx
            pop %ebx

            pushl $0
            call fflush
            pop %ebx

            movb $0, crypted //; golim variabila

    //; incrementare si continuare
    incl wordIndex
    jmp for_message


decriptare:


et_exit:
mov $1, %eax
mov $0, %ebx
int $0x80