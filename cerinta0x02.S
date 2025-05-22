.data
    filePointer: .space 8
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




    matrix: .space 1600 // 20 * 20 * 4 bytes
                        // = 400 * 4 bytes
                        // = 1600 bytes
    gameSheet: .space 1600

    Input: .asciz "in.txt"
    Output: .asciz "out.txt"
    Read: .asciz "r"
    Write: .asciz "w"
    formatScanf: .asciz "%d"
    formatPrintf: .asciz "%d "
    newLine: .asciz "\n" 
.text
.global main

main:

push $Read
push $Input
call fopen
pop %ebx
pop %ebx

movl %eax, filePointer

citire_date:

pushl $lines
push $formatScanf
push filePointer
call fscanf
pop %ebx
pop %ebx
pop %ebx


pushl $columns
push $formatScanf
push filePointer
call fscanf
pop %ebx
pop %ebx
pop %ebx

addl $2, lines
addl $2, columns

pushl $positionsAlive
push $formatScanf
push filePointer
call fscanf
pop %ebx
pop %ebx
pop %ebx

movl $0, index
for_citire:
   movl index, %ecx
   cmp %ecx, positionsAlive
   je citire_k

   pushl $posLineIndex
   push $formatScanf
   push filePointer
   call fscanf
   pop %ebx
   pop %ebx
   pop %ebx

   pushl $posColumnIndex
   push $formatScanf
   push filePointer
   call fscanf
   pop %ebx
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
push filePointer
call fscanf
pop %ebx
pop %ebx
pop %ebx

push filePointer
call fclose
pop %ebx

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

push $Write
push $Output
call fopen
pop %ebx
pop %ebx

movl %eax, filePointer

movl linesNoBorder, %eax
lea matrix, %edi
movl $1, lineIndex

for_lines:
   // ; for (lineIndex = 1; lineIndex < lines + 1; lineIndex++)
   movl lineIndex, %ecx
   cmp %ecx, linesNoBorder
   je et_exit

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
      push filePointer
      call fprintf
      pop %ebx
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
push $newLine
push filePointer
call fprintf
pop %ebx
pop %ebx

// ;incrementare index si continuare
addl $1, lineIndex
jmp for_lines

et_exit:
push filePointer
call fclose
pop %ebx

mov $1, %eax
mov $0, %ebx
int $0x80