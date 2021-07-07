	.text
	.file	"main.c"
	.globl	main                    # -- Begin function main
	.p2align	2
	.type	main,@function
main:                                   # @main
# %bb.0:                                # %entry
	addi	sp, sp, -32
	sw	ra, 28(sp)
	sw	s0, 24(sp)
	addi	s0, sp, 32
	sw	zero, -12(s0)
	sw	zero, -16(s0)
	sw	zero, -20(s0)
	j	.LBB0_1
.LBB0_1:                                # %for.cond
                                        # =>This Inner Loop Header: Depth=1
	lw	a0, -20(s0)
	addi	a1, zero, 99
	blt	a1, a0, .LBB0_5
	j	.LBB0_2
.LBB0_2:                                # %approx
                                        #   in Loop: Header=BB0_1 Depth=1
    .word 0b00000000000001110011000000001011
	j	.LBB0_3
.LBB0_3:                                # %for.body
                                        #   in Loop: Header=BB0_1 Depth=1
	lw	a0, -20(s0)
	lw	a1, -16(s0)
	add	a0, a1, a0
	sw	a0, -16(s0)
	j	.LBB0_4
.LBB0_4:                                # %for.inc
                                        #   in Loop: Header=BB0_1 Depth=1
	lw	a0, -20(s0)
	addi	a0, a0, 1
	sw	a0, -20(s0)
	j	.LBB0_1
.LBB0_5:                                # %for.end
	lw	a0, -12(s0)
	lw	s0, 24(sp)
	lw	ra, 28(sp)
	addi	sp, sp, 32
	ret
.Lfunc_end0:
	.size	main, .Lfunc_end0-main
                                        # -- End function

	.ident	"clang version 10.0.0 (http://localhost:8080/tomida/approximatellvm 53c6359ebe2eaa7bbdeca76ce01f373894d331a1)"
	.section	".note.GNU-stack","",@progbits

