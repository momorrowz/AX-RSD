	.text
	.file	"main.c"
	.globl	myitoa                  # -- Begin function myitoa
	.p2align	2
	.type	myitoa,@function
myitoa:                                 # @myitoa
# %bb.0:                                # %entry
	addi	sp, sp, -48
	sw	ra, 44(sp)
	sw	s0, 40(sp)
	addi	s0, sp, 48
	sw	a0, -12(s0)
	sw	a1, -16(s0)
	addi	a0, zero, 1
	sw	a0, -40(s0)
	sw	zero, -44(s0)
	lw	a0, -16(s0)
	addi	a1, zero, -1
	blt	a1, a0, .LBB0_2
	j	.LBB0_1
.LBB0_1:                                # %if.then
	lw	a0, -16(s0)
	neg	a0, a0
	sw	a0, -16(s0)
	sw	zero, -40(s0)
	j	.LBB0_2
.LBB0_2:                                # %if.end
	j	.LBB0_3
.LBB0_3:                                # %do.body
                                        # =>This Inner Loop Header: Depth=1
	lw	a0, -16(s0)
	lui	a1, 419430
	addi	a1, a1, 1639
	mulh	a2, a0, a1
	srli	a3, a2, 31
	srli	a2, a2, 2
	add	a2, a2, a3
	addi	a3, zero, 10
	mul	a2, a2, a3
	sub	a0, a0, a2
	addi	a0, a0, 48
	lw	a2, -44(s0)
	addi	a3, s0, -36
	add	a2, a3, a2
	sb	a0, 0(a2)
	lw	a0, -16(s0)
	mulh	a0, a0, a1
	srli	a1, a0, 31
	srai	a0, a0, 2
	add	a0, a0, a1
	sw	a0, -16(s0)
	lw	a0, -44(s0)
	addi	a0, a0, 1
	sw	a0, -44(s0)
	j	.LBB0_4
.LBB0_4:                                # %do.cond
                                        #   in Loop: Header=BB0_3 Depth=1
	lw	a0, -16(s0)
	bnez	a0, .LBB0_3
	j	.LBB0_5
.LBB0_5:                                # %do.end
	lw	a0, -40(s0)
	bnez	a0, .LBB0_11
	j	.LBB0_6
.LBB0_6:                                # %if.then3
	lw	a0, -12(s0)
	addi	a1, zero, 45
	sb	a1, 0(a0)
	addi	a0, zero, 1
	sw	a0, -48(s0)
	j	.LBB0_7
.LBB0_7:                                # %for.cond
                                        # =>This Inner Loop Header: Depth=1
	lw	a0, -48(s0)
	lw	a1, -44(s0)
	addi	a1, a1, 1
	bgeu	a0, a1, .LBB0_10
	j	.LBB0_8
.LBB0_8:                                # %for.body
                                        #   in Loop: Header=BB0_7 Depth=1
	lw	a0, -44(s0)
	lw	a1, -48(s0)
	sub	a0, a0, a1
	addi	a2, s0, -36
	add	a0, a2, a0
	lb	a0, 0(a0)
	lw	a2, -12(s0)
	add	a1, a2, a1
	sb	a0, 0(a1)
	j	.LBB0_9
.LBB0_9:                                # %for.inc
                                        #   in Loop: Header=BB0_7 Depth=1
	lw	a0, -48(s0)
	addi	a0, a0, 1
	sw	a0, -48(s0)
	j	.LBB0_7
.LBB0_10:                               # %for.end
	lw	a0, -12(s0)
	lw	a1, -44(s0)
	add	a0, a1, a0
	addi	a1, zero, 10
	sb	a1, 1(a0)
	lw	a0, -12(s0)
	lw	a1, -44(s0)
	add	a0, a1, a0
	sb	zero, 2(a0)
	j	.LBB0_16
.LBB0_11:                               # %if.else
	sw	zero, -48(s0)
	j	.LBB0_12
.LBB0_12:                               # %for.cond16
                                        # =>This Inner Loop Header: Depth=1
	lw	a0, -48(s0)
	lw	a1, -44(s0)
	bgeu	a0, a1, .LBB0_15
	j	.LBB0_13
.LBB0_13:                               # %for.body19
                                        #   in Loop: Header=BB0_12 Depth=1
	lw	a0, -44(s0)
	lw	a1, -48(s0)
	sub	a0, a0, a1
	addi	a2, s0, -36
	add	a0, a0, a2
	lb	a0, -1(a0)
	lw	a2, -12(s0)
	add	a1, a2, a1
	sb	a0, 0(a1)
	j	.LBB0_14
.LBB0_14:                               # %for.inc24
                                        #   in Loop: Header=BB0_12 Depth=1
	lw	a0, -48(s0)
	addi	a0, a0, 1
	sw	a0, -48(s0)
	j	.LBB0_12
.LBB0_15:                               # %for.end26
	lw	a0, -12(s0)
	lw	a1, -44(s0)
	add	a0, a0, a1
	addi	a1, zero, 10
	sb	a1, 0(a0)
	lw	a0, -12(s0)
	lw	a1, -44(s0)
	add	a0, a1, a0
	sb	zero, 1(a0)
	j	.LBB0_16
.LBB0_16:                               # %if.end30
	lw	s0, 40(sp)
	lw	ra, 44(sp)
	addi	sp, sp, 48
	ret
.Lfunc_end0:
	.size	myitoa, .Lfunc_end0-myitoa
                                        # -- End function
	.globl	main                    # -- Begin function main
	.p2align	2
	.type	main,@function
main:                                   # @main
# %bb.0:                                # %entry
	addi	sp, sp, -48
	sw	ra, 44(sp)
	sw	s0, 40(sp)
	addi	s0, sp, 48
	sw	zero, -12(s0)
	sw	zero, -16(s0)
	sw	zero, -20(s0)
	j	.LBB1_1
.LBB1_1:                                # %for.cond
                                        # =>This Inner Loop Header: Depth=1
	lw	a0, -20(s0)
	addi	a1, zero, 999
	blt	a1, a0, .LBB1_5
	j	.LBB1_2
.LBB1_2:                                # %approx
                                        #   in Loop: Header=BB1_1 Depth=1
	#approxbr	.LBB1_4
    .word 0b00000000000001100011000000001011
	j	.LBB1_3
.LBB1_3:                                # %for.body
                                        #   in Loop: Header=BB1_1 Depth=1
	lw	a0, -16(s0)
	addi	a0, a0, 1
	sw	a0, -16(s0)
	j	.LBB1_4
.LBB1_4:                                # %for.inc
                                        #   in Loop: Header=BB1_1 Depth=1
	lw	a0, -20(s0)
	addi	a0, a0, 1
	sw	a0, -20(s0)
	j	.LBB1_1
.LBB1_5:                                # %for.end
	lw	a1, -16(s0)
	addi	a0, s0, -40
	call	myitoa
	lui	a0, 262146
	sw	a0, -44(s0)
	sw	zero, -20(s0)
	j	.LBB1_6
.LBB1_6:                                # %for.cond1
                                        # =>This Inner Loop Header: Depth=1
	lw	a0, -20(s0)
	addi	a1, s0, -40
	add	a0, a1, a0
	lbu	a0, 0(a0)
	beqz	a0, .LBB1_9
	j	.LBB1_7
.LBB1_7:                                # %for.body4
                                        #   in Loop: Header=BB1_6 Depth=1
	lw	a0, -20(s0)
	addi	a1, s0, -40
	add	a0, a1, a0
	lb	a0, 0(a0)
	lw	a1, -44(s0)
	sb	a0, 0(a1)
	j	.LBB1_8
.LBB1_8:                                # %for.inc6
                                        #   in Loop: Header=BB1_6 Depth=1
	lw	a0, -20(s0)
	addi	a0, a0, 1
	sw	a0, -20(s0)
	j	.LBB1_6
.LBB1_9:                                # %for.end8
	lw	a0, -12(s0)
	lw	s0, 40(sp)
	lw	ra, 44(sp)
	addi	sp, sp, 48
	ret
.Lfunc_end1:
	.size	main, .Lfunc_end1-main
                                        # -- End function

	.ident	"clang version 10.0.0 (http://localhost:8080/tomida/approximatellvm 53c6359ebe2eaa7bbdeca76ce01f373894d331a1)"
	.section	".note.GNU-stack","",@progbits

