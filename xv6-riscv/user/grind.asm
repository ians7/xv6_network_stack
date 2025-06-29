
user/_grind:     file format elf64-littleriscv


Disassembly of section .text:

0000000000000000 <do_rand>:
#include "kernel/riscv.h"

// from FreeBSD.
int
do_rand(unsigned long *ctx)
{
       0:	1141                	addi	sp,sp,-16
       2:	e406                	sd	ra,8(sp)
       4:	e022                	sd	s0,0(sp)
       6:	0800                	addi	s0,sp,16
 * October 1988, p. 1195.
 */
    long hi, lo, x;

    /* Transform to [1, 0x7ffffffe] range. */
    x = (*ctx % 0x7ffffffe) + 1;
       8:	611c                	ld	a5,0(a0)
       a:	0017d693          	srli	a3,a5,0x1
       e:	c0000737          	lui	a4,0xc0000
      12:	0705                	addi	a4,a4,1 # ffffffffc0000001 <base+0xffffffffbfffd619>
      14:	1706                	slli	a4,a4,0x21
      16:	0725                	addi	a4,a4,9
      18:	02e6b733          	mulhu	a4,a3,a4
      1c:	8375                	srli	a4,a4,0x1d
      1e:	01e71693          	slli	a3,a4,0x1e
      22:	40e68733          	sub	a4,a3,a4
      26:	0706                	slli	a4,a4,0x1
      28:	8f99                	sub	a5,a5,a4
      2a:	0785                	addi	a5,a5,1
    hi = x / 127773;
    lo = x % 127773;
      2c:	1fe406b7          	lui	a3,0x1fe40
      30:	b7968693          	addi	a3,a3,-1159 # 1fe3fb79 <base+0x1fe3d191>
      34:	41a70737          	lui	a4,0x41a70
      38:	5af70713          	addi	a4,a4,1455 # 41a705af <base+0x41a6dbc7>
      3c:	1702                	slli	a4,a4,0x20
      3e:	9736                	add	a4,a4,a3
      40:	02e79733          	mulh	a4,a5,a4
      44:	873d                	srai	a4,a4,0xf
      46:	43f7d693          	srai	a3,a5,0x3f
      4a:	8f15                	sub	a4,a4,a3
      4c:	66fd                	lui	a3,0x1f
      4e:	31d68693          	addi	a3,a3,797 # 1f31d <base+0x1c935>
      52:	02d706b3          	mul	a3,a4,a3
      56:	8f95                	sub	a5,a5,a3
    x = 16807 * lo - 2836 * hi;
      58:	6691                	lui	a3,0x4
      5a:	1a768693          	addi	a3,a3,423 # 41a7 <base+0x17bf>
      5e:	02d787b3          	mul	a5,a5,a3
      62:	76fd                	lui	a3,0xfffff
      64:	4ec68693          	addi	a3,a3,1260 # fffffffffffff4ec <base+0xffffffffffffcb04>
      68:	02d70733          	mul	a4,a4,a3
      6c:	97ba                	add	a5,a5,a4
    if (x < 0)
      6e:	0007ca63          	bltz	a5,82 <do_rand+0x82>
        x += 0x7fffffff;
    /* Transform to [0, 0x7ffffffd] range. */
    x--;
      72:	17fd                	addi	a5,a5,-1
    *ctx = x;
      74:	e11c                	sd	a5,0(a0)
    return (x);
}
      76:	0007851b          	sext.w	a0,a5
      7a:	60a2                	ld	ra,8(sp)
      7c:	6402                	ld	s0,0(sp)
      7e:	0141                	addi	sp,sp,16
      80:	8082                	ret
        x += 0x7fffffff;
      82:	80000737          	lui	a4,0x80000
      86:	fff74713          	not	a4,a4
      8a:	97ba                	add	a5,a5,a4
      8c:	b7dd                	j	72 <do_rand+0x72>

000000000000008e <rand>:

unsigned long rand_next = 1;

int
rand(void)
{
      8e:	1141                	addi	sp,sp,-16
      90:	e406                	sd	ra,8(sp)
      92:	e022                	sd	s0,0(sp)
      94:	0800                	addi	s0,sp,16
    return (do_rand(&rand_next));
      96:	00002517          	auipc	a0,0x2
      9a:	53a50513          	addi	a0,a0,1338 # 25d0 <rand_next>
      9e:	00000097          	auipc	ra,0x0
      a2:	f62080e7          	jalr	-158(ra) # 0 <do_rand>
}
      a6:	60a2                	ld	ra,8(sp)
      a8:	6402                	ld	s0,0(sp)
      aa:	0141                	addi	sp,sp,16
      ac:	8082                	ret

00000000000000ae <go>:

void
go(int which_child)
{
      ae:	7171                	addi	sp,sp,-176
      b0:	f506                	sd	ra,168(sp)
      b2:	f122                	sd	s0,160(sp)
      b4:	ed26                	sd	s1,152(sp)
      b6:	1900                	addi	s0,sp,176
      b8:	84aa                	mv	s1,a0
  int fd = -1;
  static char buf[999];
  char *break0 = sbrk(0);
      ba:	4501                	li	a0,0
      bc:	00001097          	auipc	ra,0x1
      c0:	eda080e7          	jalr	-294(ra) # f96 <sbrk>
      c4:	f4a43c23          	sd	a0,-168(s0)
  uint64 iters = 0;

  mkdir("grindir");
      c8:	00001517          	auipc	a0,0x1
      cc:	5e850513          	addi	a0,a0,1512 # 16b0 <ithread_join+0x48>
      d0:	00001097          	auipc	ra,0x1
      d4:	ea6080e7          	jalr	-346(ra) # f76 <mkdir>
  if(chdir("grindir") != 0){
      d8:	00001517          	auipc	a0,0x1
      dc:	5d850513          	addi	a0,a0,1496 # 16b0 <ithread_join+0x48>
      e0:	00001097          	auipc	ra,0x1
      e4:	e9e080e7          	jalr	-354(ra) # f7e <chdir>
      e8:	c905                	beqz	a0,118 <go+0x6a>
      ea:	e94a                	sd	s2,144(sp)
      ec:	e54e                	sd	s3,136(sp)
      ee:	e152                	sd	s4,128(sp)
      f0:	fcd6                	sd	s5,120(sp)
      f2:	f8da                	sd	s6,112(sp)
      f4:	f4de                	sd	s7,104(sp)
      f6:	f0e2                	sd	s8,96(sp)
      f8:	ece6                	sd	s9,88(sp)
      fa:	e8ea                	sd	s10,80(sp)
      fc:	e4ee                	sd	s11,72(sp)
    printf("grind: chdir grindir failed\n");
      fe:	00001517          	auipc	a0,0x1
     102:	5ba50513          	addi	a0,a0,1466 # 16b8 <ithread_join+0x50>
     106:	00001097          	auipc	ra,0x1
     10a:	1a6080e7          	jalr	422(ra) # 12ac <printf>
    exit(1);
     10e:	4505                	li	a0,1
     110:	00001097          	auipc	ra,0x1
     114:	dfe080e7          	jalr	-514(ra) # f0e <exit>
     118:	e94a                	sd	s2,144(sp)
     11a:	e54e                	sd	s3,136(sp)
     11c:	e152                	sd	s4,128(sp)
     11e:	fcd6                	sd	s5,120(sp)
     120:	f8da                	sd	s6,112(sp)
     122:	f4de                	sd	s7,104(sp)
     124:	f0e2                	sd	s8,96(sp)
     126:	ece6                	sd	s9,88(sp)
     128:	e8ea                	sd	s10,80(sp)
     12a:	e4ee                	sd	s11,72(sp)
  }
  chdir("/");
     12c:	00001517          	auipc	a0,0x1
     130:	5b450513          	addi	a0,a0,1460 # 16e0 <ithread_join+0x78>
     134:	00001097          	auipc	ra,0x1
     138:	e4a080e7          	jalr	-438(ra) # f7e <chdir>
     13c:	00001c17          	auipc	s8,0x1
     140:	5b4c0c13          	addi	s8,s8,1460 # 16f0 <ithread_join+0x88>
     144:	c489                	beqz	s1,14e <go+0xa0>
     146:	00001c17          	auipc	s8,0x1
     14a:	5a2c0c13          	addi	s8,s8,1442 # 16e8 <ithread_join+0x80>
  uint64 iters = 0;
     14e:	4481                	li	s1,0
  int fd = -1;
     150:	5cfd                	li	s9,-1
  
  while(1){
    iters++;
    if((iters % 500) == 0)
     152:	e353f7b7          	lui	a5,0xe353f
     156:	7cf78793          	addi	a5,a5,1999 # ffffffffe353f7cf <base+0xffffffffe353cde7>
     15a:	20c4a9b7          	lui	s3,0x20c4a
     15e:	ba698993          	addi	s3,s3,-1114 # 20c49ba6 <base+0x20c471be>
     162:	1982                	slli	s3,s3,0x20
     164:	99be                	add	s3,s3,a5
     166:	1f400b13          	li	s6,500
      write(1, which_child?"B":"A", 1);
     16a:	4b85                	li	s7,1
    int what = rand() % 23;
     16c:	b2164a37          	lui	s4,0xb2164
     170:	2c9a0a13          	addi	s4,s4,713 # ffffffffb21642c9 <base+0xffffffffb21618e1>
     174:	4ad9                	li	s5,22
     176:	00002917          	auipc	s2,0x2
     17a:	87690913          	addi	s2,s2,-1930 # 19ec <ithread_join+0x384>
      close(fd1);
      unlink("c");
    } else if(what == 22){
      // echo hi | cat
      int aa[2], bb[2];
      if(pipe(aa) < 0){
     17e:	f6840d93          	addi	s11,s0,-152
     182:	a839                	j	1a0 <go+0xf2>
      close(open("grindir/../a", O_CREATE|O_RDWR));
     184:	20200593          	li	a1,514
     188:	00001517          	auipc	a0,0x1
     18c:	57050513          	addi	a0,a0,1392 # 16f8 <ithread_join+0x90>
     190:	00001097          	auipc	ra,0x1
     194:	dbe080e7          	jalr	-578(ra) # f4e <open>
     198:	00001097          	auipc	ra,0x1
     19c:	d9e080e7          	jalr	-610(ra) # f36 <close>
    iters++;
     1a0:	0485                	addi	s1,s1,1
    if((iters % 500) == 0)
     1a2:	0024d793          	srli	a5,s1,0x2
     1a6:	0337b7b3          	mulhu	a5,a5,s3
     1aa:	8391                	srli	a5,a5,0x4
     1ac:	036787b3          	mul	a5,a5,s6
     1b0:	00f49963          	bne	s1,a5,1c2 <go+0x114>
      write(1, which_child?"B":"A", 1);
     1b4:	865e                	mv	a2,s7
     1b6:	85e2                	mv	a1,s8
     1b8:	855e                	mv	a0,s7
     1ba:	00001097          	auipc	ra,0x1
     1be:	d74080e7          	jalr	-652(ra) # f2e <write>
    int what = rand() % 23;
     1c2:	00000097          	auipc	ra,0x0
     1c6:	ecc080e7          	jalr	-308(ra) # 8e <rand>
     1ca:	034507b3          	mul	a5,a0,s4
     1ce:	9381                	srli	a5,a5,0x20
     1d0:	9fa9                	addw	a5,a5,a0
     1d2:	4047d79b          	sraiw	a5,a5,0x4
     1d6:	41f5571b          	sraiw	a4,a0,0x1f
     1da:	9f99                	subw	a5,a5,a4
     1dc:	0017971b          	slliw	a4,a5,0x1
     1e0:	9f3d                	addw	a4,a4,a5
     1e2:	0037171b          	slliw	a4,a4,0x3
     1e6:	40f707bb          	subw	a5,a4,a5
     1ea:	9d1d                	subw	a0,a0,a5
     1ec:	faaaeae3          	bltu	s5,a0,1a0 <go+0xf2>
     1f0:	02051793          	slli	a5,a0,0x20
     1f4:	01e7d513          	srli	a0,a5,0x1e
     1f8:	954a                	add	a0,a0,s2
     1fa:	411c                	lw	a5,0(a0)
     1fc:	97ca                	add	a5,a5,s2
     1fe:	8782                	jr	a5
      close(open("grindir/../grindir/../b", O_CREATE|O_RDWR));
     200:	20200593          	li	a1,514
     204:	00001517          	auipc	a0,0x1
     208:	50450513          	addi	a0,a0,1284 # 1708 <ithread_join+0xa0>
     20c:	00001097          	auipc	ra,0x1
     210:	d42080e7          	jalr	-702(ra) # f4e <open>
     214:	00001097          	auipc	ra,0x1
     218:	d22080e7          	jalr	-734(ra) # f36 <close>
     21c:	b751                	j	1a0 <go+0xf2>
      unlink("grindir/../a");
     21e:	00001517          	auipc	a0,0x1
     222:	4da50513          	addi	a0,a0,1242 # 16f8 <ithread_join+0x90>
     226:	00001097          	auipc	ra,0x1
     22a:	d38080e7          	jalr	-712(ra) # f5e <unlink>
     22e:	bf8d                	j	1a0 <go+0xf2>
      if(chdir("grindir") != 0){
     230:	00001517          	auipc	a0,0x1
     234:	48050513          	addi	a0,a0,1152 # 16b0 <ithread_join+0x48>
     238:	00001097          	auipc	ra,0x1
     23c:	d46080e7          	jalr	-698(ra) # f7e <chdir>
     240:	e115                	bnez	a0,264 <go+0x1b6>
      unlink("../b");
     242:	00001517          	auipc	a0,0x1
     246:	4de50513          	addi	a0,a0,1246 # 1720 <ithread_join+0xb8>
     24a:	00001097          	auipc	ra,0x1
     24e:	d14080e7          	jalr	-748(ra) # f5e <unlink>
      chdir("/");
     252:	00001517          	auipc	a0,0x1
     256:	48e50513          	addi	a0,a0,1166 # 16e0 <ithread_join+0x78>
     25a:	00001097          	auipc	ra,0x1
     25e:	d24080e7          	jalr	-732(ra) # f7e <chdir>
     262:	bf3d                	j	1a0 <go+0xf2>
        printf("grind: chdir grindir failed\n");
     264:	00001517          	auipc	a0,0x1
     268:	45450513          	addi	a0,a0,1108 # 16b8 <ithread_join+0x50>
     26c:	00001097          	auipc	ra,0x1
     270:	040080e7          	jalr	64(ra) # 12ac <printf>
        exit(1);
     274:	4505                	li	a0,1
     276:	00001097          	auipc	ra,0x1
     27a:	c98080e7          	jalr	-872(ra) # f0e <exit>
      close(fd);
     27e:	8566                	mv	a0,s9
     280:	00001097          	auipc	ra,0x1
     284:	cb6080e7          	jalr	-842(ra) # f36 <close>
      fd = open("/grindir/../a", O_CREATE|O_RDWR);
     288:	20200593          	li	a1,514
     28c:	00001517          	auipc	a0,0x1
     290:	49c50513          	addi	a0,a0,1180 # 1728 <ithread_join+0xc0>
     294:	00001097          	auipc	ra,0x1
     298:	cba080e7          	jalr	-838(ra) # f4e <open>
     29c:	8caa                	mv	s9,a0
     29e:	b709                	j	1a0 <go+0xf2>
      close(fd);
     2a0:	8566                	mv	a0,s9
     2a2:	00001097          	auipc	ra,0x1
     2a6:	c94080e7          	jalr	-876(ra) # f36 <close>
      fd = open("/./grindir/./../b", O_CREATE|O_RDWR);
     2aa:	20200593          	li	a1,514
     2ae:	00001517          	auipc	a0,0x1
     2b2:	48a50513          	addi	a0,a0,1162 # 1738 <ithread_join+0xd0>
     2b6:	00001097          	auipc	ra,0x1
     2ba:	c98080e7          	jalr	-872(ra) # f4e <open>
     2be:	8caa                	mv	s9,a0
     2c0:	b5c5                	j	1a0 <go+0xf2>
      write(fd, buf, sizeof(buf));
     2c2:	3e700613          	li	a2,999
     2c6:	00002597          	auipc	a1,0x2
     2ca:	33a58593          	addi	a1,a1,826 # 2600 <buf.0>
     2ce:	8566                	mv	a0,s9
     2d0:	00001097          	auipc	ra,0x1
     2d4:	c5e080e7          	jalr	-930(ra) # f2e <write>
     2d8:	b5e1                	j	1a0 <go+0xf2>
      read(fd, buf, sizeof(buf));
     2da:	3e700613          	li	a2,999
     2de:	00002597          	auipc	a1,0x2
     2e2:	32258593          	addi	a1,a1,802 # 2600 <buf.0>
     2e6:	8566                	mv	a0,s9
     2e8:	00001097          	auipc	ra,0x1
     2ec:	c3e080e7          	jalr	-962(ra) # f26 <read>
     2f0:	bd45                	j	1a0 <go+0xf2>
      mkdir("grindir/../a");
     2f2:	00001517          	auipc	a0,0x1
     2f6:	40650513          	addi	a0,a0,1030 # 16f8 <ithread_join+0x90>
     2fa:	00001097          	auipc	ra,0x1
     2fe:	c7c080e7          	jalr	-900(ra) # f76 <mkdir>
      close(open("a/../a/./a", O_CREATE|O_RDWR));
     302:	20200593          	li	a1,514
     306:	00001517          	auipc	a0,0x1
     30a:	44a50513          	addi	a0,a0,1098 # 1750 <ithread_join+0xe8>
     30e:	00001097          	auipc	ra,0x1
     312:	c40080e7          	jalr	-960(ra) # f4e <open>
     316:	00001097          	auipc	ra,0x1
     31a:	c20080e7          	jalr	-992(ra) # f36 <close>
      unlink("a/a");
     31e:	00001517          	auipc	a0,0x1
     322:	44250513          	addi	a0,a0,1090 # 1760 <ithread_join+0xf8>
     326:	00001097          	auipc	ra,0x1
     32a:	c38080e7          	jalr	-968(ra) # f5e <unlink>
     32e:	bd8d                	j	1a0 <go+0xf2>
      mkdir("/../b");
     330:	00001517          	auipc	a0,0x1
     334:	43850513          	addi	a0,a0,1080 # 1768 <ithread_join+0x100>
     338:	00001097          	auipc	ra,0x1
     33c:	c3e080e7          	jalr	-962(ra) # f76 <mkdir>
      close(open("grindir/../b/b", O_CREATE|O_RDWR));
     340:	20200593          	li	a1,514
     344:	00001517          	auipc	a0,0x1
     348:	42c50513          	addi	a0,a0,1068 # 1770 <ithread_join+0x108>
     34c:	00001097          	auipc	ra,0x1
     350:	c02080e7          	jalr	-1022(ra) # f4e <open>
     354:	00001097          	auipc	ra,0x1
     358:	be2080e7          	jalr	-1054(ra) # f36 <close>
      unlink("b/b");
     35c:	00001517          	auipc	a0,0x1
     360:	42450513          	addi	a0,a0,1060 # 1780 <ithread_join+0x118>
     364:	00001097          	auipc	ra,0x1
     368:	bfa080e7          	jalr	-1030(ra) # f5e <unlink>
     36c:	bd15                	j	1a0 <go+0xf2>
      unlink("b");
     36e:	00001517          	auipc	a0,0x1
     372:	41a50513          	addi	a0,a0,1050 # 1788 <ithread_join+0x120>
     376:	00001097          	auipc	ra,0x1
     37a:	be8080e7          	jalr	-1048(ra) # f5e <unlink>
      link("../grindir/./../a", "../b");
     37e:	00001597          	auipc	a1,0x1
     382:	3a258593          	addi	a1,a1,930 # 1720 <ithread_join+0xb8>
     386:	00001517          	auipc	a0,0x1
     38a:	40a50513          	addi	a0,a0,1034 # 1790 <ithread_join+0x128>
     38e:	00001097          	auipc	ra,0x1
     392:	be0080e7          	jalr	-1056(ra) # f6e <link>
     396:	b529                	j	1a0 <go+0xf2>
      unlink("../grindir/../a");
     398:	00001517          	auipc	a0,0x1
     39c:	41050513          	addi	a0,a0,1040 # 17a8 <ithread_join+0x140>
     3a0:	00001097          	auipc	ra,0x1
     3a4:	bbe080e7          	jalr	-1090(ra) # f5e <unlink>
      link(".././b", "/grindir/../a");
     3a8:	00001597          	auipc	a1,0x1
     3ac:	38058593          	addi	a1,a1,896 # 1728 <ithread_join+0xc0>
     3b0:	00001517          	auipc	a0,0x1
     3b4:	40850513          	addi	a0,a0,1032 # 17b8 <ithread_join+0x150>
     3b8:	00001097          	auipc	ra,0x1
     3bc:	bb6080e7          	jalr	-1098(ra) # f6e <link>
     3c0:	b3c5                	j	1a0 <go+0xf2>
      int pid = fork();
     3c2:	00001097          	auipc	ra,0x1
     3c6:	b44080e7          	jalr	-1212(ra) # f06 <fork>
      if(pid == 0){
     3ca:	c909                	beqz	a0,3dc <go+0x32e>
      } else if(pid < 0){
     3cc:	00054c63          	bltz	a0,3e4 <go+0x336>
      wait(0);
     3d0:	4501                	li	a0,0
     3d2:	00001097          	auipc	ra,0x1
     3d6:	b44080e7          	jalr	-1212(ra) # f16 <wait>
     3da:	b3d9                	j	1a0 <go+0xf2>
        exit(0);
     3dc:	00001097          	auipc	ra,0x1
     3e0:	b32080e7          	jalr	-1230(ra) # f0e <exit>
        printf("grind: fork failed\n");
     3e4:	00001517          	auipc	a0,0x1
     3e8:	3dc50513          	addi	a0,a0,988 # 17c0 <ithread_join+0x158>
     3ec:	00001097          	auipc	ra,0x1
     3f0:	ec0080e7          	jalr	-320(ra) # 12ac <printf>
        exit(1);
     3f4:	4505                	li	a0,1
     3f6:	00001097          	auipc	ra,0x1
     3fa:	b18080e7          	jalr	-1256(ra) # f0e <exit>
      int pid = fork();
     3fe:	00001097          	auipc	ra,0x1
     402:	b08080e7          	jalr	-1272(ra) # f06 <fork>
      if(pid == 0){
     406:	c909                	beqz	a0,418 <go+0x36a>
      } else if(pid < 0){
     408:	02054563          	bltz	a0,432 <go+0x384>
      wait(0);
     40c:	4501                	li	a0,0
     40e:	00001097          	auipc	ra,0x1
     412:	b08080e7          	jalr	-1272(ra) # f16 <wait>
     416:	b369                	j	1a0 <go+0xf2>
        fork();
     418:	00001097          	auipc	ra,0x1
     41c:	aee080e7          	jalr	-1298(ra) # f06 <fork>
        fork();
     420:	00001097          	auipc	ra,0x1
     424:	ae6080e7          	jalr	-1306(ra) # f06 <fork>
        exit(0);
     428:	4501                	li	a0,0
     42a:	00001097          	auipc	ra,0x1
     42e:	ae4080e7          	jalr	-1308(ra) # f0e <exit>
        printf("grind: fork failed\n");
     432:	00001517          	auipc	a0,0x1
     436:	38e50513          	addi	a0,a0,910 # 17c0 <ithread_join+0x158>
     43a:	00001097          	auipc	ra,0x1
     43e:	e72080e7          	jalr	-398(ra) # 12ac <printf>
        exit(1);
     442:	4505                	li	a0,1
     444:	00001097          	auipc	ra,0x1
     448:	aca080e7          	jalr	-1334(ra) # f0e <exit>
      sbrk(6011);
     44c:	6505                	lui	a0,0x1
     44e:	77b50513          	addi	a0,a0,1915 # 177b <ithread_join+0x113>
     452:	00001097          	auipc	ra,0x1
     456:	b44080e7          	jalr	-1212(ra) # f96 <sbrk>
     45a:	b399                	j	1a0 <go+0xf2>
      if(sbrk(0) > break0)
     45c:	4501                	li	a0,0
     45e:	00001097          	auipc	ra,0x1
     462:	b38080e7          	jalr	-1224(ra) # f96 <sbrk>
     466:	f5843783          	ld	a5,-168(s0)
     46a:	d2a7fbe3          	bgeu	a5,a0,1a0 <go+0xf2>
        sbrk(-(sbrk(0) - break0));
     46e:	4501                	li	a0,0
     470:	00001097          	auipc	ra,0x1
     474:	b26080e7          	jalr	-1242(ra) # f96 <sbrk>
     478:	f5843783          	ld	a5,-168(s0)
     47c:	40a7853b          	subw	a0,a5,a0
     480:	00001097          	auipc	ra,0x1
     484:	b16080e7          	jalr	-1258(ra) # f96 <sbrk>
     488:	bb21                	j	1a0 <go+0xf2>
      int pid = fork();
     48a:	00001097          	auipc	ra,0x1
     48e:	a7c080e7          	jalr	-1412(ra) # f06 <fork>
     492:	8d2a                	mv	s10,a0
      if(pid == 0){
     494:	c51d                	beqz	a0,4c2 <go+0x414>
      } else if(pid < 0){
     496:	04054963          	bltz	a0,4e8 <go+0x43a>
      if(chdir("../grindir/..") != 0){
     49a:	00001517          	auipc	a0,0x1
     49e:	34650513          	addi	a0,a0,838 # 17e0 <ithread_join+0x178>
     4a2:	00001097          	auipc	ra,0x1
     4a6:	adc080e7          	jalr	-1316(ra) # f7e <chdir>
     4aa:	ed21                	bnez	a0,502 <go+0x454>
      kill(pid);
     4ac:	856a                	mv	a0,s10
     4ae:	00001097          	auipc	ra,0x1
     4b2:	a90080e7          	jalr	-1392(ra) # f3e <kill>
      wait(0);
     4b6:	4501                	li	a0,0
     4b8:	00001097          	auipc	ra,0x1
     4bc:	a5e080e7          	jalr	-1442(ra) # f16 <wait>
     4c0:	b1c5                	j	1a0 <go+0xf2>
        close(open("a", O_CREATE|O_RDWR));
     4c2:	20200593          	li	a1,514
     4c6:	00001517          	auipc	a0,0x1
     4ca:	31250513          	addi	a0,a0,786 # 17d8 <ithread_join+0x170>
     4ce:	00001097          	auipc	ra,0x1
     4d2:	a80080e7          	jalr	-1408(ra) # f4e <open>
     4d6:	00001097          	auipc	ra,0x1
     4da:	a60080e7          	jalr	-1440(ra) # f36 <close>
        exit(0);
     4de:	4501                	li	a0,0
     4e0:	00001097          	auipc	ra,0x1
     4e4:	a2e080e7          	jalr	-1490(ra) # f0e <exit>
        printf("grind: fork failed\n");
     4e8:	00001517          	auipc	a0,0x1
     4ec:	2d850513          	addi	a0,a0,728 # 17c0 <ithread_join+0x158>
     4f0:	00001097          	auipc	ra,0x1
     4f4:	dbc080e7          	jalr	-580(ra) # 12ac <printf>
        exit(1);
     4f8:	4505                	li	a0,1
     4fa:	00001097          	auipc	ra,0x1
     4fe:	a14080e7          	jalr	-1516(ra) # f0e <exit>
        printf("grind: chdir failed\n");
     502:	00001517          	auipc	a0,0x1
     506:	2ee50513          	addi	a0,a0,750 # 17f0 <ithread_join+0x188>
     50a:	00001097          	auipc	ra,0x1
     50e:	da2080e7          	jalr	-606(ra) # 12ac <printf>
        exit(1);
     512:	4505                	li	a0,1
     514:	00001097          	auipc	ra,0x1
     518:	9fa080e7          	jalr	-1542(ra) # f0e <exit>
      int pid = fork();
     51c:	00001097          	auipc	ra,0x1
     520:	9ea080e7          	jalr	-1558(ra) # f06 <fork>
      if(pid == 0){
     524:	c909                	beqz	a0,536 <go+0x488>
      } else if(pid < 0){
     526:	02054563          	bltz	a0,550 <go+0x4a2>
      wait(0);
     52a:	4501                	li	a0,0
     52c:	00001097          	auipc	ra,0x1
     530:	9ea080e7          	jalr	-1558(ra) # f16 <wait>
     534:	b1b5                	j	1a0 <go+0xf2>
        kill(getpid());
     536:	00001097          	auipc	ra,0x1
     53a:	a58080e7          	jalr	-1448(ra) # f8e <getpid>
     53e:	00001097          	auipc	ra,0x1
     542:	a00080e7          	jalr	-1536(ra) # f3e <kill>
        exit(0);
     546:	4501                	li	a0,0
     548:	00001097          	auipc	ra,0x1
     54c:	9c6080e7          	jalr	-1594(ra) # f0e <exit>
        printf("grind: fork failed\n");
     550:	00001517          	auipc	a0,0x1
     554:	27050513          	addi	a0,a0,624 # 17c0 <ithread_join+0x158>
     558:	00001097          	auipc	ra,0x1
     55c:	d54080e7          	jalr	-684(ra) # 12ac <printf>
        exit(1);
     560:	4505                	li	a0,1
     562:	00001097          	auipc	ra,0x1
     566:	9ac080e7          	jalr	-1620(ra) # f0e <exit>
      if(pipe(fds) < 0){
     56a:	f7840513          	addi	a0,s0,-136
     56e:	00001097          	auipc	ra,0x1
     572:	9b0080e7          	jalr	-1616(ra) # f1e <pipe>
     576:	02054b63          	bltz	a0,5ac <go+0x4fe>
      int pid = fork();
     57a:	00001097          	auipc	ra,0x1
     57e:	98c080e7          	jalr	-1652(ra) # f06 <fork>
      if(pid == 0){
     582:	c131                	beqz	a0,5c6 <go+0x518>
      } else if(pid < 0){
     584:	0a054a63          	bltz	a0,638 <go+0x58a>
      close(fds[0]);
     588:	f7842503          	lw	a0,-136(s0)
     58c:	00001097          	auipc	ra,0x1
     590:	9aa080e7          	jalr	-1622(ra) # f36 <close>
      close(fds[1]);
     594:	f7c42503          	lw	a0,-132(s0)
     598:	00001097          	auipc	ra,0x1
     59c:	99e080e7          	jalr	-1634(ra) # f36 <close>
      wait(0);
     5a0:	4501                	li	a0,0
     5a2:	00001097          	auipc	ra,0x1
     5a6:	974080e7          	jalr	-1676(ra) # f16 <wait>
     5aa:	bedd                	j	1a0 <go+0xf2>
        printf("grind: pipe failed\n");
     5ac:	00001517          	auipc	a0,0x1
     5b0:	25c50513          	addi	a0,a0,604 # 1808 <ithread_join+0x1a0>
     5b4:	00001097          	auipc	ra,0x1
     5b8:	cf8080e7          	jalr	-776(ra) # 12ac <printf>
        exit(1);
     5bc:	4505                	li	a0,1
     5be:	00001097          	auipc	ra,0x1
     5c2:	950080e7          	jalr	-1712(ra) # f0e <exit>
        fork();
     5c6:	00001097          	auipc	ra,0x1
     5ca:	940080e7          	jalr	-1728(ra) # f06 <fork>
        fork();
     5ce:	00001097          	auipc	ra,0x1
     5d2:	938080e7          	jalr	-1736(ra) # f06 <fork>
        if(write(fds[1], "x", 1) != 1)
     5d6:	4605                	li	a2,1
     5d8:	00001597          	auipc	a1,0x1
     5dc:	24858593          	addi	a1,a1,584 # 1820 <ithread_join+0x1b8>
     5e0:	f7c42503          	lw	a0,-132(s0)
     5e4:	00001097          	auipc	ra,0x1
     5e8:	94a080e7          	jalr	-1718(ra) # f2e <write>
     5ec:	4785                	li	a5,1
     5ee:	02f51363          	bne	a0,a5,614 <go+0x566>
        if(read(fds[0], &c, 1) != 1)
     5f2:	4605                	li	a2,1
     5f4:	f7040593          	addi	a1,s0,-144
     5f8:	f7842503          	lw	a0,-136(s0)
     5fc:	00001097          	auipc	ra,0x1
     600:	92a080e7          	jalr	-1750(ra) # f26 <read>
     604:	4785                	li	a5,1
     606:	02f51063          	bne	a0,a5,626 <go+0x578>
        exit(0);
     60a:	4501                	li	a0,0
     60c:	00001097          	auipc	ra,0x1
     610:	902080e7          	jalr	-1790(ra) # f0e <exit>
          printf("grind: pipe write failed\n");
     614:	00001517          	auipc	a0,0x1
     618:	21450513          	addi	a0,a0,532 # 1828 <ithread_join+0x1c0>
     61c:	00001097          	auipc	ra,0x1
     620:	c90080e7          	jalr	-880(ra) # 12ac <printf>
     624:	b7f9                	j	5f2 <go+0x544>
          printf("grind: pipe read failed\n");
     626:	00001517          	auipc	a0,0x1
     62a:	22250513          	addi	a0,a0,546 # 1848 <ithread_join+0x1e0>
     62e:	00001097          	auipc	ra,0x1
     632:	c7e080e7          	jalr	-898(ra) # 12ac <printf>
     636:	bfd1                	j	60a <go+0x55c>
        printf("grind: fork failed\n");
     638:	00001517          	auipc	a0,0x1
     63c:	18850513          	addi	a0,a0,392 # 17c0 <ithread_join+0x158>
     640:	00001097          	auipc	ra,0x1
     644:	c6c080e7          	jalr	-916(ra) # 12ac <printf>
        exit(1);
     648:	4505                	li	a0,1
     64a:	00001097          	auipc	ra,0x1
     64e:	8c4080e7          	jalr	-1852(ra) # f0e <exit>
      int pid = fork();
     652:	00001097          	auipc	ra,0x1
     656:	8b4080e7          	jalr	-1868(ra) # f06 <fork>
      if(pid == 0){
     65a:	c909                	beqz	a0,66c <go+0x5be>
      } else if(pid < 0){
     65c:	06054f63          	bltz	a0,6da <go+0x62c>
      wait(0);
     660:	4501                	li	a0,0
     662:	00001097          	auipc	ra,0x1
     666:	8b4080e7          	jalr	-1868(ra) # f16 <wait>
     66a:	be1d                	j	1a0 <go+0xf2>
        unlink("a");
     66c:	00001517          	auipc	a0,0x1
     670:	16c50513          	addi	a0,a0,364 # 17d8 <ithread_join+0x170>
     674:	00001097          	auipc	ra,0x1
     678:	8ea080e7          	jalr	-1814(ra) # f5e <unlink>
        mkdir("a");
     67c:	00001517          	auipc	a0,0x1
     680:	15c50513          	addi	a0,a0,348 # 17d8 <ithread_join+0x170>
     684:	00001097          	auipc	ra,0x1
     688:	8f2080e7          	jalr	-1806(ra) # f76 <mkdir>
        chdir("a");
     68c:	00001517          	auipc	a0,0x1
     690:	14c50513          	addi	a0,a0,332 # 17d8 <ithread_join+0x170>
     694:	00001097          	auipc	ra,0x1
     698:	8ea080e7          	jalr	-1814(ra) # f7e <chdir>
        unlink("../a");
     69c:	00001517          	auipc	a0,0x1
     6a0:	1cc50513          	addi	a0,a0,460 # 1868 <ithread_join+0x200>
     6a4:	00001097          	auipc	ra,0x1
     6a8:	8ba080e7          	jalr	-1862(ra) # f5e <unlink>
        fd = open("x", O_CREATE|O_RDWR);
     6ac:	20200593          	li	a1,514
     6b0:	00001517          	auipc	a0,0x1
     6b4:	17050513          	addi	a0,a0,368 # 1820 <ithread_join+0x1b8>
     6b8:	00001097          	auipc	ra,0x1
     6bc:	896080e7          	jalr	-1898(ra) # f4e <open>
        unlink("x");
     6c0:	00001517          	auipc	a0,0x1
     6c4:	16050513          	addi	a0,a0,352 # 1820 <ithread_join+0x1b8>
     6c8:	00001097          	auipc	ra,0x1
     6cc:	896080e7          	jalr	-1898(ra) # f5e <unlink>
        exit(0);
     6d0:	4501                	li	a0,0
     6d2:	00001097          	auipc	ra,0x1
     6d6:	83c080e7          	jalr	-1988(ra) # f0e <exit>
        printf("grind: fork failed\n");
     6da:	00001517          	auipc	a0,0x1
     6de:	0e650513          	addi	a0,a0,230 # 17c0 <ithread_join+0x158>
     6e2:	00001097          	auipc	ra,0x1
     6e6:	bca080e7          	jalr	-1078(ra) # 12ac <printf>
        exit(1);
     6ea:	4505                	li	a0,1
     6ec:	00001097          	auipc	ra,0x1
     6f0:	822080e7          	jalr	-2014(ra) # f0e <exit>
      unlink("c");
     6f4:	00001517          	auipc	a0,0x1
     6f8:	17c50513          	addi	a0,a0,380 # 1870 <ithread_join+0x208>
     6fc:	00001097          	auipc	ra,0x1
     700:	862080e7          	jalr	-1950(ra) # f5e <unlink>
      int fd1 = open("c", O_CREATE|O_RDWR);
     704:	20200593          	li	a1,514
     708:	00001517          	auipc	a0,0x1
     70c:	16850513          	addi	a0,a0,360 # 1870 <ithread_join+0x208>
     710:	00001097          	auipc	ra,0x1
     714:	83e080e7          	jalr	-1986(ra) # f4e <open>
     718:	8d2a                	mv	s10,a0
      if(fd1 < 0){
     71a:	04054d63          	bltz	a0,774 <go+0x6c6>
      if(write(fd1, "x", 1) != 1){
     71e:	865e                	mv	a2,s7
     720:	00001597          	auipc	a1,0x1
     724:	10058593          	addi	a1,a1,256 # 1820 <ithread_join+0x1b8>
     728:	00001097          	auipc	ra,0x1
     72c:	806080e7          	jalr	-2042(ra) # f2e <write>
     730:	05751f63          	bne	a0,s7,78e <go+0x6e0>
      if(fstat(fd1, &st) != 0){
     734:	f7840593          	addi	a1,s0,-136
     738:	856a                	mv	a0,s10
     73a:	00001097          	auipc	ra,0x1
     73e:	82c080e7          	jalr	-2004(ra) # f66 <fstat>
     742:	e13d                	bnez	a0,7a8 <go+0x6fa>
      if(st.size != 1){
     744:	f8843583          	ld	a1,-120(s0)
     748:	07759d63          	bne	a1,s7,7c2 <go+0x714>
      if(st.ino > 200){
     74c:	f7c42583          	lw	a1,-132(s0)
     750:	0c800793          	li	a5,200
     754:	08b7e563          	bltu	a5,a1,7de <go+0x730>
      close(fd1);
     758:	856a                	mv	a0,s10
     75a:	00000097          	auipc	ra,0x0
     75e:	7dc080e7          	jalr	2012(ra) # f36 <close>
      unlink("c");
     762:	00001517          	auipc	a0,0x1
     766:	10e50513          	addi	a0,a0,270 # 1870 <ithread_join+0x208>
     76a:	00000097          	auipc	ra,0x0
     76e:	7f4080e7          	jalr	2036(ra) # f5e <unlink>
     772:	b43d                	j	1a0 <go+0xf2>
        printf("grind: create c failed\n");
     774:	00001517          	auipc	a0,0x1
     778:	10450513          	addi	a0,a0,260 # 1878 <ithread_join+0x210>
     77c:	00001097          	auipc	ra,0x1
     780:	b30080e7          	jalr	-1232(ra) # 12ac <printf>
        exit(1);
     784:	4505                	li	a0,1
     786:	00000097          	auipc	ra,0x0
     78a:	788080e7          	jalr	1928(ra) # f0e <exit>
        printf("grind: write c failed\n");
     78e:	00001517          	auipc	a0,0x1
     792:	10250513          	addi	a0,a0,258 # 1890 <ithread_join+0x228>
     796:	00001097          	auipc	ra,0x1
     79a:	b16080e7          	jalr	-1258(ra) # 12ac <printf>
        exit(1);
     79e:	4505                	li	a0,1
     7a0:	00000097          	auipc	ra,0x0
     7a4:	76e080e7          	jalr	1902(ra) # f0e <exit>
        printf("grind: fstat failed\n");
     7a8:	00001517          	auipc	a0,0x1
     7ac:	10050513          	addi	a0,a0,256 # 18a8 <ithread_join+0x240>
     7b0:	00001097          	auipc	ra,0x1
     7b4:	afc080e7          	jalr	-1284(ra) # 12ac <printf>
        exit(1);
     7b8:	4505                	li	a0,1
     7ba:	00000097          	auipc	ra,0x0
     7be:	754080e7          	jalr	1876(ra) # f0e <exit>
        printf("grind: fstat reports wrong size %d\n", (int)st.size);
     7c2:	2581                	sext.w	a1,a1
     7c4:	00001517          	auipc	a0,0x1
     7c8:	0fc50513          	addi	a0,a0,252 # 18c0 <ithread_join+0x258>
     7cc:	00001097          	auipc	ra,0x1
     7d0:	ae0080e7          	jalr	-1312(ra) # 12ac <printf>
        exit(1);
     7d4:	4505                	li	a0,1
     7d6:	00000097          	auipc	ra,0x0
     7da:	738080e7          	jalr	1848(ra) # f0e <exit>
        printf("grind: fstat reports crazy i-number %d\n", st.ino);
     7de:	00001517          	auipc	a0,0x1
     7e2:	10a50513          	addi	a0,a0,266 # 18e8 <ithread_join+0x280>
     7e6:	00001097          	auipc	ra,0x1
     7ea:	ac6080e7          	jalr	-1338(ra) # 12ac <printf>
        exit(1);
     7ee:	4505                	li	a0,1
     7f0:	00000097          	auipc	ra,0x0
     7f4:	71e080e7          	jalr	1822(ra) # f0e <exit>
      if(pipe(aa) < 0){
     7f8:	856e                	mv	a0,s11
     7fa:	00000097          	auipc	ra,0x0
     7fe:	724080e7          	jalr	1828(ra) # f1e <pipe>
     802:	10054063          	bltz	a0,902 <go+0x854>
        fprintf(2, "grind: pipe failed\n");
        exit(1);
      }
      if(pipe(bb) < 0){
     806:	f7040513          	addi	a0,s0,-144
     80a:	00000097          	auipc	ra,0x0
     80e:	714080e7          	jalr	1812(ra) # f1e <pipe>
     812:	10054663          	bltz	a0,91e <go+0x870>
        fprintf(2, "grind: pipe failed\n");
        exit(1);
      }
      int pid1 = fork();
     816:	00000097          	auipc	ra,0x0
     81a:	6f0080e7          	jalr	1776(ra) # f06 <fork>
      if(pid1 == 0){
     81e:	10050e63          	beqz	a0,93a <go+0x88c>
        close(aa[1]);
        char *args[3] = { "echo", "hi", 0 };
        exec("grindir/../echo", args);
        fprintf(2, "grind: echo: not found\n");
        exit(2);
      } else if(pid1 < 0){
     822:	1c054663          	bltz	a0,9ee <go+0x940>
        fprintf(2, "grind: fork failed\n");
        exit(3);
      }
      int pid2 = fork();
     826:	00000097          	auipc	ra,0x0
     82a:	6e0080e7          	jalr	1760(ra) # f06 <fork>
      if(pid2 == 0){
     82e:	1c050e63          	beqz	a0,a0a <go+0x95c>
        close(bb[1]);
        char *args[2] = { "cat", 0 };
        exec("/cat", args);
        fprintf(2, "grind: cat: not found\n");
        exit(6);
      } else if(pid2 < 0){
     832:	2a054a63          	bltz	a0,ae6 <go+0xa38>
        fprintf(2, "grind: fork failed\n");
        exit(7);
      }
      close(aa[0]);
     836:	f6842503          	lw	a0,-152(s0)
     83a:	00000097          	auipc	ra,0x0
     83e:	6fc080e7          	jalr	1788(ra) # f36 <close>
      close(aa[1]);
     842:	f6c42503          	lw	a0,-148(s0)
     846:	00000097          	auipc	ra,0x0
     84a:	6f0080e7          	jalr	1776(ra) # f36 <close>
      close(bb[1]);
     84e:	f7442503          	lw	a0,-140(s0)
     852:	00000097          	auipc	ra,0x0
     856:	6e4080e7          	jalr	1764(ra) # f36 <close>
      char buf[4] = { 0, 0, 0, 0 };
     85a:	f6042023          	sw	zero,-160(s0)
      read(bb[0], buf+0, 1);
     85e:	865e                	mv	a2,s7
     860:	f6040593          	addi	a1,s0,-160
     864:	f7042503          	lw	a0,-144(s0)
     868:	00000097          	auipc	ra,0x0
     86c:	6be080e7          	jalr	1726(ra) # f26 <read>
      read(bb[0], buf+1, 1);
     870:	865e                	mv	a2,s7
     872:	f6140593          	addi	a1,s0,-159
     876:	f7042503          	lw	a0,-144(s0)
     87a:	00000097          	auipc	ra,0x0
     87e:	6ac080e7          	jalr	1708(ra) # f26 <read>
      read(bb[0], buf+2, 1);
     882:	865e                	mv	a2,s7
     884:	f6240593          	addi	a1,s0,-158
     888:	f7042503          	lw	a0,-144(s0)
     88c:	00000097          	auipc	ra,0x0
     890:	69a080e7          	jalr	1690(ra) # f26 <read>
      close(bb[0]);
     894:	f7042503          	lw	a0,-144(s0)
     898:	00000097          	auipc	ra,0x0
     89c:	69e080e7          	jalr	1694(ra) # f36 <close>
      int st1, st2;
      wait(&st1);
     8a0:	f6440513          	addi	a0,s0,-156
     8a4:	00000097          	auipc	ra,0x0
     8a8:	672080e7          	jalr	1650(ra) # f16 <wait>
      wait(&st2);
     8ac:	f7840513          	addi	a0,s0,-136
     8b0:	00000097          	auipc	ra,0x0
     8b4:	666080e7          	jalr	1638(ra) # f16 <wait>
      if(st1 != 0 || st2 != 0 || strcmp(buf, "hi\n") != 0){
     8b8:	f6442783          	lw	a5,-156(s0)
     8bc:	f7842703          	lw	a4,-136(s0)
     8c0:	8fd9                	or	a5,a5,a4
     8c2:	ef89                	bnez	a5,8dc <go+0x82e>
     8c4:	00001597          	auipc	a1,0x1
     8c8:	0c458593          	addi	a1,a1,196 # 1988 <ithread_join+0x320>
     8cc:	f6040513          	addi	a0,s0,-160
     8d0:	00000097          	auipc	ra,0x0
     8d4:	3be080e7          	jalr	958(ra) # c8e <strcmp>
     8d8:	8c0504e3          	beqz	a0,1a0 <go+0xf2>
        printf("grind: exec pipeline failed %d %d \"%s\"\n", st1, st2, buf);
     8dc:	f6040693          	addi	a3,s0,-160
     8e0:	f7842603          	lw	a2,-136(s0)
     8e4:	f6442583          	lw	a1,-156(s0)
     8e8:	00001517          	auipc	a0,0x1
     8ec:	0a850513          	addi	a0,a0,168 # 1990 <ithread_join+0x328>
     8f0:	00001097          	auipc	ra,0x1
     8f4:	9bc080e7          	jalr	-1604(ra) # 12ac <printf>
        exit(1);
     8f8:	4505                	li	a0,1
     8fa:	00000097          	auipc	ra,0x0
     8fe:	614080e7          	jalr	1556(ra) # f0e <exit>
        fprintf(2, "grind: pipe failed\n");
     902:	00001597          	auipc	a1,0x1
     906:	f0658593          	addi	a1,a1,-250 # 1808 <ithread_join+0x1a0>
     90a:	4509                	li	a0,2
     90c:	00001097          	auipc	ra,0x1
     910:	972080e7          	jalr	-1678(ra) # 127e <fprintf>
        exit(1);
     914:	4505                	li	a0,1
     916:	00000097          	auipc	ra,0x0
     91a:	5f8080e7          	jalr	1528(ra) # f0e <exit>
        fprintf(2, "grind: pipe failed\n");
     91e:	00001597          	auipc	a1,0x1
     922:	eea58593          	addi	a1,a1,-278 # 1808 <ithread_join+0x1a0>
     926:	4509                	li	a0,2
     928:	00001097          	auipc	ra,0x1
     92c:	956080e7          	jalr	-1706(ra) # 127e <fprintf>
        exit(1);
     930:	4505                	li	a0,1
     932:	00000097          	auipc	ra,0x0
     936:	5dc080e7          	jalr	1500(ra) # f0e <exit>
        close(bb[0]);
     93a:	f7042503          	lw	a0,-144(s0)
     93e:	00000097          	auipc	ra,0x0
     942:	5f8080e7          	jalr	1528(ra) # f36 <close>
        close(bb[1]);
     946:	f7442503          	lw	a0,-140(s0)
     94a:	00000097          	auipc	ra,0x0
     94e:	5ec080e7          	jalr	1516(ra) # f36 <close>
        close(aa[0]);
     952:	f6842503          	lw	a0,-152(s0)
     956:	00000097          	auipc	ra,0x0
     95a:	5e0080e7          	jalr	1504(ra) # f36 <close>
        close(1);
     95e:	4505                	li	a0,1
     960:	00000097          	auipc	ra,0x0
     964:	5d6080e7          	jalr	1494(ra) # f36 <close>
        if(dup(aa[1]) != 1){
     968:	f6c42503          	lw	a0,-148(s0)
     96c:	00000097          	auipc	ra,0x0
     970:	61a080e7          	jalr	1562(ra) # f86 <dup>
     974:	4785                	li	a5,1
     976:	02f50063          	beq	a0,a5,996 <go+0x8e8>
          fprintf(2, "grind: dup failed\n");
     97a:	00001597          	auipc	a1,0x1
     97e:	f9658593          	addi	a1,a1,-106 # 1910 <ithread_join+0x2a8>
     982:	4509                	li	a0,2
     984:	00001097          	auipc	ra,0x1
     988:	8fa080e7          	jalr	-1798(ra) # 127e <fprintf>
          exit(1);
     98c:	4505                	li	a0,1
     98e:	00000097          	auipc	ra,0x0
     992:	580080e7          	jalr	1408(ra) # f0e <exit>
        close(aa[1]);
     996:	f6c42503          	lw	a0,-148(s0)
     99a:	00000097          	auipc	ra,0x0
     99e:	59c080e7          	jalr	1436(ra) # f36 <close>
        char *args[3] = { "echo", "hi", 0 };
     9a2:	00001797          	auipc	a5,0x1
     9a6:	f8678793          	addi	a5,a5,-122 # 1928 <ithread_join+0x2c0>
     9aa:	f6f43c23          	sd	a5,-136(s0)
     9ae:	00001797          	auipc	a5,0x1
     9b2:	f8278793          	addi	a5,a5,-126 # 1930 <ithread_join+0x2c8>
     9b6:	f8f43023          	sd	a5,-128(s0)
     9ba:	f8043423          	sd	zero,-120(s0)
        exec("grindir/../echo", args);
     9be:	f7840593          	addi	a1,s0,-136
     9c2:	00001517          	auipc	a0,0x1
     9c6:	f7650513          	addi	a0,a0,-138 # 1938 <ithread_join+0x2d0>
     9ca:	00000097          	auipc	ra,0x0
     9ce:	57c080e7          	jalr	1404(ra) # f46 <exec>
        fprintf(2, "grind: echo: not found\n");
     9d2:	00001597          	auipc	a1,0x1
     9d6:	f7658593          	addi	a1,a1,-138 # 1948 <ithread_join+0x2e0>
     9da:	4509                	li	a0,2
     9dc:	00001097          	auipc	ra,0x1
     9e0:	8a2080e7          	jalr	-1886(ra) # 127e <fprintf>
        exit(2);
     9e4:	4509                	li	a0,2
     9e6:	00000097          	auipc	ra,0x0
     9ea:	528080e7          	jalr	1320(ra) # f0e <exit>
        fprintf(2, "grind: fork failed\n");
     9ee:	00001597          	auipc	a1,0x1
     9f2:	dd258593          	addi	a1,a1,-558 # 17c0 <ithread_join+0x158>
     9f6:	4509                	li	a0,2
     9f8:	00001097          	auipc	ra,0x1
     9fc:	886080e7          	jalr	-1914(ra) # 127e <fprintf>
        exit(3);
     a00:	450d                	li	a0,3
     a02:	00000097          	auipc	ra,0x0
     a06:	50c080e7          	jalr	1292(ra) # f0e <exit>
        close(aa[1]);
     a0a:	f6c42503          	lw	a0,-148(s0)
     a0e:	00000097          	auipc	ra,0x0
     a12:	528080e7          	jalr	1320(ra) # f36 <close>
        close(bb[0]);
     a16:	f7042503          	lw	a0,-144(s0)
     a1a:	00000097          	auipc	ra,0x0
     a1e:	51c080e7          	jalr	1308(ra) # f36 <close>
        close(0);
     a22:	4501                	li	a0,0
     a24:	00000097          	auipc	ra,0x0
     a28:	512080e7          	jalr	1298(ra) # f36 <close>
        if(dup(aa[0]) != 0){
     a2c:	f6842503          	lw	a0,-152(s0)
     a30:	00000097          	auipc	ra,0x0
     a34:	556080e7          	jalr	1366(ra) # f86 <dup>
     a38:	cd19                	beqz	a0,a56 <go+0x9a8>
          fprintf(2, "grind: dup failed\n");
     a3a:	00001597          	auipc	a1,0x1
     a3e:	ed658593          	addi	a1,a1,-298 # 1910 <ithread_join+0x2a8>
     a42:	4509                	li	a0,2
     a44:	00001097          	auipc	ra,0x1
     a48:	83a080e7          	jalr	-1990(ra) # 127e <fprintf>
          exit(4);
     a4c:	4511                	li	a0,4
     a4e:	00000097          	auipc	ra,0x0
     a52:	4c0080e7          	jalr	1216(ra) # f0e <exit>
        close(aa[0]);
     a56:	f6842503          	lw	a0,-152(s0)
     a5a:	00000097          	auipc	ra,0x0
     a5e:	4dc080e7          	jalr	1244(ra) # f36 <close>
        close(1);
     a62:	4505                	li	a0,1
     a64:	00000097          	auipc	ra,0x0
     a68:	4d2080e7          	jalr	1234(ra) # f36 <close>
        if(dup(bb[1]) != 1){
     a6c:	f7442503          	lw	a0,-140(s0)
     a70:	00000097          	auipc	ra,0x0
     a74:	516080e7          	jalr	1302(ra) # f86 <dup>
     a78:	4785                	li	a5,1
     a7a:	02f50063          	beq	a0,a5,a9a <go+0x9ec>
          fprintf(2, "grind: dup failed\n");
     a7e:	00001597          	auipc	a1,0x1
     a82:	e9258593          	addi	a1,a1,-366 # 1910 <ithread_join+0x2a8>
     a86:	4509                	li	a0,2
     a88:	00000097          	auipc	ra,0x0
     a8c:	7f6080e7          	jalr	2038(ra) # 127e <fprintf>
          exit(5);
     a90:	4515                	li	a0,5
     a92:	00000097          	auipc	ra,0x0
     a96:	47c080e7          	jalr	1148(ra) # f0e <exit>
        close(bb[1]);
     a9a:	f7442503          	lw	a0,-140(s0)
     a9e:	00000097          	auipc	ra,0x0
     aa2:	498080e7          	jalr	1176(ra) # f36 <close>
        char *args[2] = { "cat", 0 };
     aa6:	00001797          	auipc	a5,0x1
     aaa:	eba78793          	addi	a5,a5,-326 # 1960 <ithread_join+0x2f8>
     aae:	f6f43c23          	sd	a5,-136(s0)
     ab2:	f8043023          	sd	zero,-128(s0)
        exec("/cat", args);
     ab6:	f7840593          	addi	a1,s0,-136
     aba:	00001517          	auipc	a0,0x1
     abe:	eae50513          	addi	a0,a0,-338 # 1968 <ithread_join+0x300>
     ac2:	00000097          	auipc	ra,0x0
     ac6:	484080e7          	jalr	1156(ra) # f46 <exec>
        fprintf(2, "grind: cat: not found\n");
     aca:	00001597          	auipc	a1,0x1
     ace:	ea658593          	addi	a1,a1,-346 # 1970 <ithread_join+0x308>
     ad2:	4509                	li	a0,2
     ad4:	00000097          	auipc	ra,0x0
     ad8:	7aa080e7          	jalr	1962(ra) # 127e <fprintf>
        exit(6);
     adc:	4519                	li	a0,6
     ade:	00000097          	auipc	ra,0x0
     ae2:	430080e7          	jalr	1072(ra) # f0e <exit>
        fprintf(2, "grind: fork failed\n");
     ae6:	00001597          	auipc	a1,0x1
     aea:	cda58593          	addi	a1,a1,-806 # 17c0 <ithread_join+0x158>
     aee:	4509                	li	a0,2
     af0:	00000097          	auipc	ra,0x0
     af4:	78e080e7          	jalr	1934(ra) # 127e <fprintf>
        exit(7);
     af8:	451d                	li	a0,7
     afa:	00000097          	auipc	ra,0x0
     afe:	414080e7          	jalr	1044(ra) # f0e <exit>

0000000000000b02 <iter>:
  }
}

void
iter()
{
     b02:	7179                	addi	sp,sp,-48
     b04:	f406                	sd	ra,40(sp)
     b06:	f022                	sd	s0,32(sp)
     b08:	1800                	addi	s0,sp,48
  unlink("a");
     b0a:	00001517          	auipc	a0,0x1
     b0e:	cce50513          	addi	a0,a0,-818 # 17d8 <ithread_join+0x170>
     b12:	00000097          	auipc	ra,0x0
     b16:	44c080e7          	jalr	1100(ra) # f5e <unlink>
  unlink("b");
     b1a:	00001517          	auipc	a0,0x1
     b1e:	c6e50513          	addi	a0,a0,-914 # 1788 <ithread_join+0x120>
     b22:	00000097          	auipc	ra,0x0
     b26:	43c080e7          	jalr	1084(ra) # f5e <unlink>
  
  int pid1 = fork();
     b2a:	00000097          	auipc	ra,0x0
     b2e:	3dc080e7          	jalr	988(ra) # f06 <fork>
  if(pid1 < 0){
     b32:	02054363          	bltz	a0,b58 <iter+0x56>
     b36:	ec26                	sd	s1,24(sp)
     b38:	84aa                	mv	s1,a0
    printf("grind: fork failed\n");
    exit(1);
  }
  if(pid1 == 0){
     b3a:	ed15                	bnez	a0,b76 <iter+0x74>
     b3c:	e84a                	sd	s2,16(sp)
    rand_next ^= 31;
     b3e:	00002717          	auipc	a4,0x2
     b42:	a9270713          	addi	a4,a4,-1390 # 25d0 <rand_next>
     b46:	631c                	ld	a5,0(a4)
     b48:	01f7c793          	xori	a5,a5,31
     b4c:	e31c                	sd	a5,0(a4)
    go(0);
     b4e:	4501                	li	a0,0
     b50:	fffff097          	auipc	ra,0xfffff
     b54:	55e080e7          	jalr	1374(ra) # ae <go>
     b58:	ec26                	sd	s1,24(sp)
     b5a:	e84a                	sd	s2,16(sp)
    printf("grind: fork failed\n");
     b5c:	00001517          	auipc	a0,0x1
     b60:	c6450513          	addi	a0,a0,-924 # 17c0 <ithread_join+0x158>
     b64:	00000097          	auipc	ra,0x0
     b68:	748080e7          	jalr	1864(ra) # 12ac <printf>
    exit(1);
     b6c:	4505                	li	a0,1
     b6e:	00000097          	auipc	ra,0x0
     b72:	3a0080e7          	jalr	928(ra) # f0e <exit>
     b76:	e84a                	sd	s2,16(sp)
    exit(0);
  }

  int pid2 = fork();
     b78:	00000097          	auipc	ra,0x0
     b7c:	38e080e7          	jalr	910(ra) # f06 <fork>
     b80:	892a                	mv	s2,a0
  if(pid2 < 0){
     b82:	02054263          	bltz	a0,ba6 <iter+0xa4>
    printf("grind: fork failed\n");
    exit(1);
  }
  if(pid2 == 0){
     b86:	ed0d                	bnez	a0,bc0 <iter+0xbe>
    rand_next ^= 7177;
     b88:	00002697          	auipc	a3,0x2
     b8c:	a4868693          	addi	a3,a3,-1464 # 25d0 <rand_next>
     b90:	629c                	ld	a5,0(a3)
     b92:	6709                	lui	a4,0x2
     b94:	c0970713          	addi	a4,a4,-1015 # 1c09 <digits+0x169>
     b98:	8fb9                	xor	a5,a5,a4
     b9a:	e29c                	sd	a5,0(a3)
    go(1);
     b9c:	4505                	li	a0,1
     b9e:	fffff097          	auipc	ra,0xfffff
     ba2:	510080e7          	jalr	1296(ra) # ae <go>
    printf("grind: fork failed\n");
     ba6:	00001517          	auipc	a0,0x1
     baa:	c1a50513          	addi	a0,a0,-998 # 17c0 <ithread_join+0x158>
     bae:	00000097          	auipc	ra,0x0
     bb2:	6fe080e7          	jalr	1790(ra) # 12ac <printf>
    exit(1);
     bb6:	4505                	li	a0,1
     bb8:	00000097          	auipc	ra,0x0
     bbc:	356080e7          	jalr	854(ra) # f0e <exit>
    exit(0);
  }

  int st1 = -1;
     bc0:	57fd                	li	a5,-1
     bc2:	fcf42e23          	sw	a5,-36(s0)
  wait(&st1);
     bc6:	fdc40513          	addi	a0,s0,-36
     bca:	00000097          	auipc	ra,0x0
     bce:	34c080e7          	jalr	844(ra) # f16 <wait>
  if(st1 != 0){
     bd2:	fdc42783          	lw	a5,-36(s0)
     bd6:	ef99                	bnez	a5,bf4 <iter+0xf2>
    kill(pid1);
    kill(pid2);
  }
  int st2 = -1;
     bd8:	57fd                	li	a5,-1
     bda:	fcf42c23          	sw	a5,-40(s0)
  wait(&st2);
     bde:	fd840513          	addi	a0,s0,-40
     be2:	00000097          	auipc	ra,0x0
     be6:	334080e7          	jalr	820(ra) # f16 <wait>

  exit(0);
     bea:	4501                	li	a0,0
     bec:	00000097          	auipc	ra,0x0
     bf0:	322080e7          	jalr	802(ra) # f0e <exit>
    kill(pid1);
     bf4:	8526                	mv	a0,s1
     bf6:	00000097          	auipc	ra,0x0
     bfa:	348080e7          	jalr	840(ra) # f3e <kill>
    kill(pid2);
     bfe:	854a                	mv	a0,s2
     c00:	00000097          	auipc	ra,0x0
     c04:	33e080e7          	jalr	830(ra) # f3e <kill>
     c08:	bfc1                	j	bd8 <iter+0xd6>

0000000000000c0a <main>:
}

int
main()
{
     c0a:	1101                	addi	sp,sp,-32
     c0c:	ec06                	sd	ra,24(sp)
     c0e:	e822                	sd	s0,16(sp)
     c10:	e426                	sd	s1,8(sp)
     c12:	e04a                	sd	s2,0(sp)
     c14:	1000                	addi	s0,sp,32
      exit(0);
    }
    if(pid > 0){
      wait(0);
    }
    sleep(20);
     c16:	4951                	li	s2,20
    rand_next += 1;
     c18:	00002497          	auipc	s1,0x2
     c1c:	9b848493          	addi	s1,s1,-1608 # 25d0 <rand_next>
     c20:	a829                	j	c3a <main+0x30>
      iter();
     c22:	00000097          	auipc	ra,0x0
     c26:	ee0080e7          	jalr	-288(ra) # b02 <iter>
    sleep(20);
     c2a:	854a                	mv	a0,s2
     c2c:	00000097          	auipc	ra,0x0
     c30:	372080e7          	jalr	882(ra) # f9e <sleep>
    rand_next += 1;
     c34:	609c                	ld	a5,0(s1)
     c36:	0785                	addi	a5,a5,1
     c38:	e09c                	sd	a5,0(s1)
    int pid = fork();
     c3a:	00000097          	auipc	ra,0x0
     c3e:	2cc080e7          	jalr	716(ra) # f06 <fork>
    if(pid == 0){
     c42:	d165                	beqz	a0,c22 <main+0x18>
    if(pid > 0){
     c44:	fea053e3          	blez	a0,c2a <main+0x20>
      wait(0);
     c48:	4501                	li	a0,0
     c4a:	00000097          	auipc	ra,0x0
     c4e:	2cc080e7          	jalr	716(ra) # f16 <wait>
     c52:	bfe1                	j	c2a <main+0x20>

0000000000000c54 <_main>:
//
// wrapper so that it's OK if main() does not call exit().
//
void
_main()
{
     c54:	1141                	addi	sp,sp,-16
     c56:	e406                	sd	ra,8(sp)
     c58:	e022                	sd	s0,0(sp)
     c5a:	0800                	addi	s0,sp,16
  extern int main();
  main();
     c5c:	00000097          	auipc	ra,0x0
     c60:	fae080e7          	jalr	-82(ra) # c0a <main>
  exit(0);
     c64:	4501                	li	a0,0
     c66:	00000097          	auipc	ra,0x0
     c6a:	2a8080e7          	jalr	680(ra) # f0e <exit>

0000000000000c6e <strcpy>:
}

char*
strcpy(char *s, const char *t)
{
     c6e:	1141                	addi	sp,sp,-16
     c70:	e406                	sd	ra,8(sp)
     c72:	e022                	sd	s0,0(sp)
     c74:	0800                	addi	s0,sp,16
  char *os;

  os = s;
  while((*s++ = *t++) != 0)
     c76:	87aa                	mv	a5,a0
     c78:	0585                	addi	a1,a1,1
     c7a:	0785                	addi	a5,a5,1
     c7c:	fff5c703          	lbu	a4,-1(a1)
     c80:	fee78fa3          	sb	a4,-1(a5)
     c84:	fb75                	bnez	a4,c78 <strcpy+0xa>
    ;
  return os;
}
     c86:	60a2                	ld	ra,8(sp)
     c88:	6402                	ld	s0,0(sp)
     c8a:	0141                	addi	sp,sp,16
     c8c:	8082                	ret

0000000000000c8e <strcmp>:

int
strcmp(const char *p, const char *q)
{
     c8e:	1141                	addi	sp,sp,-16
     c90:	e406                	sd	ra,8(sp)
     c92:	e022                	sd	s0,0(sp)
     c94:	0800                	addi	s0,sp,16
  while(*p && *p == *q)
     c96:	00054783          	lbu	a5,0(a0)
     c9a:	cb91                	beqz	a5,cae <strcmp+0x20>
     c9c:	0005c703          	lbu	a4,0(a1)
     ca0:	00f71763          	bne	a4,a5,cae <strcmp+0x20>
    p++, q++;
     ca4:	0505                	addi	a0,a0,1
     ca6:	0585                	addi	a1,a1,1
  while(*p && *p == *q)
     ca8:	00054783          	lbu	a5,0(a0)
     cac:	fbe5                	bnez	a5,c9c <strcmp+0xe>
  return (uchar)*p - (uchar)*q;
     cae:	0005c503          	lbu	a0,0(a1)
}
     cb2:	40a7853b          	subw	a0,a5,a0
     cb6:	60a2                	ld	ra,8(sp)
     cb8:	6402                	ld	s0,0(sp)
     cba:	0141                	addi	sp,sp,16
     cbc:	8082                	ret

0000000000000cbe <strlen>:

uint
strlen(const char *s)
{
     cbe:	1141                	addi	sp,sp,-16
     cc0:	e406                	sd	ra,8(sp)
     cc2:	e022                	sd	s0,0(sp)
     cc4:	0800                	addi	s0,sp,16
  int n;

  for(n = 0; s[n]; n++)
     cc6:	00054783          	lbu	a5,0(a0)
     cca:	cf99                	beqz	a5,ce8 <strlen+0x2a>
     ccc:	0505                	addi	a0,a0,1
     cce:	87aa                	mv	a5,a0
     cd0:	86be                	mv	a3,a5
     cd2:	0785                	addi	a5,a5,1
     cd4:	fff7c703          	lbu	a4,-1(a5)
     cd8:	ff65                	bnez	a4,cd0 <strlen+0x12>
     cda:	40a6853b          	subw	a0,a3,a0
     cde:	2505                	addiw	a0,a0,1
    ;
  return n;
}
     ce0:	60a2                	ld	ra,8(sp)
     ce2:	6402                	ld	s0,0(sp)
     ce4:	0141                	addi	sp,sp,16
     ce6:	8082                	ret
  for(n = 0; s[n]; n++)
     ce8:	4501                	li	a0,0
     cea:	bfdd                	j	ce0 <strlen+0x22>

0000000000000cec <memset>:

void*
memset(void *dst, int c, uint n)
{
     cec:	1141                	addi	sp,sp,-16
     cee:	e406                	sd	ra,8(sp)
     cf0:	e022                	sd	s0,0(sp)
     cf2:	0800                	addi	s0,sp,16
  char *cdst = (char *) dst;
  int i;
  for(i = 0; i < n; i++){
     cf4:	ca19                	beqz	a2,d0a <memset+0x1e>
     cf6:	87aa                	mv	a5,a0
     cf8:	1602                	slli	a2,a2,0x20
     cfa:	9201                	srli	a2,a2,0x20
     cfc:	00a60733          	add	a4,a2,a0
    cdst[i] = c;
     d00:	00b78023          	sb	a1,0(a5)
  for(i = 0; i < n; i++){
     d04:	0785                	addi	a5,a5,1
     d06:	fee79de3          	bne	a5,a4,d00 <memset+0x14>
  }
  return dst;
}
     d0a:	60a2                	ld	ra,8(sp)
     d0c:	6402                	ld	s0,0(sp)
     d0e:	0141                	addi	sp,sp,16
     d10:	8082                	ret

0000000000000d12 <strchr>:

char*
strchr(const char *s, char c)
{
     d12:	1141                	addi	sp,sp,-16
     d14:	e406                	sd	ra,8(sp)
     d16:	e022                	sd	s0,0(sp)
     d18:	0800                	addi	s0,sp,16
  for(; *s; s++)
     d1a:	00054783          	lbu	a5,0(a0)
     d1e:	cf81                	beqz	a5,d36 <strchr+0x24>
    if(*s == c)
     d20:	00f58763          	beq	a1,a5,d2e <strchr+0x1c>
  for(; *s; s++)
     d24:	0505                	addi	a0,a0,1
     d26:	00054783          	lbu	a5,0(a0)
     d2a:	fbfd                	bnez	a5,d20 <strchr+0xe>
      return (char*)s;
  return 0;
     d2c:	4501                	li	a0,0
}
     d2e:	60a2                	ld	ra,8(sp)
     d30:	6402                	ld	s0,0(sp)
     d32:	0141                	addi	sp,sp,16
     d34:	8082                	ret
  return 0;
     d36:	4501                	li	a0,0
     d38:	bfdd                	j	d2e <strchr+0x1c>

0000000000000d3a <gets>:

char*
gets(char *buf, int max)
{
     d3a:	7159                	addi	sp,sp,-112
     d3c:	f486                	sd	ra,104(sp)
     d3e:	f0a2                	sd	s0,96(sp)
     d40:	eca6                	sd	s1,88(sp)
     d42:	e8ca                	sd	s2,80(sp)
     d44:	e4ce                	sd	s3,72(sp)
     d46:	e0d2                	sd	s4,64(sp)
     d48:	fc56                	sd	s5,56(sp)
     d4a:	f85a                	sd	s6,48(sp)
     d4c:	f45e                	sd	s7,40(sp)
     d4e:	f062                	sd	s8,32(sp)
     d50:	ec66                	sd	s9,24(sp)
     d52:	e86a                	sd	s10,16(sp)
     d54:	1880                	addi	s0,sp,112
     d56:	8caa                	mv	s9,a0
     d58:	8a2e                	mv	s4,a1
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
     d5a:	892a                	mv	s2,a0
     d5c:	4481                	li	s1,0
    cc = read(0, &c, 1);
     d5e:	f9f40b13          	addi	s6,s0,-97
     d62:	4a85                	li	s5,1
    if(cc < 1)
      break;
    buf[i++] = c;
    if(c == '\n' || c == '\r')
     d64:	4ba9                	li	s7,10
     d66:	4c35                	li	s8,13
  for(i=0; i+1 < max; ){
     d68:	8d26                	mv	s10,s1
     d6a:	0014899b          	addiw	s3,s1,1
     d6e:	84ce                	mv	s1,s3
     d70:	0349d763          	bge	s3,s4,d9e <gets+0x64>
    cc = read(0, &c, 1);
     d74:	8656                	mv	a2,s5
     d76:	85da                	mv	a1,s6
     d78:	4501                	li	a0,0
     d7a:	00000097          	auipc	ra,0x0
     d7e:	1ac080e7          	jalr	428(ra) # f26 <read>
    if(cc < 1)
     d82:	00a05e63          	blez	a0,d9e <gets+0x64>
    buf[i++] = c;
     d86:	f9f44783          	lbu	a5,-97(s0)
     d8a:	00f90023          	sb	a5,0(s2)
    if(c == '\n' || c == '\r')
     d8e:	01778763          	beq	a5,s7,d9c <gets+0x62>
     d92:	0905                	addi	s2,s2,1
     d94:	fd879ae3          	bne	a5,s8,d68 <gets+0x2e>
    buf[i++] = c;
     d98:	8d4e                	mv	s10,s3
     d9a:	a011                	j	d9e <gets+0x64>
     d9c:	8d4e                	mv	s10,s3
      break;
  }
  buf[i] = '\0';
     d9e:	9d66                	add	s10,s10,s9
     da0:	000d0023          	sb	zero,0(s10)
  return buf;
}
     da4:	8566                	mv	a0,s9
     da6:	70a6                	ld	ra,104(sp)
     da8:	7406                	ld	s0,96(sp)
     daa:	64e6                	ld	s1,88(sp)
     dac:	6946                	ld	s2,80(sp)
     dae:	69a6                	ld	s3,72(sp)
     db0:	6a06                	ld	s4,64(sp)
     db2:	7ae2                	ld	s5,56(sp)
     db4:	7b42                	ld	s6,48(sp)
     db6:	7ba2                	ld	s7,40(sp)
     db8:	7c02                	ld	s8,32(sp)
     dba:	6ce2                	ld	s9,24(sp)
     dbc:	6d42                	ld	s10,16(sp)
     dbe:	6165                	addi	sp,sp,112
     dc0:	8082                	ret

0000000000000dc2 <stat>:

int
stat(const char *n, struct stat *st)
{
     dc2:	1101                	addi	sp,sp,-32
     dc4:	ec06                	sd	ra,24(sp)
     dc6:	e822                	sd	s0,16(sp)
     dc8:	e04a                	sd	s2,0(sp)
     dca:	1000                	addi	s0,sp,32
     dcc:	892e                	mv	s2,a1
  int fd;
  int r;

  fd = open(n, O_RDONLY);
     dce:	4581                	li	a1,0
     dd0:	00000097          	auipc	ra,0x0
     dd4:	17e080e7          	jalr	382(ra) # f4e <open>
  if(fd < 0)
     dd8:	02054663          	bltz	a0,e04 <stat+0x42>
     ddc:	e426                	sd	s1,8(sp)
     dde:	84aa                	mv	s1,a0
    return -1;
  r = fstat(fd, st);
     de0:	85ca                	mv	a1,s2
     de2:	00000097          	auipc	ra,0x0
     de6:	184080e7          	jalr	388(ra) # f66 <fstat>
     dea:	892a                	mv	s2,a0
  close(fd);
     dec:	8526                	mv	a0,s1
     dee:	00000097          	auipc	ra,0x0
     df2:	148080e7          	jalr	328(ra) # f36 <close>
  return r;
     df6:	64a2                	ld	s1,8(sp)
}
     df8:	854a                	mv	a0,s2
     dfa:	60e2                	ld	ra,24(sp)
     dfc:	6442                	ld	s0,16(sp)
     dfe:	6902                	ld	s2,0(sp)
     e00:	6105                	addi	sp,sp,32
     e02:	8082                	ret
    return -1;
     e04:	597d                	li	s2,-1
     e06:	bfcd                	j	df8 <stat+0x36>

0000000000000e08 <atoi>:

int
atoi(const char *s)
{
     e08:	1141                	addi	sp,sp,-16
     e0a:	e406                	sd	ra,8(sp)
     e0c:	e022                	sd	s0,0(sp)
     e0e:	0800                	addi	s0,sp,16
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
     e10:	00054683          	lbu	a3,0(a0)
     e14:	fd06879b          	addiw	a5,a3,-48
     e18:	0ff7f793          	zext.b	a5,a5
     e1c:	4625                	li	a2,9
     e1e:	02f66963          	bltu	a2,a5,e50 <atoi+0x48>
     e22:	872a                	mv	a4,a0
  n = 0;
     e24:	4501                	li	a0,0
    n = n*10 + *s++ - '0';
     e26:	0705                	addi	a4,a4,1
     e28:	0025179b          	slliw	a5,a0,0x2
     e2c:	9fa9                	addw	a5,a5,a0
     e2e:	0017979b          	slliw	a5,a5,0x1
     e32:	9fb5                	addw	a5,a5,a3
     e34:	fd07851b          	addiw	a0,a5,-48
  while('0' <= *s && *s <= '9')
     e38:	00074683          	lbu	a3,0(a4)
     e3c:	fd06879b          	addiw	a5,a3,-48
     e40:	0ff7f793          	zext.b	a5,a5
     e44:	fef671e3          	bgeu	a2,a5,e26 <atoi+0x1e>
  return n;
}
     e48:	60a2                	ld	ra,8(sp)
     e4a:	6402                	ld	s0,0(sp)
     e4c:	0141                	addi	sp,sp,16
     e4e:	8082                	ret
  n = 0;
     e50:	4501                	li	a0,0
     e52:	bfdd                	j	e48 <atoi+0x40>

0000000000000e54 <memmove>:

void*
memmove(void *vdst, const void *vsrc, int n)
{
     e54:	1141                	addi	sp,sp,-16
     e56:	e406                	sd	ra,8(sp)
     e58:	e022                	sd	s0,0(sp)
     e5a:	0800                	addi	s0,sp,16
  char *dst;
  const char *src;

  dst = vdst;
  src = vsrc;
  if (src > dst) {
     e5c:	02b57563          	bgeu	a0,a1,e86 <memmove+0x32>
    while(n-- > 0)
     e60:	00c05f63          	blez	a2,e7e <memmove+0x2a>
     e64:	1602                	slli	a2,a2,0x20
     e66:	9201                	srli	a2,a2,0x20
     e68:	00c507b3          	add	a5,a0,a2
  dst = vdst;
     e6c:	872a                	mv	a4,a0
      *dst++ = *src++;
     e6e:	0585                	addi	a1,a1,1
     e70:	0705                	addi	a4,a4,1
     e72:	fff5c683          	lbu	a3,-1(a1)
     e76:	fed70fa3          	sb	a3,-1(a4)
    while(n-- > 0)
     e7a:	fee79ae3          	bne	a5,a4,e6e <memmove+0x1a>
    src += n;
    while(n-- > 0)
      *--dst = *--src;
  }
  return vdst;
}
     e7e:	60a2                	ld	ra,8(sp)
     e80:	6402                	ld	s0,0(sp)
     e82:	0141                	addi	sp,sp,16
     e84:	8082                	ret
    dst += n;
     e86:	00c50733          	add	a4,a0,a2
    src += n;
     e8a:	95b2                	add	a1,a1,a2
    while(n-- > 0)
     e8c:	fec059e3          	blez	a2,e7e <memmove+0x2a>
     e90:	fff6079b          	addiw	a5,a2,-1
     e94:	1782                	slli	a5,a5,0x20
     e96:	9381                	srli	a5,a5,0x20
     e98:	fff7c793          	not	a5,a5
     e9c:	97ba                	add	a5,a5,a4
      *--dst = *--src;
     e9e:	15fd                	addi	a1,a1,-1
     ea0:	177d                	addi	a4,a4,-1
     ea2:	0005c683          	lbu	a3,0(a1)
     ea6:	00d70023          	sb	a3,0(a4)
    while(n-- > 0)
     eaa:	fef71ae3          	bne	a4,a5,e9e <memmove+0x4a>
     eae:	bfc1                	j	e7e <memmove+0x2a>

0000000000000eb0 <memcmp>:

int
memcmp(const void *s1, const void *s2, uint n)
{
     eb0:	1141                	addi	sp,sp,-16
     eb2:	e406                	sd	ra,8(sp)
     eb4:	e022                	sd	s0,0(sp)
     eb6:	0800                	addi	s0,sp,16
  const char *p1 = s1, *p2 = s2;
  while (n-- > 0) {
     eb8:	ca0d                	beqz	a2,eea <memcmp+0x3a>
     eba:	fff6069b          	addiw	a3,a2,-1
     ebe:	1682                	slli	a3,a3,0x20
     ec0:	9281                	srli	a3,a3,0x20
     ec2:	0685                	addi	a3,a3,1
     ec4:	96aa                	add	a3,a3,a0
    if (*p1 != *p2) {
     ec6:	00054783          	lbu	a5,0(a0)
     eca:	0005c703          	lbu	a4,0(a1)
     ece:	00e79863          	bne	a5,a4,ede <memcmp+0x2e>
      return *p1 - *p2;
    }
    p1++;
     ed2:	0505                	addi	a0,a0,1
    p2++;
     ed4:	0585                	addi	a1,a1,1
  while (n-- > 0) {
     ed6:	fed518e3          	bne	a0,a3,ec6 <memcmp+0x16>
  }
  return 0;
     eda:	4501                	li	a0,0
     edc:	a019                	j	ee2 <memcmp+0x32>
      return *p1 - *p2;
     ede:	40e7853b          	subw	a0,a5,a4
}
     ee2:	60a2                	ld	ra,8(sp)
     ee4:	6402                	ld	s0,0(sp)
     ee6:	0141                	addi	sp,sp,16
     ee8:	8082                	ret
  return 0;
     eea:	4501                	li	a0,0
     eec:	bfdd                	j	ee2 <memcmp+0x32>

0000000000000eee <memcpy>:

void *
memcpy(void *dst, const void *src, uint n)
{
     eee:	1141                	addi	sp,sp,-16
     ef0:	e406                	sd	ra,8(sp)
     ef2:	e022                	sd	s0,0(sp)
     ef4:	0800                	addi	s0,sp,16
  return memmove(dst, src, n);
     ef6:	00000097          	auipc	ra,0x0
     efa:	f5e080e7          	jalr	-162(ra) # e54 <memmove>
}
     efe:	60a2                	ld	ra,8(sp)
     f00:	6402                	ld	s0,0(sp)
     f02:	0141                	addi	sp,sp,16
     f04:	8082                	ret

0000000000000f06 <fork>:
# generated by usys.pl - do not edit
#include "kernel/syscall.h"
.global fork
fork:
 li a7, SYS_fork
     f06:	4885                	li	a7,1
 ecall
     f08:	00000073          	ecall
 ret
     f0c:	8082                	ret

0000000000000f0e <exit>:
.global exit
exit:
 li a7, SYS_exit
     f0e:	4889                	li	a7,2
 ecall
     f10:	00000073          	ecall
 ret
     f14:	8082                	ret

0000000000000f16 <wait>:
.global wait
wait:
 li a7, SYS_wait
     f16:	488d                	li	a7,3
 ecall
     f18:	00000073          	ecall
 ret
     f1c:	8082                	ret

0000000000000f1e <pipe>:
.global pipe
pipe:
 li a7, SYS_pipe
     f1e:	4891                	li	a7,4
 ecall
     f20:	00000073          	ecall
 ret
     f24:	8082                	ret

0000000000000f26 <read>:
.global read
read:
 li a7, SYS_read
     f26:	4895                	li	a7,5
 ecall
     f28:	00000073          	ecall
 ret
     f2c:	8082                	ret

0000000000000f2e <write>:
.global write
write:
 li a7, SYS_write
     f2e:	48c1                	li	a7,16
 ecall
     f30:	00000073          	ecall
 ret
     f34:	8082                	ret

0000000000000f36 <close>:
.global close
close:
 li a7, SYS_close
     f36:	48d5                	li	a7,21
 ecall
     f38:	00000073          	ecall
 ret
     f3c:	8082                	ret

0000000000000f3e <kill>:
.global kill
kill:
 li a7, SYS_kill
     f3e:	4899                	li	a7,6
 ecall
     f40:	00000073          	ecall
 ret
     f44:	8082                	ret

0000000000000f46 <exec>:
.global exec
exec:
 li a7, SYS_exec
     f46:	489d                	li	a7,7
 ecall
     f48:	00000073          	ecall
 ret
     f4c:	8082                	ret

0000000000000f4e <open>:
.global open
open:
 li a7, SYS_open
     f4e:	48bd                	li	a7,15
 ecall
     f50:	00000073          	ecall
 ret
     f54:	8082                	ret

0000000000000f56 <mknod>:
.global mknod
mknod:
 li a7, SYS_mknod
     f56:	48c5                	li	a7,17
 ecall
     f58:	00000073          	ecall
 ret
     f5c:	8082                	ret

0000000000000f5e <unlink>:
.global unlink
unlink:
 li a7, SYS_unlink
     f5e:	48c9                	li	a7,18
 ecall
     f60:	00000073          	ecall
 ret
     f64:	8082                	ret

0000000000000f66 <fstat>:
.global fstat
fstat:
 li a7, SYS_fstat
     f66:	48a1                	li	a7,8
 ecall
     f68:	00000073          	ecall
 ret
     f6c:	8082                	ret

0000000000000f6e <link>:
.global link
link:
 li a7, SYS_link
     f6e:	48cd                	li	a7,19
 ecall
     f70:	00000073          	ecall
 ret
     f74:	8082                	ret

0000000000000f76 <mkdir>:
.global mkdir
mkdir:
 li a7, SYS_mkdir
     f76:	48d1                	li	a7,20
 ecall
     f78:	00000073          	ecall
 ret
     f7c:	8082                	ret

0000000000000f7e <chdir>:
.global chdir
chdir:
 li a7, SYS_chdir
     f7e:	48a5                	li	a7,9
 ecall
     f80:	00000073          	ecall
 ret
     f84:	8082                	ret

0000000000000f86 <dup>:
.global dup
dup:
 li a7, SYS_dup
     f86:	48a9                	li	a7,10
 ecall
     f88:	00000073          	ecall
 ret
     f8c:	8082                	ret

0000000000000f8e <getpid>:
.global getpid
getpid:
 li a7, SYS_getpid
     f8e:	48ad                	li	a7,11
 ecall
     f90:	00000073          	ecall
 ret
     f94:	8082                	ret

0000000000000f96 <sbrk>:
.global sbrk
sbrk:
 li a7, SYS_sbrk
     f96:	48b1                	li	a7,12
 ecall
     f98:	00000073          	ecall
 ret
     f9c:	8082                	ret

0000000000000f9e <sleep>:
.global sleep
sleep:
 li a7, SYS_sleep
     f9e:	48b5                	li	a7,13
 ecall
     fa0:	00000073          	ecall
 ret
     fa4:	8082                	ret

0000000000000fa6 <uptime>:
.global uptime
uptime:
 li a7, SYS_uptime
     fa6:	48b9                	li	a7,14
 ecall
     fa8:	00000073          	ecall
 ret
     fac:	8082                	ret

0000000000000fae <spoon>:
.global spoon
spoon:
 li a7, SYS_spoon
     fae:	48d9                	li	a7,22
 ecall
     fb0:	00000073          	ecall
 ret
     fb4:	8082                	ret

0000000000000fb6 <create_thread>:
.global create_thread
create_thread:
 li a7, SYS_create_thread
     fb6:	48dd                	li	a7,23
 ecall
     fb8:	00000073          	ecall
 ret
     fbc:	8082                	ret

0000000000000fbe <join_thread>:
.global join_thread
join_thread:
 li a7, SYS_join_thread
     fbe:	48e1                	li	a7,24
 ecall
     fc0:	00000073          	ecall
 ret
     fc4:	8082                	ret

0000000000000fc6 <thread_exit>:
.global thread_exit
thread_exit:
 li a7, SYS_thread_exit
     fc6:	48e5                	li	a7,25
 ecall
     fc8:	00000073          	ecall
 ret
     fcc:	8082                	ret

0000000000000fce <socket>:
.global socket
socket:
 li a7, SYS_socket
     fce:	48e9                	li	a7,26
 ecall
     fd0:	00000073          	ecall
 ret
     fd4:	8082                	ret

0000000000000fd6 <bind>:
.global bind
bind:
 li a7, SYS_bind
     fd6:	48ed                	li	a7,27
 ecall
     fd8:	00000073          	ecall
 ret
     fdc:	8082                	ret

0000000000000fde <accept>:
.global accept
accept:
 li a7, SYS_accept
     fde:	48f5                	li	a7,29
 ecall
     fe0:	00000073          	ecall
 ret
     fe4:	8082                	ret

0000000000000fe6 <listen>:
.global listen
listen:
 li a7, SYS_listen
     fe6:	48f1                	li	a7,28
 ecall
     fe8:	00000073          	ecall
 ret
     fec:	8082                	ret

0000000000000fee <connect>:
.global connect
connect:
 li a7, SYS_connect
     fee:	48f9                	li	a7,30
 ecall
     ff0:	00000073          	ecall
 ret
     ff4:	8082                	ret

0000000000000ff6 <putc>:

static char digits[] = "0123456789ABCDEF";

static void
putc(int fd, char c)
{
     ff6:	1101                	addi	sp,sp,-32
     ff8:	ec06                	sd	ra,24(sp)
     ffa:	e822                	sd	s0,16(sp)
     ffc:	1000                	addi	s0,sp,32
     ffe:	feb407a3          	sb	a1,-17(s0)
  write(fd, &c, 1);
    1002:	4605                	li	a2,1
    1004:	fef40593          	addi	a1,s0,-17
    1008:	00000097          	auipc	ra,0x0
    100c:	f26080e7          	jalr	-218(ra) # f2e <write>
}
    1010:	60e2                	ld	ra,24(sp)
    1012:	6442                	ld	s0,16(sp)
    1014:	6105                	addi	sp,sp,32
    1016:	8082                	ret

0000000000001018 <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
    1018:	7139                	addi	sp,sp,-64
    101a:	fc06                	sd	ra,56(sp)
    101c:	f822                	sd	s0,48(sp)
    101e:	f426                	sd	s1,40(sp)
    1020:	f04a                	sd	s2,32(sp)
    1022:	ec4e                	sd	s3,24(sp)
    1024:	0080                	addi	s0,sp,64
    1026:	892a                	mv	s2,a0
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
  if(sgn && xx < 0){
    1028:	c299                	beqz	a3,102e <printint+0x16>
    102a:	0805c063          	bltz	a1,10aa <printint+0x92>
  neg = 0;
    102e:	4e01                	li	t3,0
    x = -xx;
  } else {
    x = xx;
  }

  i = 0;
    1030:	fc040313          	addi	t1,s0,-64
  neg = 0;
    1034:	869a                	mv	a3,t1
  i = 0;
    1036:	4781                	li	a5,0
  do{
    buf[i++] = digits[x % base];
    1038:	00001817          	auipc	a6,0x1
    103c:	a6880813          	addi	a6,a6,-1432 # 1aa0 <digits>
    1040:	88be                	mv	a7,a5
    1042:	0017851b          	addiw	a0,a5,1
    1046:	87aa                	mv	a5,a0
    1048:	02c5f73b          	remuw	a4,a1,a2
    104c:	1702                	slli	a4,a4,0x20
    104e:	9301                	srli	a4,a4,0x20
    1050:	9742                	add	a4,a4,a6
    1052:	00074703          	lbu	a4,0(a4)
    1056:	00e68023          	sb	a4,0(a3)
  }while((x /= base) != 0);
    105a:	872e                	mv	a4,a1
    105c:	02c5d5bb          	divuw	a1,a1,a2
    1060:	0685                	addi	a3,a3,1
    1062:	fcc77fe3          	bgeu	a4,a2,1040 <printint+0x28>
  if(neg)
    1066:	000e0c63          	beqz	t3,107e <printint+0x66>
    buf[i++] = '-';
    106a:	fd050793          	addi	a5,a0,-48
    106e:	00878533          	add	a0,a5,s0
    1072:	02d00793          	li	a5,45
    1076:	fef50823          	sb	a5,-16(a0)
    107a:	0028879b          	addiw	a5,a7,2

  while(--i >= 0)
    107e:	fff7899b          	addiw	s3,a5,-1
    1082:	006784b3          	add	s1,a5,t1
    putc(fd, buf[i]);
    1086:	fff4c583          	lbu	a1,-1(s1)
    108a:	854a                	mv	a0,s2
    108c:	00000097          	auipc	ra,0x0
    1090:	f6a080e7          	jalr	-150(ra) # ff6 <putc>
  while(--i >= 0)
    1094:	39fd                	addiw	s3,s3,-1
    1096:	14fd                	addi	s1,s1,-1
    1098:	fe09d7e3          	bgez	s3,1086 <printint+0x6e>
}
    109c:	70e2                	ld	ra,56(sp)
    109e:	7442                	ld	s0,48(sp)
    10a0:	74a2                	ld	s1,40(sp)
    10a2:	7902                	ld	s2,32(sp)
    10a4:	69e2                	ld	s3,24(sp)
    10a6:	6121                	addi	sp,sp,64
    10a8:	8082                	ret
    x = -xx;
    10aa:	40b005bb          	negw	a1,a1
    neg = 1;
    10ae:	4e05                	li	t3,1
    x = -xx;
    10b0:	b741                	j	1030 <printint+0x18>

00000000000010b2 <vprintf>:
}

// Print to the given fd. Only understands %d, %x, %p, %s.
void
vprintf(int fd, const char *fmt, va_list ap)
{
    10b2:	715d                	addi	sp,sp,-80
    10b4:	e486                	sd	ra,72(sp)
    10b6:	e0a2                	sd	s0,64(sp)
    10b8:	f84a                	sd	s2,48(sp)
    10ba:	0880                	addi	s0,sp,80
  char *s;
  int c, i, state;

  state = 0;
  for(i = 0; fmt[i]; i++){
    10bc:	0005c903          	lbu	s2,0(a1)
    10c0:	1a090a63          	beqz	s2,1274 <vprintf+0x1c2>
    10c4:	fc26                	sd	s1,56(sp)
    10c6:	f44e                	sd	s3,40(sp)
    10c8:	f052                	sd	s4,32(sp)
    10ca:	ec56                	sd	s5,24(sp)
    10cc:	e85a                	sd	s6,16(sp)
    10ce:	e45e                	sd	s7,8(sp)
    10d0:	8aaa                	mv	s5,a0
    10d2:	8bb2                	mv	s7,a2
    10d4:	00158493          	addi	s1,a1,1
  state = 0;
    10d8:	4981                	li	s3,0
      if(c == '%'){
        state = '%';
      } else {
        putc(fd, c);
      }
    } else if(state == '%'){
    10da:	02500a13          	li	s4,37
    10de:	4b55                	li	s6,21
    10e0:	a839                	j	10fe <vprintf+0x4c>
        putc(fd, c);
    10e2:	85ca                	mv	a1,s2
    10e4:	8556                	mv	a0,s5
    10e6:	00000097          	auipc	ra,0x0
    10ea:	f10080e7          	jalr	-240(ra) # ff6 <putc>
    10ee:	a019                	j	10f4 <vprintf+0x42>
    } else if(state == '%'){
    10f0:	01498d63          	beq	s3,s4,110a <vprintf+0x58>
  for(i = 0; fmt[i]; i++){
    10f4:	0485                	addi	s1,s1,1
    10f6:	fff4c903          	lbu	s2,-1(s1)
    10fa:	16090763          	beqz	s2,1268 <vprintf+0x1b6>
    if(state == 0){
    10fe:	fe0999e3          	bnez	s3,10f0 <vprintf+0x3e>
      if(c == '%'){
    1102:	ff4910e3          	bne	s2,s4,10e2 <vprintf+0x30>
        state = '%';
    1106:	89d2                	mv	s3,s4
    1108:	b7f5                	j	10f4 <vprintf+0x42>
      if(c == 'd'){
    110a:	13490463          	beq	s2,s4,1232 <vprintf+0x180>
    110e:	f9d9079b          	addiw	a5,s2,-99
    1112:	0ff7f793          	zext.b	a5,a5
    1116:	12fb6763          	bltu	s6,a5,1244 <vprintf+0x192>
    111a:	f9d9079b          	addiw	a5,s2,-99
    111e:	0ff7f713          	zext.b	a4,a5
    1122:	12eb6163          	bltu	s6,a4,1244 <vprintf+0x192>
    1126:	00271793          	slli	a5,a4,0x2
    112a:	00001717          	auipc	a4,0x1
    112e:	91e70713          	addi	a4,a4,-1762 # 1a48 <ithread_join+0x3e0>
    1132:	97ba                	add	a5,a5,a4
    1134:	439c                	lw	a5,0(a5)
    1136:	97ba                	add	a5,a5,a4
    1138:	8782                	jr	a5
        printint(fd, va_arg(ap, int), 10, 1);
    113a:	008b8913          	addi	s2,s7,8
    113e:	4685                	li	a3,1
    1140:	4629                	li	a2,10
    1142:	000ba583          	lw	a1,0(s7)
    1146:	8556                	mv	a0,s5
    1148:	00000097          	auipc	ra,0x0
    114c:	ed0080e7          	jalr	-304(ra) # 1018 <printint>
    1150:	8bca                	mv	s7,s2
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
        putc(fd, c);
      }
      state = 0;
    1152:	4981                	li	s3,0
    1154:	b745                	j	10f4 <vprintf+0x42>
        printint(fd, va_arg(ap, uint64), 10, 0);
    1156:	008b8913          	addi	s2,s7,8
    115a:	4681                	li	a3,0
    115c:	4629                	li	a2,10
    115e:	000ba583          	lw	a1,0(s7)
    1162:	8556                	mv	a0,s5
    1164:	00000097          	auipc	ra,0x0
    1168:	eb4080e7          	jalr	-332(ra) # 1018 <printint>
    116c:	8bca                	mv	s7,s2
      state = 0;
    116e:	4981                	li	s3,0
    1170:	b751                	j	10f4 <vprintf+0x42>
        printint(fd, va_arg(ap, int), 16, 0);
    1172:	008b8913          	addi	s2,s7,8
    1176:	4681                	li	a3,0
    1178:	4641                	li	a2,16
    117a:	000ba583          	lw	a1,0(s7)
    117e:	8556                	mv	a0,s5
    1180:	00000097          	auipc	ra,0x0
    1184:	e98080e7          	jalr	-360(ra) # 1018 <printint>
    1188:	8bca                	mv	s7,s2
      state = 0;
    118a:	4981                	li	s3,0
    118c:	b7a5                	j	10f4 <vprintf+0x42>
    118e:	e062                	sd	s8,0(sp)
        printptr(fd, va_arg(ap, uint64));
    1190:	008b8c13          	addi	s8,s7,8
    1194:	000bb983          	ld	s3,0(s7)
  putc(fd, '0');
    1198:	03000593          	li	a1,48
    119c:	8556                	mv	a0,s5
    119e:	00000097          	auipc	ra,0x0
    11a2:	e58080e7          	jalr	-424(ra) # ff6 <putc>
  putc(fd, 'x');
    11a6:	07800593          	li	a1,120
    11aa:	8556                	mv	a0,s5
    11ac:	00000097          	auipc	ra,0x0
    11b0:	e4a080e7          	jalr	-438(ra) # ff6 <putc>
    11b4:	4941                	li	s2,16
    putc(fd, digits[x >> (sizeof(uint64) * 8 - 4)]);
    11b6:	00001b97          	auipc	s7,0x1
    11ba:	8eab8b93          	addi	s7,s7,-1814 # 1aa0 <digits>
    11be:	03c9d793          	srli	a5,s3,0x3c
    11c2:	97de                	add	a5,a5,s7
    11c4:	0007c583          	lbu	a1,0(a5)
    11c8:	8556                	mv	a0,s5
    11ca:	00000097          	auipc	ra,0x0
    11ce:	e2c080e7          	jalr	-468(ra) # ff6 <putc>
  for (i = 0; i < (sizeof(uint64) * 2); i++, x <<= 4)
    11d2:	0992                	slli	s3,s3,0x4
    11d4:	397d                	addiw	s2,s2,-1
    11d6:	fe0914e3          	bnez	s2,11be <vprintf+0x10c>
        printptr(fd, va_arg(ap, uint64));
    11da:	8be2                	mv	s7,s8
      state = 0;
    11dc:	4981                	li	s3,0
    11de:	6c02                	ld	s8,0(sp)
    11e0:	bf11                	j	10f4 <vprintf+0x42>
        s = va_arg(ap, char*);
    11e2:	008b8993          	addi	s3,s7,8
    11e6:	000bb903          	ld	s2,0(s7)
        if(s == 0)
    11ea:	02090163          	beqz	s2,120c <vprintf+0x15a>
        while(*s != 0){
    11ee:	00094583          	lbu	a1,0(s2)
    11f2:	c9a5                	beqz	a1,1262 <vprintf+0x1b0>
          putc(fd, *s);
    11f4:	8556                	mv	a0,s5
    11f6:	00000097          	auipc	ra,0x0
    11fa:	e00080e7          	jalr	-512(ra) # ff6 <putc>
          s++;
    11fe:	0905                	addi	s2,s2,1
        while(*s != 0){
    1200:	00094583          	lbu	a1,0(s2)
    1204:	f9e5                	bnez	a1,11f4 <vprintf+0x142>
        s = va_arg(ap, char*);
    1206:	8bce                	mv	s7,s3
      state = 0;
    1208:	4981                	li	s3,0
    120a:	b5ed                	j	10f4 <vprintf+0x42>
          s = "(null)";
    120c:	00000917          	auipc	s2,0x0
    1210:	7ac90913          	addi	s2,s2,1964 # 19b8 <ithread_join+0x350>
        while(*s != 0){
    1214:	02800593          	li	a1,40
    1218:	bff1                	j	11f4 <vprintf+0x142>
        putc(fd, va_arg(ap, uint));
    121a:	008b8913          	addi	s2,s7,8
    121e:	000bc583          	lbu	a1,0(s7)
    1222:	8556                	mv	a0,s5
    1224:	00000097          	auipc	ra,0x0
    1228:	dd2080e7          	jalr	-558(ra) # ff6 <putc>
    122c:	8bca                	mv	s7,s2
      state = 0;
    122e:	4981                	li	s3,0
    1230:	b5d1                	j	10f4 <vprintf+0x42>
        putc(fd, c);
    1232:	02500593          	li	a1,37
    1236:	8556                	mv	a0,s5
    1238:	00000097          	auipc	ra,0x0
    123c:	dbe080e7          	jalr	-578(ra) # ff6 <putc>
      state = 0;
    1240:	4981                	li	s3,0
    1242:	bd4d                	j	10f4 <vprintf+0x42>
        putc(fd, '%');
    1244:	02500593          	li	a1,37
    1248:	8556                	mv	a0,s5
    124a:	00000097          	auipc	ra,0x0
    124e:	dac080e7          	jalr	-596(ra) # ff6 <putc>
        putc(fd, c);
    1252:	85ca                	mv	a1,s2
    1254:	8556                	mv	a0,s5
    1256:	00000097          	auipc	ra,0x0
    125a:	da0080e7          	jalr	-608(ra) # ff6 <putc>
      state = 0;
    125e:	4981                	li	s3,0
    1260:	bd51                	j	10f4 <vprintf+0x42>
        s = va_arg(ap, char*);
    1262:	8bce                	mv	s7,s3
      state = 0;
    1264:	4981                	li	s3,0
    1266:	b579                	j	10f4 <vprintf+0x42>
    1268:	74e2                	ld	s1,56(sp)
    126a:	79a2                	ld	s3,40(sp)
    126c:	7a02                	ld	s4,32(sp)
    126e:	6ae2                	ld	s5,24(sp)
    1270:	6b42                	ld	s6,16(sp)
    1272:	6ba2                	ld	s7,8(sp)
    }
  }
}
    1274:	60a6                	ld	ra,72(sp)
    1276:	6406                	ld	s0,64(sp)
    1278:	7942                	ld	s2,48(sp)
    127a:	6161                	addi	sp,sp,80
    127c:	8082                	ret

000000000000127e <fprintf>:

void
fprintf(int fd, const char *fmt, ...)
{
    127e:	715d                	addi	sp,sp,-80
    1280:	ec06                	sd	ra,24(sp)
    1282:	e822                	sd	s0,16(sp)
    1284:	1000                	addi	s0,sp,32
    1286:	e010                	sd	a2,0(s0)
    1288:	e414                	sd	a3,8(s0)
    128a:	e818                	sd	a4,16(s0)
    128c:	ec1c                	sd	a5,24(s0)
    128e:	03043023          	sd	a6,32(s0)
    1292:	03143423          	sd	a7,40(s0)
  va_list ap;

  va_start(ap, fmt);
    1296:	8622                	mv	a2,s0
    1298:	fe843423          	sd	s0,-24(s0)
  vprintf(fd, fmt, ap);
    129c:	00000097          	auipc	ra,0x0
    12a0:	e16080e7          	jalr	-490(ra) # 10b2 <vprintf>
}
    12a4:	60e2                	ld	ra,24(sp)
    12a6:	6442                	ld	s0,16(sp)
    12a8:	6161                	addi	sp,sp,80
    12aa:	8082                	ret

00000000000012ac <printf>:

void
printf(const char *fmt, ...)
{
    12ac:	711d                	addi	sp,sp,-96
    12ae:	ec06                	sd	ra,24(sp)
    12b0:	e822                	sd	s0,16(sp)
    12b2:	1000                	addi	s0,sp,32
    12b4:	e40c                	sd	a1,8(s0)
    12b6:	e810                	sd	a2,16(s0)
    12b8:	ec14                	sd	a3,24(s0)
    12ba:	f018                	sd	a4,32(s0)
    12bc:	f41c                	sd	a5,40(s0)
    12be:	03043823          	sd	a6,48(s0)
    12c2:	03143c23          	sd	a7,56(s0)
  va_list ap;

  va_start(ap, fmt);
    12c6:	00840613          	addi	a2,s0,8
    12ca:	fec43423          	sd	a2,-24(s0)
  vprintf(1, fmt, ap);
    12ce:	85aa                	mv	a1,a0
    12d0:	4505                	li	a0,1
    12d2:	00000097          	auipc	ra,0x0
    12d6:	de0080e7          	jalr	-544(ra) # 10b2 <vprintf>
}
    12da:	60e2                	ld	ra,24(sp)
    12dc:	6442                	ld	s0,16(sp)
    12de:	6125                	addi	sp,sp,96
    12e0:	8082                	ret

00000000000012e2 <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
    12e2:	1141                	addi	sp,sp,-16
    12e4:	e406                	sd	ra,8(sp)
    12e6:	e022                	sd	s0,0(sp)
    12e8:	0800                	addi	s0,sp,16
  Header *bp, *p;

  bp = (Header*)ap - 1;
    12ea:	ff050693          	addi	a3,a0,-16
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
    12ee:	00001797          	auipc	a5,0x1
    12f2:	2f27b783          	ld	a5,754(a5) # 25e0 <freep>
    12f6:	a02d                	j	1320 <free+0x3e>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
      break;
  if(bp + bp->s.size == p->s.ptr){
    bp->s.size += p->s.ptr->s.size;
    12f8:	4618                	lw	a4,8(a2)
    12fa:	9f2d                	addw	a4,a4,a1
    12fc:	fee52c23          	sw	a4,-8(a0)
    bp->s.ptr = p->s.ptr->s.ptr;
    1300:	6398                	ld	a4,0(a5)
    1302:	6310                	ld	a2,0(a4)
    1304:	a83d                	j	1342 <free+0x60>
  } else
    bp->s.ptr = p->s.ptr;
  if(p + p->s.size == bp){
    p->s.size += bp->s.size;
    1306:	ff852703          	lw	a4,-8(a0)
    130a:	9f31                	addw	a4,a4,a2
    130c:	c798                	sw	a4,8(a5)
    p->s.ptr = bp->s.ptr;
    130e:	ff053683          	ld	a3,-16(a0)
    1312:	a091                	j	1356 <free+0x74>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
    1314:	6398                	ld	a4,0(a5)
    1316:	00e7e463          	bltu	a5,a4,131e <free+0x3c>
    131a:	00e6ea63          	bltu	a3,a4,132e <free+0x4c>
{
    131e:	87ba                	mv	a5,a4
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
    1320:	fed7fae3          	bgeu	a5,a3,1314 <free+0x32>
    1324:	6398                	ld	a4,0(a5)
    1326:	00e6e463          	bltu	a3,a4,132e <free+0x4c>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
    132a:	fee7eae3          	bltu	a5,a4,131e <free+0x3c>
  if(bp + bp->s.size == p->s.ptr){
    132e:	ff852583          	lw	a1,-8(a0)
    1332:	6390                	ld	a2,0(a5)
    1334:	02059813          	slli	a6,a1,0x20
    1338:	01c85713          	srli	a4,a6,0x1c
    133c:	9736                	add	a4,a4,a3
    133e:	fae60de3          	beq	a2,a4,12f8 <free+0x16>
    bp->s.ptr = p->s.ptr->s.ptr;
    1342:	fec53823          	sd	a2,-16(a0)
  if(p + p->s.size == bp){
    1346:	4790                	lw	a2,8(a5)
    1348:	02061593          	slli	a1,a2,0x20
    134c:	01c5d713          	srli	a4,a1,0x1c
    1350:	973e                	add	a4,a4,a5
    1352:	fae68ae3          	beq	a3,a4,1306 <free+0x24>
    p->s.ptr = bp->s.ptr;
    1356:	e394                	sd	a3,0(a5)
  } else
    p->s.ptr = bp;
  freep = p;
    1358:	00001717          	auipc	a4,0x1
    135c:	28f73423          	sd	a5,648(a4) # 25e0 <freep>
}
    1360:	60a2                	ld	ra,8(sp)
    1362:	6402                	ld	s0,0(sp)
    1364:	0141                	addi	sp,sp,16
    1366:	8082                	ret

0000000000001368 <malloc>:
  return freep;
}

void*
malloc(uint nbytes)
{
    1368:	7139                	addi	sp,sp,-64
    136a:	fc06                	sd	ra,56(sp)
    136c:	f822                	sd	s0,48(sp)
    136e:	f04a                	sd	s2,32(sp)
    1370:	ec4e                	sd	s3,24(sp)
    1372:	0080                	addi	s0,sp,64
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
    1374:	02051993          	slli	s3,a0,0x20
    1378:	0209d993          	srli	s3,s3,0x20
    137c:	09bd                	addi	s3,s3,15
    137e:	0049d993          	srli	s3,s3,0x4
    1382:	2985                	addiw	s3,s3,1
    1384:	894e                	mv	s2,s3
  if((prevp = freep) == 0){
    1386:	00001517          	auipc	a0,0x1
    138a:	25a53503          	ld	a0,602(a0) # 25e0 <freep>
    138e:	c905                	beqz	a0,13be <malloc+0x56>
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
    1390:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
    1392:	4798                	lw	a4,8(a5)
    1394:	09377a63          	bgeu	a4,s3,1428 <malloc+0xc0>
    1398:	f426                	sd	s1,40(sp)
    139a:	e852                	sd	s4,16(sp)
    139c:	e456                	sd	s5,8(sp)
    139e:	e05a                	sd	s6,0(sp)
  if(nu < 4096)
    13a0:	8a4e                	mv	s4,s3
    13a2:	6705                	lui	a4,0x1
    13a4:	00e9f363          	bgeu	s3,a4,13aa <malloc+0x42>
    13a8:	6a05                	lui	s4,0x1
    13aa:	000a0b1b          	sext.w	s6,s4
  p = sbrk(nu * sizeof(Header));
    13ae:	004a1a1b          	slliw	s4,s4,0x4
        p->s.size = nunits;
      }
      freep = prevp;
      return (void*)(p + 1);
    }
    if(p == freep)
    13b2:	00001497          	auipc	s1,0x1
    13b6:	22e48493          	addi	s1,s1,558 # 25e0 <freep>
  if(p == (char*)-1)
    13ba:	5afd                	li	s5,-1
    13bc:	a089                	j	13fe <malloc+0x96>
    13be:	f426                	sd	s1,40(sp)
    13c0:	e852                	sd	s4,16(sp)
    13c2:	e456                	sd	s5,8(sp)
    13c4:	e05a                	sd	s6,0(sp)
    base.s.ptr = freep = prevp = &base;
    13c6:	00001797          	auipc	a5,0x1
    13ca:	62278793          	addi	a5,a5,1570 # 29e8 <base>
    13ce:	00001717          	auipc	a4,0x1
    13d2:	20f73923          	sd	a5,530(a4) # 25e0 <freep>
    13d6:	e39c                	sd	a5,0(a5)
    base.s.size = 0;
    13d8:	0007a423          	sw	zero,8(a5)
    if(p->s.size >= nunits){
    13dc:	b7d1                	j	13a0 <malloc+0x38>
        prevp->s.ptr = p->s.ptr;
    13de:	6398                	ld	a4,0(a5)
    13e0:	e118                	sd	a4,0(a0)
    13e2:	a8b9                	j	1440 <malloc+0xd8>
  hp->s.size = nu;
    13e4:	01652423          	sw	s6,8(a0)
  free((void*)(hp + 1));
    13e8:	0541                	addi	a0,a0,16
    13ea:	00000097          	auipc	ra,0x0
    13ee:	ef8080e7          	jalr	-264(ra) # 12e2 <free>
  return freep;
    13f2:	6088                	ld	a0,0(s1)
      if((p = morecore(nunits)) == 0)
    13f4:	c135                	beqz	a0,1458 <malloc+0xf0>
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
    13f6:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
    13f8:	4798                	lw	a4,8(a5)
    13fa:	03277363          	bgeu	a4,s2,1420 <malloc+0xb8>
    if(p == freep)
    13fe:	6098                	ld	a4,0(s1)
    1400:	853e                	mv	a0,a5
    1402:	fef71ae3          	bne	a4,a5,13f6 <malloc+0x8e>
  p = sbrk(nu * sizeof(Header));
    1406:	8552                	mv	a0,s4
    1408:	00000097          	auipc	ra,0x0
    140c:	b8e080e7          	jalr	-1138(ra) # f96 <sbrk>
  if(p == (char*)-1)
    1410:	fd551ae3          	bne	a0,s5,13e4 <malloc+0x7c>
        return 0;
    1414:	4501                	li	a0,0
    1416:	74a2                	ld	s1,40(sp)
    1418:	6a42                	ld	s4,16(sp)
    141a:	6aa2                	ld	s5,8(sp)
    141c:	6b02                	ld	s6,0(sp)
    141e:	a03d                	j	144c <malloc+0xe4>
    1420:	74a2                	ld	s1,40(sp)
    1422:	6a42                	ld	s4,16(sp)
    1424:	6aa2                	ld	s5,8(sp)
    1426:	6b02                	ld	s6,0(sp)
      if(p->s.size == nunits)
    1428:	fae90be3          	beq	s2,a4,13de <malloc+0x76>
        p->s.size -= nunits;
    142c:	4137073b          	subw	a4,a4,s3
    1430:	c798                	sw	a4,8(a5)
        p += p->s.size;
    1432:	02071693          	slli	a3,a4,0x20
    1436:	01c6d713          	srli	a4,a3,0x1c
    143a:	97ba                	add	a5,a5,a4
        p->s.size = nunits;
    143c:	0137a423          	sw	s3,8(a5)
      freep = prevp;
    1440:	00001717          	auipc	a4,0x1
    1444:	1aa73023          	sd	a0,416(a4) # 25e0 <freep>
      return (void*)(p + 1);
    1448:	01078513          	addi	a0,a5,16
  }
}
    144c:	70e2                	ld	ra,56(sp)
    144e:	7442                	ld	s0,48(sp)
    1450:	7902                	ld	s2,32(sp)
    1452:	69e2                	ld	s3,24(sp)
    1454:	6121                	addi	sp,sp,64
    1456:	8082                	ret
    1458:	74a2                	ld	s1,40(sp)
    145a:	6a42                	ld	s4,16(sp)
    145c:	6aa2                	ld	s5,8(sp)
    145e:	6b02                	ld	s6,0(sp)
    1460:	b7f5                	j	144c <malloc+0xe4>

0000000000001462 <ithread_exit>:
  free(stacks);
  stacks = new_stacks;
  return 0;
}

void ithread_exit(uint64 status) {
    1462:	1141                	addi	sp,sp,-16
    1464:	e406                	sd	ra,8(sp)
    1466:	e022                	sd	s0,0(sp)
    1468:	0800                	addi	s0,sp,16
  thread_exit(status);
    146a:	2501                	sext.w	a0,a0
    146c:	00000097          	auipc	ra,0x0
    1470:	b5a080e7          	jalr	-1190(ra) # fc6 <thread_exit>
}
    1474:	60a2                	ld	ra,8(sp)
    1476:	6402                	ld	s0,0(sp)
    1478:	0141                	addi	sp,sp,16
    147a:	8082                	ret

000000000000147c <free_stacks>:
int free_stacks() {
    147c:	7179                	addi	sp,sp,-48
    147e:	f406                	sd	ra,40(sp)
    1480:	f022                	sd	s0,32(sp)
    1482:	ec26                	sd	s1,24(sp)
    1484:	1800                	addi	s0,sp,48
  for (int i = 0; i < num_threads; i++) {
    1486:	00001797          	auipc	a5,0x1
    148a:	16a7a783          	lw	a5,362(a5) # 25f0 <num_threads>
    148e:	04f05063          	blez	a5,14ce <free_stacks+0x52>
    1492:	e84a                	sd	s2,16(sp)
    1494:	e44e                	sd	s3,8(sp)
    1496:	4481                	li	s1,0
    free(stacks[i]);
    1498:	00001997          	auipc	s3,0x1
    149c:	15098993          	addi	s3,s3,336 # 25e8 <stacks>
  for (int i = 0; i < num_threads; i++) {
    14a0:	00001917          	auipc	s2,0x1
    14a4:	15090913          	addi	s2,s2,336 # 25f0 <num_threads>
    free(stacks[i]);
    14a8:	0009b783          	ld	a5,0(s3)
    14ac:	00349713          	slli	a4,s1,0x3
    14b0:	97ba                	add	a5,a5,a4
    14b2:	6388                	ld	a0,0(a5)
    14b4:	00000097          	auipc	ra,0x0
    14b8:	e2e080e7          	jalr	-466(ra) # 12e2 <free>
  for (int i = 0; i < num_threads; i++) {
    14bc:	0485                	addi	s1,s1,1
    14be:	00092703          	lw	a4,0(s2)
    14c2:	0004879b          	sext.w	a5,s1
    14c6:	fee7c1e3          	blt	a5,a4,14a8 <free_stacks+0x2c>
    14ca:	6942                	ld	s2,16(sp)
    14cc:	69a2                	ld	s3,8(sp)
  free(stacks);
    14ce:	00001497          	auipc	s1,0x1
    14d2:	11a48493          	addi	s1,s1,282 # 25e8 <stacks>
    14d6:	6088                	ld	a0,0(s1)
    14d8:	00000097          	auipc	ra,0x0
    14dc:	e0a080e7          	jalr	-502(ra) # 12e2 <free>
  stacks = 0;
    14e0:	0004b023          	sd	zero,0(s1)
  num_threads = 0;
    14e4:	00001797          	auipc	a5,0x1
    14e8:	1007a623          	sw	zero,268(a5) # 25f0 <num_threads>
  max_stacks = INIT_MAX_STACKS;
    14ec:	47a1                	li	a5,8
    14ee:	00001717          	auipc	a4,0x1
    14f2:	0ef72523          	sw	a5,234(a4) # 25d8 <max_stacks>
  threads_done = 0;
    14f6:	00001797          	auipc	a5,0x1
    14fa:	0e07af23          	sw	zero,254(a5) # 25f4 <threads_done>
}
    14fe:	4501                	li	a0,0
    1500:	70a2                	ld	ra,40(sp)
    1502:	7402                	ld	s0,32(sp)
    1504:	64e2                	ld	s1,24(sp)
    1506:	6145                	addi	sp,sp,48
    1508:	8082                	ret

000000000000150a <expand_num_threads>:
int expand_num_threads() {
    150a:	1101                	addi	sp,sp,-32
    150c:	ec06                	sd	ra,24(sp)
    150e:	e822                	sd	s0,16(sp)
    1510:	e426                	sd	s1,8(sp)
    1512:	e04a                	sd	s2,0(sp)
    1514:	1000                	addi	s0,sp,32
  max_stacks *= 2;
    1516:	00001797          	auipc	a5,0x1
    151a:	0c278793          	addi	a5,a5,194 # 25d8 <max_stacks>
    151e:	4388                	lw	a0,0(a5)
    1520:	0015151b          	slliw	a0,a0,0x1
    1524:	c388                	sw	a0,0(a5)
  void **new_stacks = malloc(max_stacks*sizeof(char*));
    1526:	0035151b          	slliw	a0,a0,0x3
    152a:	00000097          	auipc	ra,0x0
    152e:	e3e080e7          	jalr	-450(ra) # 1368 <malloc>
    1532:	892a                	mv	s2,a0
  memmove(new_stacks, stacks, num_threads*sizeof(char*));
    1534:	00001617          	auipc	a2,0x1
    1538:	0bc62603          	lw	a2,188(a2) # 25f0 <num_threads>
    153c:	00001497          	auipc	s1,0x1
    1540:	0ac48493          	addi	s1,s1,172 # 25e8 <stacks>
    1544:	0036161b          	slliw	a2,a2,0x3
    1548:	608c                	ld	a1,0(s1)
    154a:	00000097          	auipc	ra,0x0
    154e:	90a080e7          	jalr	-1782(ra) # e54 <memmove>
  free(stacks);
    1552:	6088                	ld	a0,0(s1)
    1554:	00000097          	auipc	ra,0x0
    1558:	d8e080e7          	jalr	-626(ra) # 12e2 <free>
  stacks = new_stacks;
    155c:	0124b023          	sd	s2,0(s1)
}
    1560:	4501                	li	a0,0
    1562:	60e2                	ld	ra,24(sp)
    1564:	6442                	ld	s0,16(sp)
    1566:	64a2                	ld	s1,8(sp)
    1568:	6902                	ld	s2,0(sp)
    156a:	6105                	addi	sp,sp,32
    156c:	8082                	ret

000000000000156e <ithread_create>:

int ithread_create(void* (*fn_ptr)(void *), void *args) {
    156e:	7179                	addi	sp,sp,-48
    1570:	f406                	sd	ra,40(sp)
    1572:	f022                	sd	s0,32(sp)
    1574:	e84a                	sd	s2,16(sp)
    1576:	e44e                	sd	s3,8(sp)
    1578:	1800                	addi	s0,sp,48
    157a:	892a                	mv	s2,a0
    157c:	89ae                	mv	s3,a1
  if (stacks == 0) {
    157e:	00001797          	auipc	a5,0x1
    1582:	06a7b783          	ld	a5,106(a5) # 25e8 <stacks>
    1586:	c3d9                	beqz	a5,160c <ithread_create+0x9e>
    stacks = malloc(max_stacks*sizeof(char*));
  }
  if (num_threads == max_stacks) {
    1588:	00001797          	auipc	a5,0x1
    158c:	0507a783          	lw	a5,80(a5) # 25d8 <max_stacks>
    1590:	00001717          	auipc	a4,0x1
    1594:	06072703          	lw	a4,96(a4) # 25f0 <num_threads>
    1598:	0af71363          	bne	a4,a5,163e <ithread_create+0xd0>
    if (max_stacks == MAX_THREADS) {
    159c:	04000713          	li	a4,64
    15a0:	08e78563          	beq	a5,a4,162a <ithread_create+0xbc>
    15a4:	ec26                	sd	s1,24(sp)
      printf("ERROR: Thread capacity has been reached\n");
      return -1;
    }
    expand_num_threads();
    15a6:	00000097          	auipc	ra,0x0
    15aa:	f64080e7          	jalr	-156(ra) # 150a <expand_num_threads>
  }

  void *stack_ptr = malloc(PGSIZE);
    15ae:	6505                	lui	a0,0x1
    15b0:	00000097          	auipc	ra,0x0
    15b4:	db8080e7          	jalr	-584(ra) # 1368 <malloc>
    15b8:	84aa                	mv	s1,a0
  stacks[num_threads] = stack_ptr;
    15ba:	00001717          	auipc	a4,0x1
    15be:	03672703          	lw	a4,54(a4) # 25f0 <num_threads>
    15c2:	070e                	slli	a4,a4,0x3
    15c4:	00001797          	auipc	a5,0x1
    15c8:	0247b783          	ld	a5,36(a5) # 25e8 <stacks>
    15cc:	97ba                	add	a5,a5,a4
    15ce:	e388                	sd	a0,0(a5)
  int res = create_thread(fn_ptr, args, stack_ptr, &ithread_exit);
    15d0:	00000697          	auipc	a3,0x0
    15d4:	e9268693          	addi	a3,a3,-366 # 1462 <ithread_exit>
    15d8:	862a                	mv	a2,a0
    15da:	85ce                	mv	a1,s3
    15dc:	854a                	mv	a0,s2
    15de:	00000097          	auipc	ra,0x0
    15e2:	9d8080e7          	jalr	-1576(ra) # fb6 <create_thread>
    15e6:	892a                	mv	s2,a0
  if (res != -1) {
    15e8:	57fd                	li	a5,-1
    15ea:	04f50c63          	beq	a0,a5,1642 <ithread_create+0xd4>
    num_threads++;
    15ee:	00001717          	auipc	a4,0x1
    15f2:	00270713          	addi	a4,a4,2 # 25f0 <num_threads>
    15f6:	431c                	lw	a5,0(a4)
    15f8:	2785                	addiw	a5,a5,1
    15fa:	c31c                	sw	a5,0(a4)
    15fc:	64e2                	ld	s1,24(sp)
  } else {
    free(stack_ptr);
    stacks[num_threads] = 0;
  }
  return res;
}
    15fe:	854a                	mv	a0,s2
    1600:	70a2                	ld	ra,40(sp)
    1602:	7402                	ld	s0,32(sp)
    1604:	6942                	ld	s2,16(sp)
    1606:	69a2                	ld	s3,8(sp)
    1608:	6145                	addi	sp,sp,48
    160a:	8082                	ret
    stacks = malloc(max_stacks*sizeof(char*));
    160c:	00001517          	auipc	a0,0x1
    1610:	fcc52503          	lw	a0,-52(a0) # 25d8 <max_stacks>
    1614:	0035151b          	slliw	a0,a0,0x3
    1618:	00000097          	auipc	ra,0x0
    161c:	d50080e7          	jalr	-688(ra) # 1368 <malloc>
    1620:	00001797          	auipc	a5,0x1
    1624:	fca7b423          	sd	a0,-56(a5) # 25e8 <stacks>
    1628:	b785                	j	1588 <ithread_create+0x1a>
      printf("ERROR: Thread capacity has been reached\n");
    162a:	00000517          	auipc	a0,0x0
    162e:	39650513          	addi	a0,a0,918 # 19c0 <ithread_join+0x358>
    1632:	00000097          	auipc	ra,0x0
    1636:	c7a080e7          	jalr	-902(ra) # 12ac <printf>
      return -1;
    163a:	597d                	li	s2,-1
    163c:	b7c9                	j	15fe <ithread_create+0x90>
    163e:	ec26                	sd	s1,24(sp)
    1640:	b7bd                	j	15ae <ithread_create+0x40>
    free(stack_ptr);
    1642:	8526                	mv	a0,s1
    1644:	00000097          	auipc	ra,0x0
    1648:	c9e080e7          	jalr	-866(ra) # 12e2 <free>
    stacks[num_threads] = 0;
    164c:	00001717          	auipc	a4,0x1
    1650:	fa472703          	lw	a4,-92(a4) # 25f0 <num_threads>
    1654:	070e                	slli	a4,a4,0x3
    1656:	00001797          	auipc	a5,0x1
    165a:	f927b783          	ld	a5,-110(a5) # 25e8 <stacks>
    165e:	97ba                	add	a5,a5,a4
    1660:	0007b023          	sd	zero,0(a5)
    1664:	64e2                	ld	s1,24(sp)
    1666:	bf61                	j	15fe <ithread_create+0x90>

0000000000001668 <ithread_join>:

int ithread_join(int thread_id) {
    1668:	1101                	addi	sp,sp,-32
    166a:	ec06                	sd	ra,24(sp)
    166c:	e822                	sd	s0,16(sp)
    166e:	1000                	addi	s0,sp,32
  int status;
  join_thread(thread_id, (uint64)&status);
    1670:	ff040793          	addi	a5,s0,-16
    1674:	ffc7859b          	addiw	a1,a5,-4
    1678:	00000097          	auipc	ra,0x0
    167c:	946080e7          	jalr	-1722(ra) # fbe <join_thread>
  threads_done++;
    1680:	00001717          	auipc	a4,0x1
    1684:	f7470713          	addi	a4,a4,-140 # 25f4 <threads_done>
    1688:	431c                	lw	a5,0(a4)
    168a:	2785                	addiw	a5,a5,1
    168c:	c31c                	sw	a5,0(a4)
  if (threads_done == num_threads) {
    168e:	00001717          	auipc	a4,0x1
    1692:	f6272703          	lw	a4,-158(a4) # 25f0 <num_threads>
    1696:	00f70863          	beq	a4,a5,16a6 <ithread_join+0x3e>
    free_stacks();
  }
  return status;
}
    169a:	fec42503          	lw	a0,-20(s0)
    169e:	60e2                	ld	ra,24(sp)
    16a0:	6442                	ld	s0,16(sp)
    16a2:	6105                	addi	sp,sp,32
    16a4:	8082                	ret
    free_stacks();
    16a6:	00000097          	auipc	ra,0x0
    16aa:	dd6080e7          	jalr	-554(ra) # 147c <free_stacks>
    16ae:	b7f5                	j	169a <ithread_join+0x32>
