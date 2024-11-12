
.globl str_ge, recCheck

.data

maria:    .string "Maria"
markos:   .string "Markos"
marios:   .string "Marios"
marianna: .string "Marianna"

.align 4  # make sure the string arrays are aligned to words (easier to see in ripes memory view)

# These are string arrays
# The labels below are replaced by the respective addresses
arraySorted:    .word maria, marianna, marios, markos

arrayNotSorted: .word marianna, markos, maria

.text

            la   a0, arrayNotSorted
            li   a1, 4
            jal  recCheck

            li   a7, 10
            ecall

str_ge:
#---------
# Write the subroutine code here
#  You may move jr ra   if you wish.
#---------
    lb t0, 0(a0)            # Φόρτωση του πρώτου χαρακτήρα του a0
    lb t1, 0(a1)            # Φόρτωση του πρώτου χαρακτήρα του a1

compare_chars:
    beq t0, t1, check_next  # Αν ίδιοι, πήγαινε στον επόμενο χαρακτήρα
    bge t0, t1, str_ge_true # Αν t0 >= t1, το a0 είναι μεγαλύτερο ή ίσο
    li a0, 0                # Διαφορετικά, επιστροφή 0
    jr ra

check_next:
    beqz t0, str_ge_true    # Αν τερματικός χαρακτήρας, τα strings είναι ίσα
    addi a0, a0, 1          # Επόμενος χαρακτήρας του a0
    addi a1, a1, 1          # Επόμενος χαρακτήρας του a1
    lb t0, 0(a0)
    lb t1, 0(a1)
    j compare_chars         # Επανέλαβε

str_ge_true:
    li a0, 1                # Επιστροφή 1, το a0 είναι μεγαλύτερο ή ίσο         
    jr   ra
 
# ----------------------------------------------------------------------------
# recCheck(array, size)
# if size == 0 or size == 1
#     return 1
# if str_ge(array[1], array[0])      # if first two items in ascending order,
#     return recCheck(&(array[1]), size-1)  # check from 2nd element onwards
# else
#     return 0

recCheck:
#---------
# Write the subroutine code here
#  You may move jr ra   if you wish.
#---------
	addi sp, sp, -8         # Αποθήκευση διεύθυνσης επιστροφής
    sw ra, 4(sp)
    sw a0, 0(sp)            # Αποθήκευση του a0 (διεύθυνση πίνακα)

    li t0, 1
    ble a1, t0, recCheck_true  # Αν μέγεθος <= 1, επιστροφή 1

    lw t1, 0(a0)            # Φόρτωση πρώτου δείκτη string
    lw t2, 4(a0)            # Φόρτωση δεύτερου δείκτη string

    mv a0, t1               # str_ge(a0 = t1, a1 = t2)
    mv a1, t2
    jal ra, str_ge          # Κλήση str_ge
    beqz a0, recCheck_false # Αν δεν είναι ταξινομημένο, επιστροφή 0

    lw a0, 0(sp)            # Επαναφορά διεύθυνσης πίνακα
    addi a0, a0, 4          # Προχώρησε στον επόμενο δείκτη
    addi a1, a1, -1         # Μείωση μεγέθους πίνακα κατά 1
    jal ra, recCheck        # Αναδρομική κλήση recCheck

    lw ra, 4(sp)            # Επαναφορά διεύθυνσης επιστροφής
    addi sp, sp, 8          # Αποκατάσταση στοίβας
    jr ra

recCheck_true:
    li a0, 1                # Επιστροφή 1
    lw ra, 4(sp)
    addi sp, sp, 8
    jr ra

recCheck_false:
    li a0, 0                # Επιστροφή 0
    lw ra, 4(sp)
    addi sp, sp, 8
    jr   ra
