
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
      c0:	ecc080e7          	jalr	-308(ra) # f88 <sbrk>
      c4:	f4a43c23          	sd	a0,-168(s0)
  uint64 iters = 0;

  mkdir("grindir");
      c8:	00001517          	auipc	a0,0x1
      cc:	5f850513          	addi	a0,a0,1528 # 16c0 <ithread_join+0x54>
      d0:	00001097          	auipc	ra,0x1
      d4:	e98080e7          	jalr	-360(ra) # f68 <mkdir>
  if(chdir("grindir") != 0){
      d8:	00001517          	auipc	a0,0x1
      dc:	5e850513          	addi	a0,a0,1512 # 16c0 <ithread_join+0x54>
      e0:	00001097          	auipc	ra,0x1
      e4:	e90080e7          	jalr	-368(ra) # f70 <chdir>
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
     102:	5ca50513          	addi	a0,a0,1482 # 16c8 <ithread_join+0x5c>
     106:	00001097          	auipc	ra,0x1
     10a:	1a8080e7          	jalr	424(ra) # 12ae <printf>
    exit(1);
     10e:	4505                	li	a0,1
     110:	00001097          	auipc	ra,0x1
     114:	df0080e7          	jalr	-528(ra) # f00 <exit>
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
     130:	5c450513          	addi	a0,a0,1476 # 16f0 <ithread_join+0x84>
     134:	00001097          	auipc	ra,0x1
     138:	e3c080e7          	jalr	-452(ra) # f70 <chdir>
     13c:	00001c17          	auipc	s8,0x1
     140:	5c4c0c13          	addi	s8,s8,1476 # 1700 <ithread_join+0x94>
     144:	c489                	beqz	s1,14e <go+0xa0>
     146:	00001c17          	auipc	s8,0x1
     14a:	5b2c0c13          	addi	s8,s8,1458 # 16f8 <ithread_join+0x8c>
  uint64 iters = 0;
     14e:	4481                	li	s1,0
  int fd = -1;
     150:	5cfd                	li	s9,-1
  
  while(1){
    iters++;
    if((iters % 500) == 0)
     152:	106259b7          	lui	s3,0x10625
     156:	dd398993          	addi	s3,s3,-557 # 10624dd3 <base+0x106223eb>
     15a:	09be                	slli	s3,s3,0xf
     15c:	8d598993          	addi	s3,s3,-1835
     160:	09ca                	slli	s3,s3,0x12
     162:	80098993          	addi	s3,s3,-2048
     166:	fcf98993          	addi	s3,s3,-49
     16a:	1f400b93          	li	s7,500
      write(1, which_child?"B":"A", 1);
     16e:	4a05                	li	s4,1
    int what = rand() % 23;
     170:	b2164ab7          	lui	s5,0xb2164
     174:	2c9a8a93          	addi	s5,s5,713 # ffffffffb21642c9 <base+0xffffffffb21618e1>
     178:	4b59                	li	s6,22
     17a:	00002917          	auipc	s2,0x2
     17e:	88290913          	addi	s2,s2,-1918 # 19fc <ithread_join+0x390>
      close(fd1);
      unlink("c");
    } else if(what == 22){
      // echo hi | cat
      int aa[2], bb[2];
      if(pipe(aa) < 0){
     182:	f6840d93          	addi	s11,s0,-152
     186:	a839                	j	1a4 <go+0xf6>
      close(open("grindir/../a", O_CREATE|O_RDWR));
     188:	20200593          	li	a1,514
     18c:	00001517          	auipc	a0,0x1
     190:	57c50513          	addi	a0,a0,1404 # 1708 <ithread_join+0x9c>
     194:	00001097          	auipc	ra,0x1
     198:	dac080e7          	jalr	-596(ra) # f40 <open>
     19c:	00001097          	auipc	ra,0x1
     1a0:	d8c080e7          	jalr	-628(ra) # f28 <close>
    iters++;
     1a4:	0485                	addi	s1,s1,1
    if((iters % 500) == 0)
     1a6:	0024d793          	srli	a5,s1,0x2
     1aa:	0337b7b3          	mulhu	a5,a5,s3
     1ae:	8391                	srli	a5,a5,0x4
     1b0:	037787b3          	mul	a5,a5,s7
     1b4:	00f49963          	bne	s1,a5,1c6 <go+0x118>
      write(1, which_child?"B":"A", 1);
     1b8:	8652                	mv	a2,s4
     1ba:	85e2                	mv	a1,s8
     1bc:	8552                	mv	a0,s4
     1be:	00001097          	auipc	ra,0x1
     1c2:	d62080e7          	jalr	-670(ra) # f20 <write>
    int what = rand() % 23;
     1c6:	00000097          	auipc	ra,0x0
     1ca:	ec8080e7          	jalr	-312(ra) # 8e <rand>
     1ce:	035507b3          	mul	a5,a0,s5
     1d2:	9381                	srli	a5,a5,0x20
     1d4:	9fa9                	addw	a5,a5,a0
     1d6:	4047d79b          	sraiw	a5,a5,0x4
     1da:	41f5571b          	sraiw	a4,a0,0x1f
     1de:	9f99                	subw	a5,a5,a4
     1e0:	0017971b          	slliw	a4,a5,0x1
     1e4:	9f3d                	addw	a4,a4,a5
     1e6:	0037171b          	slliw	a4,a4,0x3
     1ea:	40f707bb          	subw	a5,a4,a5
     1ee:	9d1d                	subw	a0,a0,a5
     1f0:	faab6ae3          	bltu	s6,a0,1a4 <go+0xf6>
     1f4:	02051793          	slli	a5,a0,0x20
     1f8:	01e7d513          	srli	a0,a5,0x1e
     1fc:	954a                	add	a0,a0,s2
     1fe:	411c                	lw	a5,0(a0)
     200:	97ca                	add	a5,a5,s2
     202:	8782                	jr	a5
      close(open("grindir/../grindir/../b", O_CREATE|O_RDWR));
     204:	20200593          	li	a1,514
     208:	00001517          	auipc	a0,0x1
     20c:	51050513          	addi	a0,a0,1296 # 1718 <ithread_join+0xac>
     210:	00001097          	auipc	ra,0x1
     214:	d30080e7          	jalr	-720(ra) # f40 <open>
     218:	00001097          	auipc	ra,0x1
     21c:	d10080e7          	jalr	-752(ra) # f28 <close>
     220:	b751                	j	1a4 <go+0xf6>
      unlink("grindir/../a");
     222:	00001517          	auipc	a0,0x1
     226:	4e650513          	addi	a0,a0,1254 # 1708 <ithread_join+0x9c>
     22a:	00001097          	auipc	ra,0x1
     22e:	d26080e7          	jalr	-730(ra) # f50 <unlink>
     232:	bf8d                	j	1a4 <go+0xf6>
      if(chdir("grindir") != 0){
     234:	00001517          	auipc	a0,0x1
     238:	48c50513          	addi	a0,a0,1164 # 16c0 <ithread_join+0x54>
     23c:	00001097          	auipc	ra,0x1
     240:	d34080e7          	jalr	-716(ra) # f70 <chdir>
     244:	e115                	bnez	a0,268 <go+0x1ba>
      unlink("../b");
     246:	00001517          	auipc	a0,0x1
     24a:	4ea50513          	addi	a0,a0,1258 # 1730 <ithread_join+0xc4>
     24e:	00001097          	auipc	ra,0x1
     252:	d02080e7          	jalr	-766(ra) # f50 <unlink>
      chdir("/");
     256:	00001517          	auipc	a0,0x1
     25a:	49a50513          	addi	a0,a0,1178 # 16f0 <ithread_join+0x84>
     25e:	00001097          	auipc	ra,0x1
     262:	d12080e7          	jalr	-750(ra) # f70 <chdir>
     266:	bf3d                	j	1a4 <go+0xf6>
        printf("grind: chdir grindir failed\n");
     268:	00001517          	auipc	a0,0x1
     26c:	46050513          	addi	a0,a0,1120 # 16c8 <ithread_join+0x5c>
     270:	00001097          	auipc	ra,0x1
     274:	03e080e7          	jalr	62(ra) # 12ae <printf>
        exit(1);
     278:	4505                	li	a0,1
     27a:	00001097          	auipc	ra,0x1
     27e:	c86080e7          	jalr	-890(ra) # f00 <exit>
      close(fd);
     282:	8566                	mv	a0,s9
     284:	00001097          	auipc	ra,0x1
     288:	ca4080e7          	jalr	-860(ra) # f28 <close>
      fd = open("/grindir/../a", O_CREATE|O_RDWR);
     28c:	20200593          	li	a1,514
     290:	00001517          	auipc	a0,0x1
     294:	4a850513          	addi	a0,a0,1192 # 1738 <ithread_join+0xcc>
     298:	00001097          	auipc	ra,0x1
     29c:	ca8080e7          	jalr	-856(ra) # f40 <open>
     2a0:	8caa                	mv	s9,a0
     2a2:	b709                	j	1a4 <go+0xf6>
      close(fd);
     2a4:	8566                	mv	a0,s9
     2a6:	00001097          	auipc	ra,0x1
     2aa:	c82080e7          	jalr	-894(ra) # f28 <close>
      fd = open("/./grindir/./../b", O_CREATE|O_RDWR);
     2ae:	20200593          	li	a1,514
     2b2:	00001517          	auipc	a0,0x1
     2b6:	49650513          	addi	a0,a0,1174 # 1748 <ithread_join+0xdc>
     2ba:	00001097          	auipc	ra,0x1
     2be:	c86080e7          	jalr	-890(ra) # f40 <open>
     2c2:	8caa                	mv	s9,a0
     2c4:	b5c5                	j	1a4 <go+0xf6>
      write(fd, buf, sizeof(buf));
     2c6:	3e700613          	li	a2,999
     2ca:	00002597          	auipc	a1,0x2
     2ce:	33658593          	addi	a1,a1,822 # 2600 <buf.0>
     2d2:	8566                	mv	a0,s9
     2d4:	00001097          	auipc	ra,0x1
     2d8:	c4c080e7          	jalr	-948(ra) # f20 <write>
     2dc:	b5e1                	j	1a4 <go+0xf6>
      read(fd, buf, sizeof(buf));
     2de:	3e700613          	li	a2,999
     2e2:	00002597          	auipc	a1,0x2
     2e6:	31e58593          	addi	a1,a1,798 # 2600 <buf.0>
     2ea:	8566                	mv	a0,s9
     2ec:	00001097          	auipc	ra,0x1
     2f0:	c2c080e7          	jalr	-980(ra) # f18 <read>
     2f4:	bd45                	j	1a4 <go+0xf6>
      mkdir("grindir/../a");
     2f6:	00001517          	auipc	a0,0x1
     2fa:	41250513          	addi	a0,a0,1042 # 1708 <ithread_join+0x9c>
     2fe:	00001097          	auipc	ra,0x1
     302:	c6a080e7          	jalr	-918(ra) # f68 <mkdir>
      close(open("a/../a/./a", O_CREATE|O_RDWR));
     306:	20200593          	li	a1,514
     30a:	00001517          	auipc	a0,0x1
     30e:	45650513          	addi	a0,a0,1110 # 1760 <ithread_join+0xf4>
     312:	00001097          	auipc	ra,0x1
     316:	c2e080e7          	jalr	-978(ra) # f40 <open>
     31a:	00001097          	auipc	ra,0x1
     31e:	c0e080e7          	jalr	-1010(ra) # f28 <close>
      unlink("a/a");
     322:	00001517          	auipc	a0,0x1
     326:	44e50513          	addi	a0,a0,1102 # 1770 <ithread_join+0x104>
     32a:	00001097          	auipc	ra,0x1
     32e:	c26080e7          	jalr	-986(ra) # f50 <unlink>
     332:	bd8d                	j	1a4 <go+0xf6>
      mkdir("/../b");
     334:	00001517          	auipc	a0,0x1
     338:	44450513          	addi	a0,a0,1092 # 1778 <ithread_join+0x10c>
     33c:	00001097          	auipc	ra,0x1
     340:	c2c080e7          	jalr	-980(ra) # f68 <mkdir>
      close(open("grindir/../b/b", O_CREATE|O_RDWR));
     344:	20200593          	li	a1,514
     348:	00001517          	auipc	a0,0x1
     34c:	43850513          	addi	a0,a0,1080 # 1780 <ithread_join+0x114>
     350:	00001097          	auipc	ra,0x1
     354:	bf0080e7          	jalr	-1040(ra) # f40 <open>
     358:	00001097          	auipc	ra,0x1
     35c:	bd0080e7          	jalr	-1072(ra) # f28 <close>
      unlink("b/b");
     360:	00001517          	auipc	a0,0x1
     364:	43050513          	addi	a0,a0,1072 # 1790 <ithread_join+0x124>
     368:	00001097          	auipc	ra,0x1
     36c:	be8080e7          	jalr	-1048(ra) # f50 <unlink>
     370:	bd15                	j	1a4 <go+0xf6>
      unlink("b");
     372:	00001517          	auipc	a0,0x1
     376:	42650513          	addi	a0,a0,1062 # 1798 <ithread_join+0x12c>
     37a:	00001097          	auipc	ra,0x1
     37e:	bd6080e7          	jalr	-1066(ra) # f50 <unlink>
      link("../grindir/./../a", "../b");
     382:	00001597          	auipc	a1,0x1
     386:	3ae58593          	addi	a1,a1,942 # 1730 <ithread_join+0xc4>
     38a:	00001517          	auipc	a0,0x1
     38e:	41650513          	addi	a0,a0,1046 # 17a0 <ithread_join+0x134>
     392:	00001097          	auipc	ra,0x1
     396:	bce080e7          	jalr	-1074(ra) # f60 <link>
     39a:	b529                	j	1a4 <go+0xf6>
      unlink("../grindir/../a");
     39c:	00001517          	auipc	a0,0x1
     3a0:	41c50513          	addi	a0,a0,1052 # 17b8 <ithread_join+0x14c>
     3a4:	00001097          	auipc	ra,0x1
     3a8:	bac080e7          	jalr	-1108(ra) # f50 <unlink>
      link(".././b", "/grindir/../a");
     3ac:	00001597          	auipc	a1,0x1
     3b0:	38c58593          	addi	a1,a1,908 # 1738 <ithread_join+0xcc>
     3b4:	00001517          	auipc	a0,0x1
     3b8:	41450513          	addi	a0,a0,1044 # 17c8 <ithread_join+0x15c>
     3bc:	00001097          	auipc	ra,0x1
     3c0:	ba4080e7          	jalr	-1116(ra) # f60 <link>
     3c4:	b3c5                	j	1a4 <go+0xf6>
      int pid = fork();
     3c6:	00001097          	auipc	ra,0x1
     3ca:	b32080e7          	jalr	-1230(ra) # ef8 <fork>
      if(pid == 0){
     3ce:	c909                	beqz	a0,3e0 <go+0x332>
      } else if(pid < 0){
     3d0:	00054c63          	bltz	a0,3e8 <go+0x33a>
      wait(0);
     3d4:	4501                	li	a0,0
     3d6:	00001097          	auipc	ra,0x1
     3da:	b32080e7          	jalr	-1230(ra) # f08 <wait>
     3de:	b3d9                	j	1a4 <go+0xf6>
        exit(0);
     3e0:	00001097          	auipc	ra,0x1
     3e4:	b20080e7          	jalr	-1248(ra) # f00 <exit>
        printf("grind: fork failed\n");
     3e8:	00001517          	auipc	a0,0x1
     3ec:	3e850513          	addi	a0,a0,1000 # 17d0 <ithread_join+0x164>
     3f0:	00001097          	auipc	ra,0x1
     3f4:	ebe080e7          	jalr	-322(ra) # 12ae <printf>
        exit(1);
     3f8:	4505                	li	a0,1
     3fa:	00001097          	auipc	ra,0x1
     3fe:	b06080e7          	jalr	-1274(ra) # f00 <exit>
      int pid = fork();
     402:	00001097          	auipc	ra,0x1
     406:	af6080e7          	jalr	-1290(ra) # ef8 <fork>
      if(pid == 0){
     40a:	c909                	beqz	a0,41c <go+0x36e>
      } else if(pid < 0){
     40c:	02054563          	bltz	a0,436 <go+0x388>
      wait(0);
     410:	4501                	li	a0,0
     412:	00001097          	auipc	ra,0x1
     416:	af6080e7          	jalr	-1290(ra) # f08 <wait>
     41a:	b369                	j	1a4 <go+0xf6>
        fork();
     41c:	00001097          	auipc	ra,0x1
     420:	adc080e7          	jalr	-1316(ra) # ef8 <fork>
        fork();
     424:	00001097          	auipc	ra,0x1
     428:	ad4080e7          	jalr	-1324(ra) # ef8 <fork>
        exit(0);
     42c:	4501                	li	a0,0
     42e:	00001097          	auipc	ra,0x1
     432:	ad2080e7          	jalr	-1326(ra) # f00 <exit>
        printf("grind: fork failed\n");
     436:	00001517          	auipc	a0,0x1
     43a:	39a50513          	addi	a0,a0,922 # 17d0 <ithread_join+0x164>
     43e:	00001097          	auipc	ra,0x1
     442:	e70080e7          	jalr	-400(ra) # 12ae <printf>
        exit(1);
     446:	4505                	li	a0,1
     448:	00001097          	auipc	ra,0x1
     44c:	ab8080e7          	jalr	-1352(ra) # f00 <exit>
      sbrk(6011);
     450:	6505                	lui	a0,0x1
     452:	77b50513          	addi	a0,a0,1915 # 177b <ithread_join+0x10f>
     456:	00001097          	auipc	ra,0x1
     45a:	b32080e7          	jalr	-1230(ra) # f88 <sbrk>
     45e:	b399                	j	1a4 <go+0xf6>
      if(sbrk(0) > break0)
     460:	4501                	li	a0,0
     462:	00001097          	auipc	ra,0x1
     466:	b26080e7          	jalr	-1242(ra) # f88 <sbrk>
     46a:	f5843783          	ld	a5,-168(s0)
     46e:	d2a7fbe3          	bgeu	a5,a0,1a4 <go+0xf6>
        sbrk(-(sbrk(0) - break0));
     472:	4501                	li	a0,0
     474:	00001097          	auipc	ra,0x1
     478:	b14080e7          	jalr	-1260(ra) # f88 <sbrk>
     47c:	f5843783          	ld	a5,-168(s0)
     480:	40a7853b          	subw	a0,a5,a0
     484:	00001097          	auipc	ra,0x1
     488:	b04080e7          	jalr	-1276(ra) # f88 <sbrk>
     48c:	bb21                	j	1a4 <go+0xf6>
      int pid = fork();
     48e:	00001097          	auipc	ra,0x1
     492:	a6a080e7          	jalr	-1430(ra) # ef8 <fork>
     496:	8d2a                	mv	s10,a0
      if(pid == 0){
     498:	c51d                	beqz	a0,4c6 <go+0x418>
      } else if(pid < 0){
     49a:	04054963          	bltz	a0,4ec <go+0x43e>
      if(chdir("../grindir/..") != 0){
     49e:	00001517          	auipc	a0,0x1
     4a2:	35250513          	addi	a0,a0,850 # 17f0 <ithread_join+0x184>
     4a6:	00001097          	auipc	ra,0x1
     4aa:	aca080e7          	jalr	-1334(ra) # f70 <chdir>
     4ae:	ed21                	bnez	a0,506 <go+0x458>
      kill(pid);
     4b0:	856a                	mv	a0,s10
     4b2:	00001097          	auipc	ra,0x1
     4b6:	a7e080e7          	jalr	-1410(ra) # f30 <kill>
      wait(0);
     4ba:	4501                	li	a0,0
     4bc:	00001097          	auipc	ra,0x1
     4c0:	a4c080e7          	jalr	-1460(ra) # f08 <wait>
     4c4:	b1c5                	j	1a4 <go+0xf6>
        close(open("a", O_CREATE|O_RDWR));
     4c6:	20200593          	li	a1,514
     4ca:	00001517          	auipc	a0,0x1
     4ce:	31e50513          	addi	a0,a0,798 # 17e8 <ithread_join+0x17c>
     4d2:	00001097          	auipc	ra,0x1
     4d6:	a6e080e7          	jalr	-1426(ra) # f40 <open>
     4da:	00001097          	auipc	ra,0x1
     4de:	a4e080e7          	jalr	-1458(ra) # f28 <close>
        exit(0);
     4e2:	4501                	li	a0,0
     4e4:	00001097          	auipc	ra,0x1
     4e8:	a1c080e7          	jalr	-1508(ra) # f00 <exit>
        printf("grind: fork failed\n");
     4ec:	00001517          	auipc	a0,0x1
     4f0:	2e450513          	addi	a0,a0,740 # 17d0 <ithread_join+0x164>
     4f4:	00001097          	auipc	ra,0x1
     4f8:	dba080e7          	jalr	-582(ra) # 12ae <printf>
        exit(1);
     4fc:	4505                	li	a0,1
     4fe:	00001097          	auipc	ra,0x1
     502:	a02080e7          	jalr	-1534(ra) # f00 <exit>
        printf("grind: chdir failed\n");
     506:	00001517          	auipc	a0,0x1
     50a:	2fa50513          	addi	a0,a0,762 # 1800 <ithread_join+0x194>
     50e:	00001097          	auipc	ra,0x1
     512:	da0080e7          	jalr	-608(ra) # 12ae <printf>
        exit(1);
     516:	4505                	li	a0,1
     518:	00001097          	auipc	ra,0x1
     51c:	9e8080e7          	jalr	-1560(ra) # f00 <exit>
      int pid = fork();
     520:	00001097          	auipc	ra,0x1
     524:	9d8080e7          	jalr	-1576(ra) # ef8 <fork>
      if(pid == 0){
     528:	c909                	beqz	a0,53a <go+0x48c>
      } else if(pid < 0){
     52a:	02054563          	bltz	a0,554 <go+0x4a6>
      wait(0);
     52e:	4501                	li	a0,0
     530:	00001097          	auipc	ra,0x1
     534:	9d8080e7          	jalr	-1576(ra) # f08 <wait>
     538:	b1b5                	j	1a4 <go+0xf6>
        kill(getpid());
     53a:	00001097          	auipc	ra,0x1
     53e:	a46080e7          	jalr	-1466(ra) # f80 <getpid>
     542:	00001097          	auipc	ra,0x1
     546:	9ee080e7          	jalr	-1554(ra) # f30 <kill>
        exit(0);
     54a:	4501                	li	a0,0
     54c:	00001097          	auipc	ra,0x1
     550:	9b4080e7          	jalr	-1612(ra) # f00 <exit>
        printf("grind: fork failed\n");
     554:	00001517          	auipc	a0,0x1
     558:	27c50513          	addi	a0,a0,636 # 17d0 <ithread_join+0x164>
     55c:	00001097          	auipc	ra,0x1
     560:	d52080e7          	jalr	-686(ra) # 12ae <printf>
        exit(1);
     564:	4505                	li	a0,1
     566:	00001097          	auipc	ra,0x1
     56a:	99a080e7          	jalr	-1638(ra) # f00 <exit>
      if(pipe(fds) < 0){
     56e:	f7840513          	addi	a0,s0,-136
     572:	00001097          	auipc	ra,0x1
     576:	99e080e7          	jalr	-1634(ra) # f10 <pipe>
     57a:	02054b63          	bltz	a0,5b0 <go+0x502>
      int pid = fork();
     57e:	00001097          	auipc	ra,0x1
     582:	97a080e7          	jalr	-1670(ra) # ef8 <fork>
      if(pid == 0){
     586:	c131                	beqz	a0,5ca <go+0x51c>
      } else if(pid < 0){
     588:	0a054a63          	bltz	a0,63c <go+0x58e>
      close(fds[0]);
     58c:	f7842503          	lw	a0,-136(s0)
     590:	00001097          	auipc	ra,0x1
     594:	998080e7          	jalr	-1640(ra) # f28 <close>
      close(fds[1]);
     598:	f7c42503          	lw	a0,-132(s0)
     59c:	00001097          	auipc	ra,0x1
     5a0:	98c080e7          	jalr	-1652(ra) # f28 <close>
      wait(0);
     5a4:	4501                	li	a0,0
     5a6:	00001097          	auipc	ra,0x1
     5aa:	962080e7          	jalr	-1694(ra) # f08 <wait>
     5ae:	bedd                	j	1a4 <go+0xf6>
        printf("grind: pipe failed\n");
     5b0:	00001517          	auipc	a0,0x1
     5b4:	26850513          	addi	a0,a0,616 # 1818 <ithread_join+0x1ac>
     5b8:	00001097          	auipc	ra,0x1
     5bc:	cf6080e7          	jalr	-778(ra) # 12ae <printf>
        exit(1);
     5c0:	4505                	li	a0,1
     5c2:	00001097          	auipc	ra,0x1
     5c6:	93e080e7          	jalr	-1730(ra) # f00 <exit>
        fork();
     5ca:	00001097          	auipc	ra,0x1
     5ce:	92e080e7          	jalr	-1746(ra) # ef8 <fork>
        fork();
     5d2:	00001097          	auipc	ra,0x1
     5d6:	926080e7          	jalr	-1754(ra) # ef8 <fork>
        if(write(fds[1], "x", 1) != 1)
     5da:	4605                	li	a2,1
     5dc:	00001597          	auipc	a1,0x1
     5e0:	25458593          	addi	a1,a1,596 # 1830 <ithread_join+0x1c4>
     5e4:	f7c42503          	lw	a0,-132(s0)
     5e8:	00001097          	auipc	ra,0x1
     5ec:	938080e7          	jalr	-1736(ra) # f20 <write>
     5f0:	4785                	li	a5,1
     5f2:	02f51363          	bne	a0,a5,618 <go+0x56a>
        if(read(fds[0], &c, 1) != 1)
     5f6:	4605                	li	a2,1
     5f8:	f7040593          	addi	a1,s0,-144
     5fc:	f7842503          	lw	a0,-136(s0)
     600:	00001097          	auipc	ra,0x1
     604:	918080e7          	jalr	-1768(ra) # f18 <read>
     608:	4785                	li	a5,1
     60a:	02f51063          	bne	a0,a5,62a <go+0x57c>
        exit(0);
     60e:	4501                	li	a0,0
     610:	00001097          	auipc	ra,0x1
     614:	8f0080e7          	jalr	-1808(ra) # f00 <exit>
          printf("grind: pipe write failed\n");
     618:	00001517          	auipc	a0,0x1
     61c:	22050513          	addi	a0,a0,544 # 1838 <ithread_join+0x1cc>
     620:	00001097          	auipc	ra,0x1
     624:	c8e080e7          	jalr	-882(ra) # 12ae <printf>
     628:	b7f9                	j	5f6 <go+0x548>
          printf("grind: pipe read failed\n");
     62a:	00001517          	auipc	a0,0x1
     62e:	22e50513          	addi	a0,a0,558 # 1858 <ithread_join+0x1ec>
     632:	00001097          	auipc	ra,0x1
     636:	c7c080e7          	jalr	-900(ra) # 12ae <printf>
     63a:	bfd1                	j	60e <go+0x560>
        printf("grind: fork failed\n");
     63c:	00001517          	auipc	a0,0x1
     640:	19450513          	addi	a0,a0,404 # 17d0 <ithread_join+0x164>
     644:	00001097          	auipc	ra,0x1
     648:	c6a080e7          	jalr	-918(ra) # 12ae <printf>
        exit(1);
     64c:	4505                	li	a0,1
     64e:	00001097          	auipc	ra,0x1
     652:	8b2080e7          	jalr	-1870(ra) # f00 <exit>
      int pid = fork();
     656:	00001097          	auipc	ra,0x1
     65a:	8a2080e7          	jalr	-1886(ra) # ef8 <fork>
      if(pid == 0){
     65e:	c909                	beqz	a0,670 <go+0x5c2>
      } else if(pid < 0){
     660:	06054f63          	bltz	a0,6de <go+0x630>
      wait(0);
     664:	4501                	li	a0,0
     666:	00001097          	auipc	ra,0x1
     66a:	8a2080e7          	jalr	-1886(ra) # f08 <wait>
     66e:	be1d                	j	1a4 <go+0xf6>
        unlink("a");
     670:	00001517          	auipc	a0,0x1
     674:	17850513          	addi	a0,a0,376 # 17e8 <ithread_join+0x17c>
     678:	00001097          	auipc	ra,0x1
     67c:	8d8080e7          	jalr	-1832(ra) # f50 <unlink>
        mkdir("a");
     680:	00001517          	auipc	a0,0x1
     684:	16850513          	addi	a0,a0,360 # 17e8 <ithread_join+0x17c>
     688:	00001097          	auipc	ra,0x1
     68c:	8e0080e7          	jalr	-1824(ra) # f68 <mkdir>
        chdir("a");
     690:	00001517          	auipc	a0,0x1
     694:	15850513          	addi	a0,a0,344 # 17e8 <ithread_join+0x17c>
     698:	00001097          	auipc	ra,0x1
     69c:	8d8080e7          	jalr	-1832(ra) # f70 <chdir>
        unlink("../a");
     6a0:	00001517          	auipc	a0,0x1
     6a4:	1d850513          	addi	a0,a0,472 # 1878 <ithread_join+0x20c>
     6a8:	00001097          	auipc	ra,0x1
     6ac:	8a8080e7          	jalr	-1880(ra) # f50 <unlink>
        fd = open("x", O_CREATE|O_RDWR);
     6b0:	20200593          	li	a1,514
     6b4:	00001517          	auipc	a0,0x1
     6b8:	17c50513          	addi	a0,a0,380 # 1830 <ithread_join+0x1c4>
     6bc:	00001097          	auipc	ra,0x1
     6c0:	884080e7          	jalr	-1916(ra) # f40 <open>
        unlink("x");
     6c4:	00001517          	auipc	a0,0x1
     6c8:	16c50513          	addi	a0,a0,364 # 1830 <ithread_join+0x1c4>
     6cc:	00001097          	auipc	ra,0x1
     6d0:	884080e7          	jalr	-1916(ra) # f50 <unlink>
        exit(0);
     6d4:	4501                	li	a0,0
     6d6:	00001097          	auipc	ra,0x1
     6da:	82a080e7          	jalr	-2006(ra) # f00 <exit>
        printf("grind: fork failed\n");
     6de:	00001517          	auipc	a0,0x1
     6e2:	0f250513          	addi	a0,a0,242 # 17d0 <ithread_join+0x164>
     6e6:	00001097          	auipc	ra,0x1
     6ea:	bc8080e7          	jalr	-1080(ra) # 12ae <printf>
        exit(1);
     6ee:	4505                	li	a0,1
     6f0:	00001097          	auipc	ra,0x1
     6f4:	810080e7          	jalr	-2032(ra) # f00 <exit>
      unlink("c");
     6f8:	00001517          	auipc	a0,0x1
     6fc:	18850513          	addi	a0,a0,392 # 1880 <ithread_join+0x214>
     700:	00001097          	auipc	ra,0x1
     704:	850080e7          	jalr	-1968(ra) # f50 <unlink>
      int fd1 = open("c", O_CREATE|O_RDWR);
     708:	20200593          	li	a1,514
     70c:	00001517          	auipc	a0,0x1
     710:	17450513          	addi	a0,a0,372 # 1880 <ithread_join+0x214>
     714:	00001097          	auipc	ra,0x1
     718:	82c080e7          	jalr	-2004(ra) # f40 <open>
     71c:	8d2a                	mv	s10,a0
      if(fd1 < 0){
     71e:	04054d63          	bltz	a0,778 <go+0x6ca>
      if(write(fd1, "x", 1) != 1){
     722:	8652                	mv	a2,s4
     724:	00001597          	auipc	a1,0x1
     728:	10c58593          	addi	a1,a1,268 # 1830 <ithread_join+0x1c4>
     72c:	00000097          	auipc	ra,0x0
     730:	7f4080e7          	jalr	2036(ra) # f20 <write>
     734:	05451f63          	bne	a0,s4,792 <go+0x6e4>
      if(fstat(fd1, &st) != 0){
     738:	f7840593          	addi	a1,s0,-136
     73c:	856a                	mv	a0,s10
     73e:	00001097          	auipc	ra,0x1
     742:	81a080e7          	jalr	-2022(ra) # f58 <fstat>
     746:	e13d                	bnez	a0,7ac <go+0x6fe>
      if(st.size != 1){
     748:	f8843583          	ld	a1,-120(s0)
     74c:	07459d63          	bne	a1,s4,7c6 <go+0x718>
      if(st.ino > 200){
     750:	f7c42583          	lw	a1,-132(s0)
     754:	0c800793          	li	a5,200
     758:	08b7e563          	bltu	a5,a1,7e2 <go+0x734>
      close(fd1);
     75c:	856a                	mv	a0,s10
     75e:	00000097          	auipc	ra,0x0
     762:	7ca080e7          	jalr	1994(ra) # f28 <close>
      unlink("c");
     766:	00001517          	auipc	a0,0x1
     76a:	11a50513          	addi	a0,a0,282 # 1880 <ithread_join+0x214>
     76e:	00000097          	auipc	ra,0x0
     772:	7e2080e7          	jalr	2018(ra) # f50 <unlink>
     776:	b43d                	j	1a4 <go+0xf6>
        printf("grind: create c failed\n");
     778:	00001517          	auipc	a0,0x1
     77c:	11050513          	addi	a0,a0,272 # 1888 <ithread_join+0x21c>
     780:	00001097          	auipc	ra,0x1
     784:	b2e080e7          	jalr	-1234(ra) # 12ae <printf>
        exit(1);
     788:	4505                	li	a0,1
     78a:	00000097          	auipc	ra,0x0
     78e:	776080e7          	jalr	1910(ra) # f00 <exit>
        printf("grind: write c failed\n");
     792:	00001517          	auipc	a0,0x1
     796:	10e50513          	addi	a0,a0,270 # 18a0 <ithread_join+0x234>
     79a:	00001097          	auipc	ra,0x1
     79e:	b14080e7          	jalr	-1260(ra) # 12ae <printf>
        exit(1);
     7a2:	4505                	li	a0,1
     7a4:	00000097          	auipc	ra,0x0
     7a8:	75c080e7          	jalr	1884(ra) # f00 <exit>
        printf("grind: fstat failed\n");
     7ac:	00001517          	auipc	a0,0x1
     7b0:	10c50513          	addi	a0,a0,268 # 18b8 <ithread_join+0x24c>
     7b4:	00001097          	auipc	ra,0x1
     7b8:	afa080e7          	jalr	-1286(ra) # 12ae <printf>
        exit(1);
     7bc:	4505                	li	a0,1
     7be:	00000097          	auipc	ra,0x0
     7c2:	742080e7          	jalr	1858(ra) # f00 <exit>
        printf("grind: fstat reports wrong size %d\n", (int)st.size);
     7c6:	2581                	sext.w	a1,a1
     7c8:	00001517          	auipc	a0,0x1
     7cc:	10850513          	addi	a0,a0,264 # 18d0 <ithread_join+0x264>
     7d0:	00001097          	auipc	ra,0x1
     7d4:	ade080e7          	jalr	-1314(ra) # 12ae <printf>
        exit(1);
     7d8:	4505                	li	a0,1
     7da:	00000097          	auipc	ra,0x0
     7de:	726080e7          	jalr	1830(ra) # f00 <exit>
        printf("grind: fstat reports crazy i-number %d\n", st.ino);
     7e2:	00001517          	auipc	a0,0x1
     7e6:	11650513          	addi	a0,a0,278 # 18f8 <ithread_join+0x28c>
     7ea:	00001097          	auipc	ra,0x1
     7ee:	ac4080e7          	jalr	-1340(ra) # 12ae <printf>
        exit(1);
     7f2:	4505                	li	a0,1
     7f4:	00000097          	auipc	ra,0x0
     7f8:	70c080e7          	jalr	1804(ra) # f00 <exit>
      if(pipe(aa) < 0){
     7fc:	856e                	mv	a0,s11
     7fe:	00000097          	auipc	ra,0x0
     802:	712080e7          	jalr	1810(ra) # f10 <pipe>
     806:	10054063          	bltz	a0,906 <go+0x858>
        fprintf(2, "grind: pipe failed\n");
        exit(1);
      }
      if(pipe(bb) < 0){
     80a:	f7040513          	addi	a0,s0,-144
     80e:	00000097          	auipc	ra,0x0
     812:	702080e7          	jalr	1794(ra) # f10 <pipe>
     816:	10054663          	bltz	a0,922 <go+0x874>
        fprintf(2, "grind: pipe failed\n");
        exit(1);
      }
      int pid1 = fork();
     81a:	00000097          	auipc	ra,0x0
     81e:	6de080e7          	jalr	1758(ra) # ef8 <fork>
      if(pid1 == 0){
     822:	10050e63          	beqz	a0,93e <go+0x890>
        close(aa[1]);
        char *args[3] = { "echo", "hi", 0 };
        exec("grindir/../echo", args);
        fprintf(2, "grind: echo: not found\n");
        exit(2);
      } else if(pid1 < 0){
     826:	1c054663          	bltz	a0,9f2 <go+0x944>
        fprintf(2, "grind: fork failed\n");
        exit(3);
      }
      int pid2 = fork();
     82a:	00000097          	auipc	ra,0x0
     82e:	6ce080e7          	jalr	1742(ra) # ef8 <fork>
      if(pid2 == 0){
     832:	1c050e63          	beqz	a0,a0e <go+0x960>
        close(bb[1]);
        char *args[2] = { "cat", 0 };
        exec("/cat", args);
        fprintf(2, "grind: cat: not found\n");
        exit(6);
      } else if(pid2 < 0){
     836:	2a054a63          	bltz	a0,aea <go+0xa3c>
        fprintf(2, "grind: fork failed\n");
        exit(7);
      }
      close(aa[0]);
     83a:	f6842503          	lw	a0,-152(s0)
     83e:	00000097          	auipc	ra,0x0
     842:	6ea080e7          	jalr	1770(ra) # f28 <close>
      close(aa[1]);
     846:	f6c42503          	lw	a0,-148(s0)
     84a:	00000097          	auipc	ra,0x0
     84e:	6de080e7          	jalr	1758(ra) # f28 <close>
      close(bb[1]);
     852:	f7442503          	lw	a0,-140(s0)
     856:	00000097          	auipc	ra,0x0
     85a:	6d2080e7          	jalr	1746(ra) # f28 <close>
      char buf[4] = { 0, 0, 0, 0 };
     85e:	f6042023          	sw	zero,-160(s0)
      read(bb[0], buf+0, 1);
     862:	8652                	mv	a2,s4
     864:	f6040593          	addi	a1,s0,-160
     868:	f7042503          	lw	a0,-144(s0)
     86c:	00000097          	auipc	ra,0x0
     870:	6ac080e7          	jalr	1708(ra) # f18 <read>
      read(bb[0], buf+1, 1);
     874:	8652                	mv	a2,s4
     876:	f6140593          	addi	a1,s0,-159
     87a:	f7042503          	lw	a0,-144(s0)
     87e:	00000097          	auipc	ra,0x0
     882:	69a080e7          	jalr	1690(ra) # f18 <read>
      read(bb[0], buf+2, 1);
     886:	8652                	mv	a2,s4
     888:	f6240593          	addi	a1,s0,-158
     88c:	f7042503          	lw	a0,-144(s0)
     890:	00000097          	auipc	ra,0x0
     894:	688080e7          	jalr	1672(ra) # f18 <read>
      close(bb[0]);
     898:	f7042503          	lw	a0,-144(s0)
     89c:	00000097          	auipc	ra,0x0
     8a0:	68c080e7          	jalr	1676(ra) # f28 <close>
      int st1, st2;
      wait(&st1);
     8a4:	f6440513          	addi	a0,s0,-156
     8a8:	00000097          	auipc	ra,0x0
     8ac:	660080e7          	jalr	1632(ra) # f08 <wait>
      wait(&st2);
     8b0:	f7840513          	addi	a0,s0,-136
     8b4:	00000097          	auipc	ra,0x0
     8b8:	654080e7          	jalr	1620(ra) # f08 <wait>
      if(st1 != 0 || st2 != 0 || strcmp(buf, "hi\n") != 0){
     8bc:	f6442783          	lw	a5,-156(s0)
     8c0:	f7842703          	lw	a4,-136(s0)
     8c4:	8fd9                	or	a5,a5,a4
     8c6:	ef89                	bnez	a5,8e0 <go+0x832>
     8c8:	00001597          	auipc	a1,0x1
     8cc:	0d058593          	addi	a1,a1,208 # 1998 <ithread_join+0x32c>
     8d0:	f6040513          	addi	a0,s0,-160
     8d4:	00000097          	auipc	ra,0x0
     8d8:	3be080e7          	jalr	958(ra) # c92 <strcmp>
     8dc:	8c0504e3          	beqz	a0,1a4 <go+0xf6>
        printf("grind: exec pipeline failed %d %d \"%s\"\n", st1, st2, buf);
     8e0:	f6040693          	addi	a3,s0,-160
     8e4:	f7842603          	lw	a2,-136(s0)
     8e8:	f6442583          	lw	a1,-156(s0)
     8ec:	00001517          	auipc	a0,0x1
     8f0:	0b450513          	addi	a0,a0,180 # 19a0 <ithread_join+0x334>
     8f4:	00001097          	auipc	ra,0x1
     8f8:	9ba080e7          	jalr	-1606(ra) # 12ae <printf>
        exit(1);
     8fc:	4505                	li	a0,1
     8fe:	00000097          	auipc	ra,0x0
     902:	602080e7          	jalr	1538(ra) # f00 <exit>
        fprintf(2, "grind: pipe failed\n");
     906:	00001597          	auipc	a1,0x1
     90a:	f1258593          	addi	a1,a1,-238 # 1818 <ithread_join+0x1ac>
     90e:	4509                	li	a0,2
     910:	00001097          	auipc	ra,0x1
     914:	970080e7          	jalr	-1680(ra) # 1280 <fprintf>
        exit(1);
     918:	4505                	li	a0,1
     91a:	00000097          	auipc	ra,0x0
     91e:	5e6080e7          	jalr	1510(ra) # f00 <exit>
        fprintf(2, "grind: pipe failed\n");
     922:	00001597          	auipc	a1,0x1
     926:	ef658593          	addi	a1,a1,-266 # 1818 <ithread_join+0x1ac>
     92a:	4509                	li	a0,2
     92c:	00001097          	auipc	ra,0x1
     930:	954080e7          	jalr	-1708(ra) # 1280 <fprintf>
        exit(1);
     934:	4505                	li	a0,1
     936:	00000097          	auipc	ra,0x0
     93a:	5ca080e7          	jalr	1482(ra) # f00 <exit>
        close(bb[0]);
     93e:	f7042503          	lw	a0,-144(s0)
     942:	00000097          	auipc	ra,0x0
     946:	5e6080e7          	jalr	1510(ra) # f28 <close>
        close(bb[1]);
     94a:	f7442503          	lw	a0,-140(s0)
     94e:	00000097          	auipc	ra,0x0
     952:	5da080e7          	jalr	1498(ra) # f28 <close>
        close(aa[0]);
     956:	f6842503          	lw	a0,-152(s0)
     95a:	00000097          	auipc	ra,0x0
     95e:	5ce080e7          	jalr	1486(ra) # f28 <close>
        close(1);
     962:	4505                	li	a0,1
     964:	00000097          	auipc	ra,0x0
     968:	5c4080e7          	jalr	1476(ra) # f28 <close>
        if(dup(aa[1]) != 1){
     96c:	f6c42503          	lw	a0,-148(s0)
     970:	00000097          	auipc	ra,0x0
     974:	608080e7          	jalr	1544(ra) # f78 <dup>
     978:	4785                	li	a5,1
     97a:	02f50063          	beq	a0,a5,99a <go+0x8ec>
          fprintf(2, "grind: dup failed\n");
     97e:	00001597          	auipc	a1,0x1
     982:	fa258593          	addi	a1,a1,-94 # 1920 <ithread_join+0x2b4>
     986:	4509                	li	a0,2
     988:	00001097          	auipc	ra,0x1
     98c:	8f8080e7          	jalr	-1800(ra) # 1280 <fprintf>
          exit(1);
     990:	4505                	li	a0,1
     992:	00000097          	auipc	ra,0x0
     996:	56e080e7          	jalr	1390(ra) # f00 <exit>
        close(aa[1]);
     99a:	f6c42503          	lw	a0,-148(s0)
     99e:	00000097          	auipc	ra,0x0
     9a2:	58a080e7          	jalr	1418(ra) # f28 <close>
        char *args[3] = { "echo", "hi", 0 };
     9a6:	00001797          	auipc	a5,0x1
     9aa:	f9278793          	addi	a5,a5,-110 # 1938 <ithread_join+0x2cc>
     9ae:	f6f43c23          	sd	a5,-136(s0)
     9b2:	00001797          	auipc	a5,0x1
     9b6:	f8e78793          	addi	a5,a5,-114 # 1940 <ithread_join+0x2d4>
     9ba:	f8f43023          	sd	a5,-128(s0)
     9be:	f8043423          	sd	zero,-120(s0)
        exec("grindir/../echo", args);
     9c2:	f7840593          	addi	a1,s0,-136
     9c6:	00001517          	auipc	a0,0x1
     9ca:	f8250513          	addi	a0,a0,-126 # 1948 <ithread_join+0x2dc>
     9ce:	00000097          	auipc	ra,0x0
     9d2:	56a080e7          	jalr	1386(ra) # f38 <exec>
        fprintf(2, "grind: echo: not found\n");
     9d6:	00001597          	auipc	a1,0x1
     9da:	f8258593          	addi	a1,a1,-126 # 1958 <ithread_join+0x2ec>
     9de:	4509                	li	a0,2
     9e0:	00001097          	auipc	ra,0x1
     9e4:	8a0080e7          	jalr	-1888(ra) # 1280 <fprintf>
        exit(2);
     9e8:	4509                	li	a0,2
     9ea:	00000097          	auipc	ra,0x0
     9ee:	516080e7          	jalr	1302(ra) # f00 <exit>
        fprintf(2, "grind: fork failed\n");
     9f2:	00001597          	auipc	a1,0x1
     9f6:	dde58593          	addi	a1,a1,-546 # 17d0 <ithread_join+0x164>
     9fa:	4509                	li	a0,2
     9fc:	00001097          	auipc	ra,0x1
     a00:	884080e7          	jalr	-1916(ra) # 1280 <fprintf>
        exit(3);
     a04:	450d                	li	a0,3
     a06:	00000097          	auipc	ra,0x0
     a0a:	4fa080e7          	jalr	1274(ra) # f00 <exit>
        close(aa[1]);
     a0e:	f6c42503          	lw	a0,-148(s0)
     a12:	00000097          	auipc	ra,0x0
     a16:	516080e7          	jalr	1302(ra) # f28 <close>
        close(bb[0]);
     a1a:	f7042503          	lw	a0,-144(s0)
     a1e:	00000097          	auipc	ra,0x0
     a22:	50a080e7          	jalr	1290(ra) # f28 <close>
        close(0);
     a26:	4501                	li	a0,0
     a28:	00000097          	auipc	ra,0x0
     a2c:	500080e7          	jalr	1280(ra) # f28 <close>
        if(dup(aa[0]) != 0){
     a30:	f6842503          	lw	a0,-152(s0)
     a34:	00000097          	auipc	ra,0x0
     a38:	544080e7          	jalr	1348(ra) # f78 <dup>
     a3c:	cd19                	beqz	a0,a5a <go+0x9ac>
          fprintf(2, "grind: dup failed\n");
     a3e:	00001597          	auipc	a1,0x1
     a42:	ee258593          	addi	a1,a1,-286 # 1920 <ithread_join+0x2b4>
     a46:	4509                	li	a0,2
     a48:	00001097          	auipc	ra,0x1
     a4c:	838080e7          	jalr	-1992(ra) # 1280 <fprintf>
          exit(4);
     a50:	4511                	li	a0,4
     a52:	00000097          	auipc	ra,0x0
     a56:	4ae080e7          	jalr	1198(ra) # f00 <exit>
        close(aa[0]);
     a5a:	f6842503          	lw	a0,-152(s0)
     a5e:	00000097          	auipc	ra,0x0
     a62:	4ca080e7          	jalr	1226(ra) # f28 <close>
        close(1);
     a66:	4505                	li	a0,1
     a68:	00000097          	auipc	ra,0x0
     a6c:	4c0080e7          	jalr	1216(ra) # f28 <close>
        if(dup(bb[1]) != 1){
     a70:	f7442503          	lw	a0,-140(s0)
     a74:	00000097          	auipc	ra,0x0
     a78:	504080e7          	jalr	1284(ra) # f78 <dup>
     a7c:	4785                	li	a5,1
     a7e:	02f50063          	beq	a0,a5,a9e <go+0x9f0>
          fprintf(2, "grind: dup failed\n");
     a82:	00001597          	auipc	a1,0x1
     a86:	e9e58593          	addi	a1,a1,-354 # 1920 <ithread_join+0x2b4>
     a8a:	4509                	li	a0,2
     a8c:	00000097          	auipc	ra,0x0
     a90:	7f4080e7          	jalr	2036(ra) # 1280 <fprintf>
          exit(5);
     a94:	4515                	li	a0,5
     a96:	00000097          	auipc	ra,0x0
     a9a:	46a080e7          	jalr	1130(ra) # f00 <exit>
        close(bb[1]);
     a9e:	f7442503          	lw	a0,-140(s0)
     aa2:	00000097          	auipc	ra,0x0
     aa6:	486080e7          	jalr	1158(ra) # f28 <close>
        char *args[2] = { "cat", 0 };
     aaa:	00001797          	auipc	a5,0x1
     aae:	ec678793          	addi	a5,a5,-314 # 1970 <ithread_join+0x304>
     ab2:	f6f43c23          	sd	a5,-136(s0)
     ab6:	f8043023          	sd	zero,-128(s0)
        exec("/cat", args);
     aba:	f7840593          	addi	a1,s0,-136
     abe:	00001517          	auipc	a0,0x1
     ac2:	eba50513          	addi	a0,a0,-326 # 1978 <ithread_join+0x30c>
     ac6:	00000097          	auipc	ra,0x0
     aca:	472080e7          	jalr	1138(ra) # f38 <exec>
        fprintf(2, "grind: cat: not found\n");
     ace:	00001597          	auipc	a1,0x1
     ad2:	eb258593          	addi	a1,a1,-334 # 1980 <ithread_join+0x314>
     ad6:	4509                	li	a0,2
     ad8:	00000097          	auipc	ra,0x0
     adc:	7a8080e7          	jalr	1960(ra) # 1280 <fprintf>
        exit(6);
     ae0:	4519                	li	a0,6
     ae2:	00000097          	auipc	ra,0x0
     ae6:	41e080e7          	jalr	1054(ra) # f00 <exit>
        fprintf(2, "grind: fork failed\n");
     aea:	00001597          	auipc	a1,0x1
     aee:	ce658593          	addi	a1,a1,-794 # 17d0 <ithread_join+0x164>
     af2:	4509                	li	a0,2
     af4:	00000097          	auipc	ra,0x0
     af8:	78c080e7          	jalr	1932(ra) # 1280 <fprintf>
        exit(7);
     afc:	451d                	li	a0,7
     afe:	00000097          	auipc	ra,0x0
     b02:	402080e7          	jalr	1026(ra) # f00 <exit>

0000000000000b06 <iter>:
  }
}

void
iter()
{
     b06:	7179                	addi	sp,sp,-48
     b08:	f406                	sd	ra,40(sp)
     b0a:	f022                	sd	s0,32(sp)
     b0c:	1800                	addi	s0,sp,48
  unlink("a");
     b0e:	00001517          	auipc	a0,0x1
     b12:	cda50513          	addi	a0,a0,-806 # 17e8 <ithread_join+0x17c>
     b16:	00000097          	auipc	ra,0x0
     b1a:	43a080e7          	jalr	1082(ra) # f50 <unlink>
  unlink("b");
     b1e:	00001517          	auipc	a0,0x1
     b22:	c7a50513          	addi	a0,a0,-902 # 1798 <ithread_join+0x12c>
     b26:	00000097          	auipc	ra,0x0
     b2a:	42a080e7          	jalr	1066(ra) # f50 <unlink>
  
  int pid1 = fork();
     b2e:	00000097          	auipc	ra,0x0
     b32:	3ca080e7          	jalr	970(ra) # ef8 <fork>
  if(pid1 < 0){
     b36:	02054363          	bltz	a0,b5c <iter+0x56>
     b3a:	ec26                	sd	s1,24(sp)
     b3c:	84aa                	mv	s1,a0
    printf("grind: fork failed\n");
    exit(1);
  }
  if(pid1 == 0){
     b3e:	ed15                	bnez	a0,b7a <iter+0x74>
     b40:	e84a                	sd	s2,16(sp)
    rand_next ^= 31;
     b42:	00002717          	auipc	a4,0x2
     b46:	a8e70713          	addi	a4,a4,-1394 # 25d0 <rand_next>
     b4a:	631c                	ld	a5,0(a4)
     b4c:	01f7c793          	xori	a5,a5,31
     b50:	e31c                	sd	a5,0(a4)
    go(0);
     b52:	4501                	li	a0,0
     b54:	fffff097          	auipc	ra,0xfffff
     b58:	55a080e7          	jalr	1370(ra) # ae <go>
     b5c:	ec26                	sd	s1,24(sp)
     b5e:	e84a                	sd	s2,16(sp)
    printf("grind: fork failed\n");
     b60:	00001517          	auipc	a0,0x1
     b64:	c7050513          	addi	a0,a0,-912 # 17d0 <ithread_join+0x164>
     b68:	00000097          	auipc	ra,0x0
     b6c:	746080e7          	jalr	1862(ra) # 12ae <printf>
    exit(1);
     b70:	4505                	li	a0,1
     b72:	00000097          	auipc	ra,0x0
     b76:	38e080e7          	jalr	910(ra) # f00 <exit>
     b7a:	e84a                	sd	s2,16(sp)
    exit(0);
  }

  int pid2 = fork();
     b7c:	00000097          	auipc	ra,0x0
     b80:	37c080e7          	jalr	892(ra) # ef8 <fork>
     b84:	892a                	mv	s2,a0
  if(pid2 < 0){
     b86:	02054263          	bltz	a0,baa <iter+0xa4>
    printf("grind: fork failed\n");
    exit(1);
  }
  if(pid2 == 0){
     b8a:	ed0d                	bnez	a0,bc4 <iter+0xbe>
    rand_next ^= 7177;
     b8c:	00002697          	auipc	a3,0x2
     b90:	a4468693          	addi	a3,a3,-1468 # 25d0 <rand_next>
     b94:	629c                	ld	a5,0(a3)
     b96:	6709                	lui	a4,0x2
     b98:	c0970713          	addi	a4,a4,-1015 # 1c09 <digits+0x159>
     b9c:	8fb9                	xor	a5,a5,a4
     b9e:	e29c                	sd	a5,0(a3)
    go(1);
     ba0:	4505                	li	a0,1
     ba2:	fffff097          	auipc	ra,0xfffff
     ba6:	50c080e7          	jalr	1292(ra) # ae <go>
    printf("grind: fork failed\n");
     baa:	00001517          	auipc	a0,0x1
     bae:	c2650513          	addi	a0,a0,-986 # 17d0 <ithread_join+0x164>
     bb2:	00000097          	auipc	ra,0x0
     bb6:	6fc080e7          	jalr	1788(ra) # 12ae <printf>
    exit(1);
     bba:	4505                	li	a0,1
     bbc:	00000097          	auipc	ra,0x0
     bc0:	344080e7          	jalr	836(ra) # f00 <exit>
    exit(0);
  }

  int st1 = -1;
     bc4:	57fd                	li	a5,-1
     bc6:	fcf42e23          	sw	a5,-36(s0)
  wait(&st1);
     bca:	fdc40513          	addi	a0,s0,-36
     bce:	00000097          	auipc	ra,0x0
     bd2:	33a080e7          	jalr	826(ra) # f08 <wait>
  if(st1 != 0){
     bd6:	fdc42783          	lw	a5,-36(s0)
     bda:	ef99                	bnez	a5,bf8 <iter+0xf2>
    kill(pid1);
    kill(pid2);
  }
  int st2 = -1;
     bdc:	57fd                	li	a5,-1
     bde:	fcf42c23          	sw	a5,-40(s0)
  wait(&st2);
     be2:	fd840513          	addi	a0,s0,-40
     be6:	00000097          	auipc	ra,0x0
     bea:	322080e7          	jalr	802(ra) # f08 <wait>

  exit(0);
     bee:	4501                	li	a0,0
     bf0:	00000097          	auipc	ra,0x0
     bf4:	310080e7          	jalr	784(ra) # f00 <exit>
    kill(pid1);
     bf8:	8526                	mv	a0,s1
     bfa:	00000097          	auipc	ra,0x0
     bfe:	336080e7          	jalr	822(ra) # f30 <kill>
    kill(pid2);
     c02:	854a                	mv	a0,s2
     c04:	00000097          	auipc	ra,0x0
     c08:	32c080e7          	jalr	812(ra) # f30 <kill>
     c0c:	bfc1                	j	bdc <iter+0xd6>

0000000000000c0e <main>:
}

int
main()
{
     c0e:	1101                	addi	sp,sp,-32
     c10:	ec06                	sd	ra,24(sp)
     c12:	e822                	sd	s0,16(sp)
     c14:	e426                	sd	s1,8(sp)
     c16:	e04a                	sd	s2,0(sp)
     c18:	1000                	addi	s0,sp,32
      exit(0);
    }
    if(pid > 0){
      wait(0);
    }
    sleep(20);
     c1a:	4951                	li	s2,20
    rand_next += 1;
     c1c:	00002497          	auipc	s1,0x2
     c20:	9b448493          	addi	s1,s1,-1612 # 25d0 <rand_next>
     c24:	a829                	j	c3e <main+0x30>
      iter();
     c26:	00000097          	auipc	ra,0x0
     c2a:	ee0080e7          	jalr	-288(ra) # b06 <iter>
    sleep(20);
     c2e:	854a                	mv	a0,s2
     c30:	00000097          	auipc	ra,0x0
     c34:	360080e7          	jalr	864(ra) # f90 <sleep>
    rand_next += 1;
     c38:	609c                	ld	a5,0(s1)
     c3a:	0785                	addi	a5,a5,1
     c3c:	e09c                	sd	a5,0(s1)
    int pid = fork();
     c3e:	00000097          	auipc	ra,0x0
     c42:	2ba080e7          	jalr	698(ra) # ef8 <fork>
    if(pid == 0){
     c46:	d165                	beqz	a0,c26 <main+0x18>
    if(pid > 0){
     c48:	fea053e3          	blez	a0,c2e <main+0x20>
      wait(0);
     c4c:	4501                	li	a0,0
     c4e:	00000097          	auipc	ra,0x0
     c52:	2ba080e7          	jalr	698(ra) # f08 <wait>
     c56:	bfe1                	j	c2e <main+0x20>

0000000000000c58 <_main>:
//
// wrapper so that it's OK if main() does not call exit().
//
void
_main()
{
     c58:	1141                	addi	sp,sp,-16
     c5a:	e406                	sd	ra,8(sp)
     c5c:	e022                	sd	s0,0(sp)
     c5e:	0800                	addi	s0,sp,16
  extern int main();
  main();
     c60:	00000097          	auipc	ra,0x0
     c64:	fae080e7          	jalr	-82(ra) # c0e <main>
  exit(0);
     c68:	4501                	li	a0,0
     c6a:	00000097          	auipc	ra,0x0
     c6e:	296080e7          	jalr	662(ra) # f00 <exit>

0000000000000c72 <strcpy>:
}

char*
strcpy(char *s, const char *t)
{
     c72:	1141                	addi	sp,sp,-16
     c74:	e406                	sd	ra,8(sp)
     c76:	e022                	sd	s0,0(sp)
     c78:	0800                	addi	s0,sp,16
  char *os;

  os = s;
  while((*s++ = *t++) != 0)
     c7a:	87aa                	mv	a5,a0
     c7c:	0585                	addi	a1,a1,1
     c7e:	0785                	addi	a5,a5,1
     c80:	fff5c703          	lbu	a4,-1(a1)
     c84:	fee78fa3          	sb	a4,-1(a5)
     c88:	fb75                	bnez	a4,c7c <strcpy+0xa>
    ;
  return os;
}
     c8a:	60a2                	ld	ra,8(sp)
     c8c:	6402                	ld	s0,0(sp)
     c8e:	0141                	addi	sp,sp,16
     c90:	8082                	ret

0000000000000c92 <strcmp>:

int
strcmp(const char *p, const char *q)
{
     c92:	1141                	addi	sp,sp,-16
     c94:	e406                	sd	ra,8(sp)
     c96:	e022                	sd	s0,0(sp)
     c98:	0800                	addi	s0,sp,16
  while(*p && *p == *q)
     c9a:	00054783          	lbu	a5,0(a0)
     c9e:	cb91                	beqz	a5,cb2 <strcmp+0x20>
     ca0:	0005c703          	lbu	a4,0(a1)
     ca4:	00f71763          	bne	a4,a5,cb2 <strcmp+0x20>
    p++, q++;
     ca8:	0505                	addi	a0,a0,1
     caa:	0585                	addi	a1,a1,1
  while(*p && *p == *q)
     cac:	00054783          	lbu	a5,0(a0)
     cb0:	fbe5                	bnez	a5,ca0 <strcmp+0xe>
  return (uchar)*p - (uchar)*q;
     cb2:	0005c503          	lbu	a0,0(a1)
}
     cb6:	40a7853b          	subw	a0,a5,a0
     cba:	60a2                	ld	ra,8(sp)
     cbc:	6402                	ld	s0,0(sp)
     cbe:	0141                	addi	sp,sp,16
     cc0:	8082                	ret

0000000000000cc2 <strlen>:

uint
strlen(const char *s)
{
     cc2:	1141                	addi	sp,sp,-16
     cc4:	e406                	sd	ra,8(sp)
     cc6:	e022                	sd	s0,0(sp)
     cc8:	0800                	addi	s0,sp,16
  int n;

  for(n = 0; s[n]; n++)
     cca:	00054783          	lbu	a5,0(a0)
     cce:	cf91                	beqz	a5,cea <strlen+0x28>
     cd0:	00150793          	addi	a5,a0,1
     cd4:	86be                	mv	a3,a5
     cd6:	0785                	addi	a5,a5,1
     cd8:	fff7c703          	lbu	a4,-1(a5)
     cdc:	ff65                	bnez	a4,cd4 <strlen+0x12>
     cde:	40a6853b          	subw	a0,a3,a0
    ;
  return n;
}
     ce2:	60a2                	ld	ra,8(sp)
     ce4:	6402                	ld	s0,0(sp)
     ce6:	0141                	addi	sp,sp,16
     ce8:	8082                	ret
  for(n = 0; s[n]; n++)
     cea:	4501                	li	a0,0
     cec:	bfdd                	j	ce2 <strlen+0x20>

0000000000000cee <memset>:

void*
memset(void *dst, int c, uint n)
{
     cee:	1141                	addi	sp,sp,-16
     cf0:	e406                	sd	ra,8(sp)
     cf2:	e022                	sd	s0,0(sp)
     cf4:	0800                	addi	s0,sp,16
  char *cdst = (char *) dst;
  int i;
  for(i = 0; i < n; i++){
     cf6:	ca19                	beqz	a2,d0c <memset+0x1e>
     cf8:	87aa                	mv	a5,a0
     cfa:	1602                	slli	a2,a2,0x20
     cfc:	9201                	srli	a2,a2,0x20
     cfe:	00a60733          	add	a4,a2,a0
    cdst[i] = c;
     d02:	00b78023          	sb	a1,0(a5)
  for(i = 0; i < n; i++){
     d06:	0785                	addi	a5,a5,1
     d08:	fee79de3          	bne	a5,a4,d02 <memset+0x14>
  }
  return dst;
}
     d0c:	60a2                	ld	ra,8(sp)
     d0e:	6402                	ld	s0,0(sp)
     d10:	0141                	addi	sp,sp,16
     d12:	8082                	ret

0000000000000d14 <strchr>:

char*
strchr(const char *s, char c)
{
     d14:	1141                	addi	sp,sp,-16
     d16:	e406                	sd	ra,8(sp)
     d18:	e022                	sd	s0,0(sp)
     d1a:	0800                	addi	s0,sp,16
  for(; *s; s++)
     d1c:	00054783          	lbu	a5,0(a0)
     d20:	cf81                	beqz	a5,d38 <strchr+0x24>
    if(*s == c)
     d22:	00f58763          	beq	a1,a5,d30 <strchr+0x1c>
  for(; *s; s++)
     d26:	0505                	addi	a0,a0,1
     d28:	00054783          	lbu	a5,0(a0)
     d2c:	fbfd                	bnez	a5,d22 <strchr+0xe>
      return (char*)s;
  return 0;
     d2e:	4501                	li	a0,0
}
     d30:	60a2                	ld	ra,8(sp)
     d32:	6402                	ld	s0,0(sp)
     d34:	0141                	addi	sp,sp,16
     d36:	8082                	ret
  return 0;
     d38:	4501                	li	a0,0
     d3a:	bfdd                	j	d30 <strchr+0x1c>

0000000000000d3c <gets>:

char*
gets(char *buf, int max)
{
     d3c:	711d                	addi	sp,sp,-96
     d3e:	ec86                	sd	ra,88(sp)
     d40:	e8a2                	sd	s0,80(sp)
     d42:	e4a6                	sd	s1,72(sp)
     d44:	e0ca                	sd	s2,64(sp)
     d46:	fc4e                	sd	s3,56(sp)
     d48:	f852                	sd	s4,48(sp)
     d4a:	f456                	sd	s5,40(sp)
     d4c:	f05a                	sd	s6,32(sp)
     d4e:	ec5e                	sd	s7,24(sp)
     d50:	e862                	sd	s8,16(sp)
     d52:	1080                	addi	s0,sp,96
     d54:	8baa                	mv	s7,a0
     d56:	8a2e                	mv	s4,a1
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
     d58:	892a                	mv	s2,a0
     d5a:	4481                	li	s1,0
    cc = read(0, &c, 1);
     d5c:	faf40b13          	addi	s6,s0,-81
     d60:	4a85                	li	s5,1
  for(i=0; i+1 < max; ){
     d62:	8c26                	mv	s8,s1
     d64:	0014899b          	addiw	s3,s1,1
     d68:	84ce                	mv	s1,s3
     d6a:	0349d663          	bge	s3,s4,d96 <gets+0x5a>
    cc = read(0, &c, 1);
     d6e:	8656                	mv	a2,s5
     d70:	85da                	mv	a1,s6
     d72:	4501                	li	a0,0
     d74:	00000097          	auipc	ra,0x0
     d78:	1a4080e7          	jalr	420(ra) # f18 <read>
    if(cc < 1)
     d7c:	00a05d63          	blez	a0,d96 <gets+0x5a>
      break;
    buf[i++] = c;
     d80:	faf44783          	lbu	a5,-81(s0)
     d84:	00f90023          	sb	a5,0(s2)
    if(c == '\n' || c == '\r')
     d88:	0905                	addi	s2,s2,1
     d8a:	ff678713          	addi	a4,a5,-10
     d8e:	c319                	beqz	a4,d94 <gets+0x58>
     d90:	17cd                	addi	a5,a5,-13
     d92:	fbe1                	bnez	a5,d62 <gets+0x26>
    buf[i++] = c;
     d94:	8c4e                	mv	s8,s3
      break;
  }
  buf[i] = '\0';
     d96:	9c5e                	add	s8,s8,s7
     d98:	000c0023          	sb	zero,0(s8)
  return buf;
}
     d9c:	855e                	mv	a0,s7
     d9e:	60e6                	ld	ra,88(sp)
     da0:	6446                	ld	s0,80(sp)
     da2:	64a6                	ld	s1,72(sp)
     da4:	6906                	ld	s2,64(sp)
     da6:	79e2                	ld	s3,56(sp)
     da8:	7a42                	ld	s4,48(sp)
     daa:	7aa2                	ld	s5,40(sp)
     dac:	7b02                	ld	s6,32(sp)
     dae:	6be2                	ld	s7,24(sp)
     db0:	6c42                	ld	s8,16(sp)
     db2:	6125                	addi	sp,sp,96
     db4:	8082                	ret

0000000000000db6 <stat>:

int
stat(const char *n, struct stat *st)
{
     db6:	1101                	addi	sp,sp,-32
     db8:	ec06                	sd	ra,24(sp)
     dba:	e822                	sd	s0,16(sp)
     dbc:	e04a                	sd	s2,0(sp)
     dbe:	1000                	addi	s0,sp,32
     dc0:	892e                	mv	s2,a1
  int fd;
  int r;

  fd = open(n, O_RDONLY);
     dc2:	4581                	li	a1,0
     dc4:	00000097          	auipc	ra,0x0
     dc8:	17c080e7          	jalr	380(ra) # f40 <open>
  if(fd < 0)
     dcc:	02054663          	bltz	a0,df8 <stat+0x42>
     dd0:	e426                	sd	s1,8(sp)
     dd2:	84aa                	mv	s1,a0
    return -1;
  r = fstat(fd, st);
     dd4:	85ca                	mv	a1,s2
     dd6:	00000097          	auipc	ra,0x0
     dda:	182080e7          	jalr	386(ra) # f58 <fstat>
     dde:	892a                	mv	s2,a0
  close(fd);
     de0:	8526                	mv	a0,s1
     de2:	00000097          	auipc	ra,0x0
     de6:	146080e7          	jalr	326(ra) # f28 <close>
  return r;
     dea:	64a2                	ld	s1,8(sp)
}
     dec:	854a                	mv	a0,s2
     dee:	60e2                	ld	ra,24(sp)
     df0:	6442                	ld	s0,16(sp)
     df2:	6902                	ld	s2,0(sp)
     df4:	6105                	addi	sp,sp,32
     df6:	8082                	ret
    return -1;
     df8:	57fd                	li	a5,-1
     dfa:	893e                	mv	s2,a5
     dfc:	bfc5                	j	dec <stat+0x36>

0000000000000dfe <atoi>:

int
atoi(const char *s)
{
     dfe:	1141                	addi	sp,sp,-16
     e00:	e406                	sd	ra,8(sp)
     e02:	e022                	sd	s0,0(sp)
     e04:	0800                	addi	s0,sp,16
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
     e06:	00054683          	lbu	a3,0(a0)
     e0a:	fd06879b          	addiw	a5,a3,-48
     e0e:	0ff7f793          	zext.b	a5,a5
     e12:	4625                	li	a2,9
     e14:	02f66963          	bltu	a2,a5,e46 <atoi+0x48>
     e18:	872a                	mv	a4,a0
  n = 0;
     e1a:	4501                	li	a0,0
    n = n*10 + *s++ - '0';
     e1c:	0705                	addi	a4,a4,1
     e1e:	0025179b          	slliw	a5,a0,0x2
     e22:	9fa9                	addw	a5,a5,a0
     e24:	0017979b          	slliw	a5,a5,0x1
     e28:	9fb5                	addw	a5,a5,a3
     e2a:	fd07851b          	addiw	a0,a5,-48
  while('0' <= *s && *s <= '9')
     e2e:	00074683          	lbu	a3,0(a4)
     e32:	fd06879b          	addiw	a5,a3,-48
     e36:	0ff7f793          	zext.b	a5,a5
     e3a:	fef671e3          	bgeu	a2,a5,e1c <atoi+0x1e>
  return n;
}
     e3e:	60a2                	ld	ra,8(sp)
     e40:	6402                	ld	s0,0(sp)
     e42:	0141                	addi	sp,sp,16
     e44:	8082                	ret
  n = 0;
     e46:	4501                	li	a0,0
     e48:	bfdd                	j	e3e <atoi+0x40>

0000000000000e4a <memmove>:

void*
memmove(void *vdst, const void *vsrc, int n)
{
     e4a:	1141                	addi	sp,sp,-16
     e4c:	e406                	sd	ra,8(sp)
     e4e:	e022                	sd	s0,0(sp)
     e50:	0800                	addi	s0,sp,16
  char *dst;
  const char *src;

  dst = vdst;
  src = vsrc;
  if (src > dst) {
     e52:	02b57563          	bgeu	a0,a1,e7c <memmove+0x32>
    while(n-- > 0)
     e56:	00c05f63          	blez	a2,e74 <memmove+0x2a>
     e5a:	1602                	slli	a2,a2,0x20
     e5c:	9201                	srli	a2,a2,0x20
     e5e:	00c507b3          	add	a5,a0,a2
  dst = vdst;
     e62:	872a                	mv	a4,a0
      *dst++ = *src++;
     e64:	0585                	addi	a1,a1,1
     e66:	0705                	addi	a4,a4,1
     e68:	fff5c683          	lbu	a3,-1(a1)
     e6c:	fed70fa3          	sb	a3,-1(a4)
    while(n-- > 0)
     e70:	fee79ae3          	bne	a5,a4,e64 <memmove+0x1a>
    src += n;
    while(n-- > 0)
      *--dst = *--src;
  }
  return vdst;
}
     e74:	60a2                	ld	ra,8(sp)
     e76:	6402                	ld	s0,0(sp)
     e78:	0141                	addi	sp,sp,16
     e7a:	8082                	ret
    while(n-- > 0)
     e7c:	fec05ce3          	blez	a2,e74 <memmove+0x2a>
    dst += n;
     e80:	00c50733          	add	a4,a0,a2
    src += n;
     e84:	95b2                	add	a1,a1,a2
     e86:	fff6079b          	addiw	a5,a2,-1
     e8a:	1782                	slli	a5,a5,0x20
     e8c:	9381                	srli	a5,a5,0x20
     e8e:	fff7c793          	not	a5,a5
     e92:	97ba                	add	a5,a5,a4
      *--dst = *--src;
     e94:	15fd                	addi	a1,a1,-1
     e96:	177d                	addi	a4,a4,-1
     e98:	0005c683          	lbu	a3,0(a1)
     e9c:	00d70023          	sb	a3,0(a4)
    while(n-- > 0)
     ea0:	fef71ae3          	bne	a4,a5,e94 <memmove+0x4a>
     ea4:	bfc1                	j	e74 <memmove+0x2a>

0000000000000ea6 <memcmp>:

int
memcmp(const void *s1, const void *s2, uint n)
{
     ea6:	1141                	addi	sp,sp,-16
     ea8:	e406                	sd	ra,8(sp)
     eaa:	e022                	sd	s0,0(sp)
     eac:	0800                	addi	s0,sp,16
  const char *p1 = s1, *p2 = s2;
  while (n-- > 0) {
     eae:	c61d                	beqz	a2,edc <memcmp+0x36>
     eb0:	1602                	slli	a2,a2,0x20
     eb2:	9201                	srli	a2,a2,0x20
     eb4:	00c506b3          	add	a3,a0,a2
    if (*p1 != *p2) {
     eb8:	00054783          	lbu	a5,0(a0)
     ebc:	0005c703          	lbu	a4,0(a1)
     ec0:	00e79863          	bne	a5,a4,ed0 <memcmp+0x2a>
      return *p1 - *p2;
    }
    p1++;
     ec4:	0505                	addi	a0,a0,1
    p2++;
     ec6:	0585                	addi	a1,a1,1
  while (n-- > 0) {
     ec8:	fed518e3          	bne	a0,a3,eb8 <memcmp+0x12>
  }
  return 0;
     ecc:	4501                	li	a0,0
     ece:	a019                	j	ed4 <memcmp+0x2e>
      return *p1 - *p2;
     ed0:	40e7853b          	subw	a0,a5,a4
}
     ed4:	60a2                	ld	ra,8(sp)
     ed6:	6402                	ld	s0,0(sp)
     ed8:	0141                	addi	sp,sp,16
     eda:	8082                	ret
  return 0;
     edc:	4501                	li	a0,0
     ede:	bfdd                	j	ed4 <memcmp+0x2e>

0000000000000ee0 <memcpy>:

void *
memcpy(void *dst, const void *src, uint n)
{
     ee0:	1141                	addi	sp,sp,-16
     ee2:	e406                	sd	ra,8(sp)
     ee4:	e022                	sd	s0,0(sp)
     ee6:	0800                	addi	s0,sp,16
  return memmove(dst, src, n);
     ee8:	00000097          	auipc	ra,0x0
     eec:	f62080e7          	jalr	-158(ra) # e4a <memmove>
}
     ef0:	60a2                	ld	ra,8(sp)
     ef2:	6402                	ld	s0,0(sp)
     ef4:	0141                	addi	sp,sp,16
     ef6:	8082                	ret

0000000000000ef8 <fork>:
# generated by usys.pl - do not edit
#include "kernel/syscall.h"
.global fork
fork:
 li a7, SYS_fork
     ef8:	4885                	li	a7,1
 ecall
     efa:	00000073          	ecall
 ret
     efe:	8082                	ret

0000000000000f00 <exit>:
.global exit
exit:
 li a7, SYS_exit
     f00:	4889                	li	a7,2
 ecall
     f02:	00000073          	ecall
 ret
     f06:	8082                	ret

0000000000000f08 <wait>:
.global wait
wait:
 li a7, SYS_wait
     f08:	488d                	li	a7,3
 ecall
     f0a:	00000073          	ecall
 ret
     f0e:	8082                	ret

0000000000000f10 <pipe>:
.global pipe
pipe:
 li a7, SYS_pipe
     f10:	4891                	li	a7,4
 ecall
     f12:	00000073          	ecall
 ret
     f16:	8082                	ret

0000000000000f18 <read>:
.global read
read:
 li a7, SYS_read
     f18:	4895                	li	a7,5
 ecall
     f1a:	00000073          	ecall
 ret
     f1e:	8082                	ret

0000000000000f20 <write>:
.global write
write:
 li a7, SYS_write
     f20:	48c1                	li	a7,16
 ecall
     f22:	00000073          	ecall
 ret
     f26:	8082                	ret

0000000000000f28 <close>:
.global close
close:
 li a7, SYS_close
     f28:	48d5                	li	a7,21
 ecall
     f2a:	00000073          	ecall
 ret
     f2e:	8082                	ret

0000000000000f30 <kill>:
.global kill
kill:
 li a7, SYS_kill
     f30:	4899                	li	a7,6
 ecall
     f32:	00000073          	ecall
 ret
     f36:	8082                	ret

0000000000000f38 <exec>:
.global exec
exec:
 li a7, SYS_exec
     f38:	489d                	li	a7,7
 ecall
     f3a:	00000073          	ecall
 ret
     f3e:	8082                	ret

0000000000000f40 <open>:
.global open
open:
 li a7, SYS_open
     f40:	48bd                	li	a7,15
 ecall
     f42:	00000073          	ecall
 ret
     f46:	8082                	ret

0000000000000f48 <mknod>:
.global mknod
mknod:
 li a7, SYS_mknod
     f48:	48c5                	li	a7,17
 ecall
     f4a:	00000073          	ecall
 ret
     f4e:	8082                	ret

0000000000000f50 <unlink>:
.global unlink
unlink:
 li a7, SYS_unlink
     f50:	48c9                	li	a7,18
 ecall
     f52:	00000073          	ecall
 ret
     f56:	8082                	ret

0000000000000f58 <fstat>:
.global fstat
fstat:
 li a7, SYS_fstat
     f58:	48a1                	li	a7,8
 ecall
     f5a:	00000073          	ecall
 ret
     f5e:	8082                	ret

0000000000000f60 <link>:
.global link
link:
 li a7, SYS_link
     f60:	48cd                	li	a7,19
 ecall
     f62:	00000073          	ecall
 ret
     f66:	8082                	ret

0000000000000f68 <mkdir>:
.global mkdir
mkdir:
 li a7, SYS_mkdir
     f68:	48d1                	li	a7,20
 ecall
     f6a:	00000073          	ecall
 ret
     f6e:	8082                	ret

0000000000000f70 <chdir>:
.global chdir
chdir:
 li a7, SYS_chdir
     f70:	48a5                	li	a7,9
 ecall
     f72:	00000073          	ecall
 ret
     f76:	8082                	ret

0000000000000f78 <dup>:
.global dup
dup:
 li a7, SYS_dup
     f78:	48a9                	li	a7,10
 ecall
     f7a:	00000073          	ecall
 ret
     f7e:	8082                	ret

0000000000000f80 <getpid>:
.global getpid
getpid:
 li a7, SYS_getpid
     f80:	48ad                	li	a7,11
 ecall
     f82:	00000073          	ecall
 ret
     f86:	8082                	ret

0000000000000f88 <sbrk>:
.global sbrk
sbrk:
 li a7, SYS_sbrk
     f88:	48b1                	li	a7,12
 ecall
     f8a:	00000073          	ecall
 ret
     f8e:	8082                	ret

0000000000000f90 <sleep>:
.global sleep
sleep:
 li a7, SYS_sleep
     f90:	48b5                	li	a7,13
 ecall
     f92:	00000073          	ecall
 ret
     f96:	8082                	ret

0000000000000f98 <uptime>:
.global uptime
uptime:
 li a7, SYS_uptime
     f98:	48b9                	li	a7,14
 ecall
     f9a:	00000073          	ecall
 ret
     f9e:	8082                	ret

0000000000000fa0 <spoon>:
.global spoon
spoon:
 li a7, SYS_spoon
     fa0:	48d9                	li	a7,22
 ecall
     fa2:	00000073          	ecall
 ret
     fa6:	8082                	ret

0000000000000fa8 <create_thread>:
.global create_thread
create_thread:
 li a7, SYS_create_thread
     fa8:	48dd                	li	a7,23
 ecall
     faa:	00000073          	ecall
 ret
     fae:	8082                	ret

0000000000000fb0 <join_thread>:
.global join_thread
join_thread:
 li a7, SYS_join_thread
     fb0:	48e1                	li	a7,24
 ecall
     fb2:	00000073          	ecall
 ret
     fb6:	8082                	ret

0000000000000fb8 <thread_exit>:
.global thread_exit
thread_exit:
 li a7, SYS_thread_exit
     fb8:	48e5                	li	a7,25
 ecall
     fba:	00000073          	ecall
 ret
     fbe:	8082                	ret

0000000000000fc0 <socket>:
.global socket
socket:
 li a7, SYS_socket
     fc0:	48e9                	li	a7,26
 ecall
     fc2:	00000073          	ecall
 ret
     fc6:	8082                	ret

0000000000000fc8 <bind>:
.global bind
bind:
 li a7, SYS_bind
     fc8:	48ed                	li	a7,27
 ecall
     fca:	00000073          	ecall
 ret
     fce:	8082                	ret

0000000000000fd0 <accept>:
.global accept
accept:
 li a7, SYS_accept
     fd0:	48f5                	li	a7,29
 ecall
     fd2:	00000073          	ecall
 ret
     fd6:	8082                	ret

0000000000000fd8 <listen>:
.global listen
listen:
 li a7, SYS_listen
     fd8:	48f1                	li	a7,28
 ecall
     fda:	00000073          	ecall
 ret
     fde:	8082                	ret

0000000000000fe0 <connect>:
.global connect
connect:
 li a7, SYS_connect
     fe0:	48f9                	li	a7,30
 ecall
     fe2:	00000073          	ecall
 ret
     fe6:	8082                	ret

0000000000000fe8 <putc>:

static char digits[] = "0123456789ABCDEF";

static void
putc(int fd, char c)
{
     fe8:	1101                	addi	sp,sp,-32
     fea:	ec06                	sd	ra,24(sp)
     fec:	e822                	sd	s0,16(sp)
     fee:	1000                	addi	s0,sp,32
     ff0:	feb407a3          	sb	a1,-17(s0)
  write(fd, &c, 1);
     ff4:	4605                	li	a2,1
     ff6:	fef40593          	addi	a1,s0,-17
     ffa:	00000097          	auipc	ra,0x0
     ffe:	f26080e7          	jalr	-218(ra) # f20 <write>
}
    1002:	60e2                	ld	ra,24(sp)
    1004:	6442                	ld	s0,16(sp)
    1006:	6105                	addi	sp,sp,32
    1008:	8082                	ret

000000000000100a <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
    100a:	7139                	addi	sp,sp,-64
    100c:	fc06                	sd	ra,56(sp)
    100e:	f822                	sd	s0,48(sp)
    1010:	f04a                	sd	s2,32(sp)
    1012:	ec4e                	sd	s3,24(sp)
    1014:	0080                	addi	s0,sp,64
    1016:	892a                	mv	s2,a0
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
  if(sgn && xx < 0){
    1018:	cad9                	beqz	a3,10ae <printint+0xa4>
    101a:	01f5d79b          	srliw	a5,a1,0x1f
    101e:	cbc1                	beqz	a5,10ae <printint+0xa4>
    neg = 1;
    x = -xx;
    1020:	40b005bb          	negw	a1,a1
    neg = 1;
    1024:	4305                	li	t1,1
  } else {
    x = xx;
  }

  i = 0;
    1026:	fc040993          	addi	s3,s0,-64
  neg = 0;
    102a:	86ce                	mv	a3,s3
  i = 0;
    102c:	4701                	li	a4,0
  do{
    buf[i++] = digits[x % base];
    102e:	00001817          	auipc	a6,0x1
    1032:	a8280813          	addi	a6,a6,-1406 # 1ab0 <digits>
    1036:	88ba                	mv	a7,a4
    1038:	0017051b          	addiw	a0,a4,1
    103c:	872a                	mv	a4,a0
    103e:	02c5f7bb          	remuw	a5,a1,a2
    1042:	1782                	slli	a5,a5,0x20
    1044:	9381                	srli	a5,a5,0x20
    1046:	97c2                	add	a5,a5,a6
    1048:	0007c783          	lbu	a5,0(a5)
    104c:	00f68023          	sb	a5,0(a3)
  }while((x /= base) != 0);
    1050:	87ae                	mv	a5,a1
    1052:	02c5d5bb          	divuw	a1,a1,a2
    1056:	0685                	addi	a3,a3,1
    1058:	fcc7ffe3          	bgeu	a5,a2,1036 <printint+0x2c>
  if(neg)
    105c:	00030c63          	beqz	t1,1074 <printint+0x6a>
    buf[i++] = '-';
    1060:	fd050793          	addi	a5,a0,-48
    1064:	00878533          	add	a0,a5,s0
    1068:	02d00793          	li	a5,45
    106c:	fef50823          	sb	a5,-16(a0)
    1070:	0028871b          	addiw	a4,a7,2

  while(--i >= 0)
    1074:	02e05763          	blez	a4,10a2 <printint+0x98>
    1078:	f426                	sd	s1,40(sp)
    107a:	377d                	addiw	a4,a4,-1
    107c:	00e984b3          	add	s1,s3,a4
    1080:	19fd                	addi	s3,s3,-1
    1082:	99ba                	add	s3,s3,a4
    1084:	1702                	slli	a4,a4,0x20
    1086:	9301                	srli	a4,a4,0x20
    1088:	40e989b3          	sub	s3,s3,a4
    putc(fd, buf[i]);
    108c:	0004c583          	lbu	a1,0(s1)
    1090:	854a                	mv	a0,s2
    1092:	00000097          	auipc	ra,0x0
    1096:	f56080e7          	jalr	-170(ra) # fe8 <putc>
  while(--i >= 0)
    109a:	14fd                	addi	s1,s1,-1
    109c:	ff3498e3          	bne	s1,s3,108c <printint+0x82>
    10a0:	74a2                	ld	s1,40(sp)
}
    10a2:	70e2                	ld	ra,56(sp)
    10a4:	7442                	ld	s0,48(sp)
    10a6:	7902                	ld	s2,32(sp)
    10a8:	69e2                	ld	s3,24(sp)
    10aa:	6121                	addi	sp,sp,64
    10ac:	8082                	ret
  neg = 0;
    10ae:	4301                	li	t1,0
    10b0:	bf9d                	j	1026 <printint+0x1c>

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
    10c0:	1a090b63          	beqz	s2,1276 <vprintf+0x1c4>
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
    10ea:	f02080e7          	jalr	-254(ra) # fe8 <putc>
    10ee:	a019                	j	10f4 <vprintf+0x42>
    } else if(state == '%'){
    10f0:	01498d63          	beq	s3,s4,110a <vprintf+0x58>
  for(i = 0; fmt[i]; i++){
    10f4:	0485                	addi	s1,s1,1
    10f6:	fff4c903          	lbu	s2,-1(s1)
    10fa:	16090863          	beqz	s2,126a <vprintf+0x1b8>
    if(state == 0){
    10fe:	fe0999e3          	bnez	s3,10f0 <vprintf+0x3e>
      if(c == '%'){
    1102:	ff4910e3          	bne	s2,s4,10e2 <vprintf+0x30>
        state = '%';
    1106:	89d2                	mv	s3,s4
    1108:	b7f5                	j	10f4 <vprintf+0x42>
      if(c == 'd'){
    110a:	13490563          	beq	s2,s4,1234 <vprintf+0x182>
    110e:	f9d9079b          	addiw	a5,s2,-99
    1112:	0ff7f793          	zext.b	a5,a5
    1116:	12fb6863          	bltu	s6,a5,1246 <vprintf+0x194>
    111a:	f9d9079b          	addiw	a5,s2,-99
    111e:	0ff7f713          	zext.b	a4,a5
    1122:	12eb6263          	bltu	s6,a4,1246 <vprintf+0x194>
    1126:	00271793          	slli	a5,a4,0x2
    112a:	00001717          	auipc	a4,0x1
    112e:	92e70713          	addi	a4,a4,-1746 # 1a58 <ithread_join+0x3ec>
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
    114c:	ec2080e7          	jalr	-318(ra) # 100a <printint>
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
    1168:	ea6080e7          	jalr	-346(ra) # 100a <printint>
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
    1184:	e8a080e7          	jalr	-374(ra) # 100a <printint>
    1188:	8bca                	mv	s7,s2
      state = 0;
    118a:	4981                	li	s3,0
    118c:	b7a5                	j	10f4 <vprintf+0x42>
    118e:	e062                	sd	s8,0(sp)
        printptr(fd, va_arg(ap, uint64));
    1190:	008b8793          	addi	a5,s7,8
    1194:	8c3e                	mv	s8,a5
    1196:	000bb983          	ld	s3,0(s7)
  putc(fd, '0');
    119a:	03000593          	li	a1,48
    119e:	8556                	mv	a0,s5
    11a0:	00000097          	auipc	ra,0x0
    11a4:	e48080e7          	jalr	-440(ra) # fe8 <putc>
  putc(fd, 'x');
    11a8:	07800593          	li	a1,120
    11ac:	8556                	mv	a0,s5
    11ae:	00000097          	auipc	ra,0x0
    11b2:	e3a080e7          	jalr	-454(ra) # fe8 <putc>
    11b6:	4941                	li	s2,16
    putc(fd, digits[x >> (sizeof(uint64) * 8 - 4)]);
    11b8:	00001b97          	auipc	s7,0x1
    11bc:	8f8b8b93          	addi	s7,s7,-1800 # 1ab0 <digits>
    11c0:	03c9d793          	srli	a5,s3,0x3c
    11c4:	97de                	add	a5,a5,s7
    11c6:	0007c583          	lbu	a1,0(a5)
    11ca:	8556                	mv	a0,s5
    11cc:	00000097          	auipc	ra,0x0
    11d0:	e1c080e7          	jalr	-484(ra) # fe8 <putc>
  for (i = 0; i < (sizeof(uint64) * 2); i++, x <<= 4)
    11d4:	0992                	slli	s3,s3,0x4
    11d6:	397d                	addiw	s2,s2,-1
    11d8:	fe0914e3          	bnez	s2,11c0 <vprintf+0x10e>
        printptr(fd, va_arg(ap, uint64));
    11dc:	8be2                	mv	s7,s8
      state = 0;
    11de:	4981                	li	s3,0
    11e0:	6c02                	ld	s8,0(sp)
    11e2:	bf09                	j	10f4 <vprintf+0x42>
        s = va_arg(ap, char*);
    11e4:	008b8993          	addi	s3,s7,8
    11e8:	000bb903          	ld	s2,0(s7)
        if(s == 0)
    11ec:	02090163          	beqz	s2,120e <vprintf+0x15c>
        while(*s != 0){
    11f0:	00094583          	lbu	a1,0(s2)
    11f4:	c9a5                	beqz	a1,1264 <vprintf+0x1b2>
          putc(fd, *s);
    11f6:	8556                	mv	a0,s5
    11f8:	00000097          	auipc	ra,0x0
    11fc:	df0080e7          	jalr	-528(ra) # fe8 <putc>
          s++;
    1200:	0905                	addi	s2,s2,1
        while(*s != 0){
    1202:	00094583          	lbu	a1,0(s2)
    1206:	f9e5                	bnez	a1,11f6 <vprintf+0x144>
        s = va_arg(ap, char*);
    1208:	8bce                	mv	s7,s3
      state = 0;
    120a:	4981                	li	s3,0
    120c:	b5e5                	j	10f4 <vprintf+0x42>
          s = "(null)";
    120e:	00000917          	auipc	s2,0x0
    1212:	7ba90913          	addi	s2,s2,1978 # 19c8 <ithread_join+0x35c>
        while(*s != 0){
    1216:	02800593          	li	a1,40
    121a:	bff1                	j	11f6 <vprintf+0x144>
        putc(fd, va_arg(ap, uint));
    121c:	008b8913          	addi	s2,s7,8
    1220:	000bc583          	lbu	a1,0(s7)
    1224:	8556                	mv	a0,s5
    1226:	00000097          	auipc	ra,0x0
    122a:	dc2080e7          	jalr	-574(ra) # fe8 <putc>
    122e:	8bca                	mv	s7,s2
      state = 0;
    1230:	4981                	li	s3,0
    1232:	b5c9                	j	10f4 <vprintf+0x42>
        putc(fd, c);
    1234:	02500593          	li	a1,37
    1238:	8556                	mv	a0,s5
    123a:	00000097          	auipc	ra,0x0
    123e:	dae080e7          	jalr	-594(ra) # fe8 <putc>
      state = 0;
    1242:	4981                	li	s3,0
    1244:	bd45                	j	10f4 <vprintf+0x42>
        putc(fd, '%');
    1246:	02500593          	li	a1,37
    124a:	8556                	mv	a0,s5
    124c:	00000097          	auipc	ra,0x0
    1250:	d9c080e7          	jalr	-612(ra) # fe8 <putc>
        putc(fd, c);
    1254:	85ca                	mv	a1,s2
    1256:	8556                	mv	a0,s5
    1258:	00000097          	auipc	ra,0x0
    125c:	d90080e7          	jalr	-624(ra) # fe8 <putc>
      state = 0;
    1260:	4981                	li	s3,0
    1262:	bd49                	j	10f4 <vprintf+0x42>
        s = va_arg(ap, char*);
    1264:	8bce                	mv	s7,s3
      state = 0;
    1266:	4981                	li	s3,0
    1268:	b571                	j	10f4 <vprintf+0x42>
    126a:	74e2                	ld	s1,56(sp)
    126c:	79a2                	ld	s3,40(sp)
    126e:	7a02                	ld	s4,32(sp)
    1270:	6ae2                	ld	s5,24(sp)
    1272:	6b42                	ld	s6,16(sp)
    1274:	6ba2                	ld	s7,8(sp)
    }
  }
}
    1276:	60a6                	ld	ra,72(sp)
    1278:	6406                	ld	s0,64(sp)
    127a:	7942                	ld	s2,48(sp)
    127c:	6161                	addi	sp,sp,80
    127e:	8082                	ret

0000000000001280 <fprintf>:

void
fprintf(int fd, const char *fmt, ...)
{
    1280:	715d                	addi	sp,sp,-80
    1282:	ec06                	sd	ra,24(sp)
    1284:	e822                	sd	s0,16(sp)
    1286:	1000                	addi	s0,sp,32
    1288:	e010                	sd	a2,0(s0)
    128a:	e414                	sd	a3,8(s0)
    128c:	e818                	sd	a4,16(s0)
    128e:	ec1c                	sd	a5,24(s0)
    1290:	03043023          	sd	a6,32(s0)
    1294:	03143423          	sd	a7,40(s0)
  va_list ap;

  va_start(ap, fmt);
    1298:	8622                	mv	a2,s0
    129a:	fe843423          	sd	s0,-24(s0)
  vprintf(fd, fmt, ap);
    129e:	00000097          	auipc	ra,0x0
    12a2:	e14080e7          	jalr	-492(ra) # 10b2 <vprintf>
}
    12a6:	60e2                	ld	ra,24(sp)
    12a8:	6442                	ld	s0,16(sp)
    12aa:	6161                	addi	sp,sp,80
    12ac:	8082                	ret

00000000000012ae <printf>:

void
printf(const char *fmt, ...)
{
    12ae:	711d                	addi	sp,sp,-96
    12b0:	ec06                	sd	ra,24(sp)
    12b2:	e822                	sd	s0,16(sp)
    12b4:	1000                	addi	s0,sp,32
    12b6:	e40c                	sd	a1,8(s0)
    12b8:	e810                	sd	a2,16(s0)
    12ba:	ec14                	sd	a3,24(s0)
    12bc:	f018                	sd	a4,32(s0)
    12be:	f41c                	sd	a5,40(s0)
    12c0:	03043823          	sd	a6,48(s0)
    12c4:	03143c23          	sd	a7,56(s0)
  va_list ap;

  va_start(ap, fmt);
    12c8:	00840613          	addi	a2,s0,8
    12cc:	fec43423          	sd	a2,-24(s0)
  vprintf(1, fmt, ap);
    12d0:	85aa                	mv	a1,a0
    12d2:	4505                	li	a0,1
    12d4:	00000097          	auipc	ra,0x0
    12d8:	dde080e7          	jalr	-546(ra) # 10b2 <vprintf>
}
    12dc:	60e2                	ld	ra,24(sp)
    12de:	6442                	ld	s0,16(sp)
    12e0:	6125                	addi	sp,sp,96
    12e2:	8082                	ret

00000000000012e4 <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
    12e4:	1141                	addi	sp,sp,-16
    12e6:	e406                	sd	ra,8(sp)
    12e8:	e022                	sd	s0,0(sp)
    12ea:	0800                	addi	s0,sp,16
  Header *bp, *p;

  bp = (Header*)ap - 1;
    12ec:	ff050693          	addi	a3,a0,-16
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
    12f0:	00001797          	auipc	a5,0x1
    12f4:	2f07b783          	ld	a5,752(a5) # 25e0 <freep>
    12f8:	a039                	j	1306 <free+0x22>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
    12fa:	6398                	ld	a4,0(a5)
    12fc:	00e7e463          	bltu	a5,a4,1304 <free+0x20>
    1300:	00e6ea63          	bltu	a3,a4,1314 <free+0x30>
{
    1304:	87ba                	mv	a5,a4
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
    1306:	fed7fae3          	bgeu	a5,a3,12fa <free+0x16>
    130a:	6398                	ld	a4,0(a5)
    130c:	00e6e463          	bltu	a3,a4,1314 <free+0x30>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
    1310:	fee7eae3          	bltu	a5,a4,1304 <free+0x20>
      break;
  if(bp + bp->s.size == p->s.ptr){
    1314:	ff852583          	lw	a1,-8(a0)
    1318:	6390                	ld	a2,0(a5)
    131a:	02059813          	slli	a6,a1,0x20
    131e:	01c85713          	srli	a4,a6,0x1c
    1322:	9736                	add	a4,a4,a3
    1324:	02e60563          	beq	a2,a4,134e <free+0x6a>
    bp->s.size += p->s.ptr->s.size;
    bp->s.ptr = p->s.ptr->s.ptr;
    1328:	fec53823          	sd	a2,-16(a0)
  } else
    bp->s.ptr = p->s.ptr;
  if(p + p->s.size == bp){
    132c:	4790                	lw	a2,8(a5)
    132e:	02061593          	slli	a1,a2,0x20
    1332:	01c5d713          	srli	a4,a1,0x1c
    1336:	973e                	add	a4,a4,a5
    1338:	02e68263          	beq	a3,a4,135c <free+0x78>
    p->s.size += bp->s.size;
    p->s.ptr = bp->s.ptr;
    133c:	e394                	sd	a3,0(a5)
  } else
    p->s.ptr = bp;
  freep = p;
    133e:	00001717          	auipc	a4,0x1
    1342:	2af73123          	sd	a5,674(a4) # 25e0 <freep>
}
    1346:	60a2                	ld	ra,8(sp)
    1348:	6402                	ld	s0,0(sp)
    134a:	0141                	addi	sp,sp,16
    134c:	8082                	ret
    bp->s.size += p->s.ptr->s.size;
    134e:	4618                	lw	a4,8(a2)
    1350:	9f2d                	addw	a4,a4,a1
    1352:	fee52c23          	sw	a4,-8(a0)
    bp->s.ptr = p->s.ptr->s.ptr;
    1356:	6398                	ld	a4,0(a5)
    1358:	6310                	ld	a2,0(a4)
    135a:	b7f9                	j	1328 <free+0x44>
    p->s.size += bp->s.size;
    135c:	ff852703          	lw	a4,-8(a0)
    1360:	9f31                	addw	a4,a4,a2
    1362:	c798                	sw	a4,8(a5)
    p->s.ptr = bp->s.ptr;
    1364:	ff053683          	ld	a3,-16(a0)
    1368:	bfd1                	j	133c <free+0x58>

000000000000136a <malloc>:
  return freep;
}

void*
malloc(uint nbytes)
{
    136a:	7139                	addi	sp,sp,-64
    136c:	fc06                	sd	ra,56(sp)
    136e:	f822                	sd	s0,48(sp)
    1370:	f04a                	sd	s2,32(sp)
    1372:	ec4e                	sd	s3,24(sp)
    1374:	0080                	addi	s0,sp,64
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
    1376:	02051993          	slli	s3,a0,0x20
    137a:	0209d993          	srli	s3,s3,0x20
    137e:	09bd                	addi	s3,s3,15
    1380:	0049d993          	srli	s3,s3,0x4
    1384:	2985                	addiw	s3,s3,1
    1386:	894e                	mv	s2,s3
  if((prevp = freep) == 0){
    1388:	00001517          	auipc	a0,0x1
    138c:	25853503          	ld	a0,600(a0) # 25e0 <freep>
    1390:	c905                	beqz	a0,13c0 <malloc+0x56>
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
    1392:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
    1394:	4798                	lw	a4,8(a5)
    1396:	09377a63          	bgeu	a4,s3,142a <malloc+0xc0>
    139a:	f426                	sd	s1,40(sp)
    139c:	e852                	sd	s4,16(sp)
    139e:	e456                	sd	s5,8(sp)
    13a0:	e05a                	sd	s6,0(sp)
  if(nu < 4096)
    13a2:	8a4e                	mv	s4,s3
    13a4:	6705                	lui	a4,0x1
    13a6:	00e9f363          	bgeu	s3,a4,13ac <malloc+0x42>
    13aa:	6a05                	lui	s4,0x1
    13ac:	000a0b1b          	sext.w	s6,s4
  p = sbrk(nu * sizeof(Header));
    13b0:	004a1a1b          	slliw	s4,s4,0x4
        p->s.size = nunits;
      }
      freep = prevp;
      return (void*)(p + 1);
    }
    if(p == freep)
    13b4:	00001497          	auipc	s1,0x1
    13b8:	22c48493          	addi	s1,s1,556 # 25e0 <freep>
  if(p == (char*)-1)
    13bc:	5afd                	li	s5,-1
    13be:	a089                	j	1400 <malloc+0x96>
    13c0:	f426                	sd	s1,40(sp)
    13c2:	e852                	sd	s4,16(sp)
    13c4:	e456                	sd	s5,8(sp)
    13c6:	e05a                	sd	s6,0(sp)
    base.s.ptr = freep = prevp = &base;
    13c8:	00001797          	auipc	a5,0x1
    13cc:	62078793          	addi	a5,a5,1568 # 29e8 <base>
    13d0:	00001717          	auipc	a4,0x1
    13d4:	20f73823          	sd	a5,528(a4) # 25e0 <freep>
    13d8:	e39c                	sd	a5,0(a5)
    base.s.size = 0;
    13da:	0007a423          	sw	zero,8(a5)
    if(p->s.size >= nunits){
    13de:	b7d1                	j	13a2 <malloc+0x38>
        prevp->s.ptr = p->s.ptr;
    13e0:	6398                	ld	a4,0(a5)
    13e2:	e118                	sd	a4,0(a0)
    13e4:	a8b9                	j	1442 <malloc+0xd8>
  hp->s.size = nu;
    13e6:	01652423          	sw	s6,8(a0)
  free((void*)(hp + 1));
    13ea:	0541                	addi	a0,a0,16
    13ec:	00000097          	auipc	ra,0x0
    13f0:	ef8080e7          	jalr	-264(ra) # 12e4 <free>
  return freep;
    13f4:	6088                	ld	a0,0(s1)
      if((p = morecore(nunits)) == 0)
    13f6:	c135                	beqz	a0,145a <malloc+0xf0>
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
    13f8:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
    13fa:	4798                	lw	a4,8(a5)
    13fc:	03277363          	bgeu	a4,s2,1422 <malloc+0xb8>
    if(p == freep)
    1400:	6098                	ld	a4,0(s1)
    1402:	853e                	mv	a0,a5
    1404:	fef71ae3          	bne	a4,a5,13f8 <malloc+0x8e>
  p = sbrk(nu * sizeof(Header));
    1408:	8552                	mv	a0,s4
    140a:	00000097          	auipc	ra,0x0
    140e:	b7e080e7          	jalr	-1154(ra) # f88 <sbrk>
  if(p == (char*)-1)
    1412:	fd551ae3          	bne	a0,s5,13e6 <malloc+0x7c>
        return 0;
    1416:	4501                	li	a0,0
    1418:	74a2                	ld	s1,40(sp)
    141a:	6a42                	ld	s4,16(sp)
    141c:	6aa2                	ld	s5,8(sp)
    141e:	6b02                	ld	s6,0(sp)
    1420:	a03d                	j	144e <malloc+0xe4>
    1422:	74a2                	ld	s1,40(sp)
    1424:	6a42                	ld	s4,16(sp)
    1426:	6aa2                	ld	s5,8(sp)
    1428:	6b02                	ld	s6,0(sp)
      if(p->s.size == nunits)
    142a:	fae90be3          	beq	s2,a4,13e0 <malloc+0x76>
        p->s.size -= nunits;
    142e:	4137073b          	subw	a4,a4,s3
    1432:	c798                	sw	a4,8(a5)
        p += p->s.size;
    1434:	02071693          	slli	a3,a4,0x20
    1438:	01c6d713          	srli	a4,a3,0x1c
    143c:	97ba                	add	a5,a5,a4
        p->s.size = nunits;
    143e:	0137a423          	sw	s3,8(a5)
      freep = prevp;
    1442:	00001717          	auipc	a4,0x1
    1446:	18a73f23          	sd	a0,414(a4) # 25e0 <freep>
      return (void*)(p + 1);
    144a:	01078513          	addi	a0,a5,16
  }
}
    144e:	70e2                	ld	ra,56(sp)
    1450:	7442                	ld	s0,48(sp)
    1452:	7902                	ld	s2,32(sp)
    1454:	69e2                	ld	s3,24(sp)
    1456:	6121                	addi	sp,sp,64
    1458:	8082                	ret
    145a:	74a2                	ld	s1,40(sp)
    145c:	6a42                	ld	s4,16(sp)
    145e:	6aa2                	ld	s5,8(sp)
    1460:	6b02                	ld	s6,0(sp)
    1462:	b7f5                	j	144e <malloc+0xe4>

0000000000001464 <ithread_exit>:
  free(stacks);
  stacks = new_stacks;
  return 0;
}

void ithread_exit(uint64 status) {
    1464:	1141                	addi	sp,sp,-16
    1466:	e406                	sd	ra,8(sp)
    1468:	e022                	sd	s0,0(sp)
    146a:	0800                	addi	s0,sp,16
  thread_exit(status);
    146c:	2501                	sext.w	a0,a0
    146e:	00000097          	auipc	ra,0x0
    1472:	b4a080e7          	jalr	-1206(ra) # fb8 <thread_exit>
}
    1476:	60a2                	ld	ra,8(sp)
    1478:	6402                	ld	s0,0(sp)
    147a:	0141                	addi	sp,sp,16
    147c:	8082                	ret

000000000000147e <free_stacks>:
int free_stacks() {
    147e:	7179                	addi	sp,sp,-48
    1480:	f406                	sd	ra,40(sp)
    1482:	f022                	sd	s0,32(sp)
    1484:	ec26                	sd	s1,24(sp)
    1486:	1800                	addi	s0,sp,48
  for (int i = 0; i < num_threads; i++) {
    1488:	00001797          	auipc	a5,0x1
    148c:	1687a783          	lw	a5,360(a5) # 25f0 <num_threads>
    1490:	04f05063          	blez	a5,14d0 <free_stacks+0x52>
    1494:	e84a                	sd	s2,16(sp)
    1496:	e44e                	sd	s3,8(sp)
    1498:	4481                	li	s1,0
    free(stacks[i]);
    149a:	00001997          	auipc	s3,0x1
    149e:	14e98993          	addi	s3,s3,334 # 25e8 <stacks>
  for (int i = 0; i < num_threads; i++) {
    14a2:	00001917          	auipc	s2,0x1
    14a6:	14e90913          	addi	s2,s2,334 # 25f0 <num_threads>
    free(stacks[i]);
    14aa:	0009b783          	ld	a5,0(s3)
    14ae:	00349713          	slli	a4,s1,0x3
    14b2:	97ba                	add	a5,a5,a4
    14b4:	6388                	ld	a0,0(a5)
    14b6:	00000097          	auipc	ra,0x0
    14ba:	e2e080e7          	jalr	-466(ra) # 12e4 <free>
  for (int i = 0; i < num_threads; i++) {
    14be:	0485                	addi	s1,s1,1
    14c0:	00092703          	lw	a4,0(s2)
    14c4:	0004879b          	sext.w	a5,s1
    14c8:	fee7c1e3          	blt	a5,a4,14aa <free_stacks+0x2c>
    14cc:	6942                	ld	s2,16(sp)
    14ce:	69a2                	ld	s3,8(sp)
  free(stacks);
    14d0:	00001497          	auipc	s1,0x1
    14d4:	11848493          	addi	s1,s1,280 # 25e8 <stacks>
    14d8:	6088                	ld	a0,0(s1)
    14da:	00000097          	auipc	ra,0x0
    14de:	e0a080e7          	jalr	-502(ra) # 12e4 <free>
  stacks = 0;
    14e2:	0004b023          	sd	zero,0(s1)
  num_threads = 0;
    14e6:	00001797          	auipc	a5,0x1
    14ea:	1007a523          	sw	zero,266(a5) # 25f0 <num_threads>
  max_stacks = INIT_MAX_STACKS;
    14ee:	47a1                	li	a5,8
    14f0:	00001717          	auipc	a4,0x1
    14f4:	0ef72423          	sw	a5,232(a4) # 25d8 <max_stacks>
  threads_done = 0;
    14f8:	00001797          	auipc	a5,0x1
    14fc:	0e07ae23          	sw	zero,252(a5) # 25f4 <threads_done>
}
    1500:	4501                	li	a0,0
    1502:	70a2                	ld	ra,40(sp)
    1504:	7402                	ld	s0,32(sp)
    1506:	64e2                	ld	s1,24(sp)
    1508:	6145                	addi	sp,sp,48
    150a:	8082                	ret

000000000000150c <expand_num_threads>:
int expand_num_threads() {
    150c:	1101                	addi	sp,sp,-32
    150e:	ec06                	sd	ra,24(sp)
    1510:	e822                	sd	s0,16(sp)
    1512:	e426                	sd	s1,8(sp)
    1514:	e04a                	sd	s2,0(sp)
    1516:	1000                	addi	s0,sp,32
  max_stacks *= 2;
    1518:	00001797          	auipc	a5,0x1
    151c:	0c078793          	addi	a5,a5,192 # 25d8 <max_stacks>
    1520:	4388                	lw	a0,0(a5)
    1522:	0015151b          	slliw	a0,a0,0x1
    1526:	c388                	sw	a0,0(a5)
  void **new_stacks = malloc(max_stacks*sizeof(char*));
    1528:	0035151b          	slliw	a0,a0,0x3
    152c:	00000097          	auipc	ra,0x0
    1530:	e3e080e7          	jalr	-450(ra) # 136a <malloc>
    1534:	892a                	mv	s2,a0
  memmove(new_stacks, stacks, num_threads*sizeof(char*));
    1536:	00001617          	auipc	a2,0x1
    153a:	0ba62603          	lw	a2,186(a2) # 25f0 <num_threads>
    153e:	00001497          	auipc	s1,0x1
    1542:	0aa48493          	addi	s1,s1,170 # 25e8 <stacks>
    1546:	0036161b          	slliw	a2,a2,0x3
    154a:	608c                	ld	a1,0(s1)
    154c:	00000097          	auipc	ra,0x0
    1550:	8fe080e7          	jalr	-1794(ra) # e4a <memmove>
  free(stacks);
    1554:	6088                	ld	a0,0(s1)
    1556:	00000097          	auipc	ra,0x0
    155a:	d8e080e7          	jalr	-626(ra) # 12e4 <free>
  stacks = new_stacks;
    155e:	0124b023          	sd	s2,0(s1)
}
    1562:	4501                	li	a0,0
    1564:	60e2                	ld	ra,24(sp)
    1566:	6442                	ld	s0,16(sp)
    1568:	64a2                	ld	s1,8(sp)
    156a:	6902                	ld	s2,0(sp)
    156c:	6105                	addi	sp,sp,32
    156e:	8082                	ret

0000000000001570 <ithread_create>:

int ithread_create(void* (*fn_ptr)(void *), void *args) {
    1570:	7179                	addi	sp,sp,-48
    1572:	f406                	sd	ra,40(sp)
    1574:	f022                	sd	s0,32(sp)
    1576:	e84a                	sd	s2,16(sp)
    1578:	e44e                	sd	s3,8(sp)
    157a:	1800                	addi	s0,sp,48
    157c:	892a                	mv	s2,a0
    157e:	89ae                	mv	s3,a1
  if (stacks == 0) {
    1580:	00001797          	auipc	a5,0x1
    1584:	0687b783          	ld	a5,104(a5) # 25e8 <stacks>
    1588:	c3d9                	beqz	a5,160e <ithread_create+0x9e>
    stacks = malloc(max_stacks*sizeof(char*));
  }
  if (num_threads == max_stacks) {
    158a:	00001797          	auipc	a5,0x1
    158e:	04e7a783          	lw	a5,78(a5) # 25d8 <max_stacks>
    1592:	00001717          	auipc	a4,0x1
    1596:	05e72703          	lw	a4,94(a4) # 25f0 <num_threads>
    159a:	0af71463          	bne	a4,a5,1642 <ithread_create+0xd2>
    if (max_stacks == MAX_THREADS) {
    159e:	04000713          	li	a4,64
    15a2:	08e78563          	beq	a5,a4,162c <ithread_create+0xbc>
    15a6:	ec26                	sd	s1,24(sp)
      printf("ERROR: Thread capacity has been reached\n");
      return -1;
    }
    expand_num_threads();
    15a8:	00000097          	auipc	ra,0x0
    15ac:	f64080e7          	jalr	-156(ra) # 150c <expand_num_threads>
  }

  void *stack_ptr = malloc(PGSIZE);
    15b0:	6505                	lui	a0,0x1
    15b2:	00000097          	auipc	ra,0x0
    15b6:	db8080e7          	jalr	-584(ra) # 136a <malloc>
    15ba:	84aa                	mv	s1,a0
  stacks[num_threads] = stack_ptr;
    15bc:	00001717          	auipc	a4,0x1
    15c0:	03472703          	lw	a4,52(a4) # 25f0 <num_threads>
    15c4:	070e                	slli	a4,a4,0x3
    15c6:	00001797          	auipc	a5,0x1
    15ca:	0227b783          	ld	a5,34(a5) # 25e8 <stacks>
    15ce:	97ba                	add	a5,a5,a4
    15d0:	e388                	sd	a0,0(a5)
  int res = create_thread(fn_ptr, args, stack_ptr, &ithread_exit);
    15d2:	00000697          	auipc	a3,0x0
    15d6:	e9268693          	addi	a3,a3,-366 # 1464 <ithread_exit>
    15da:	862a                	mv	a2,a0
    15dc:	85ce                	mv	a1,s3
    15de:	854a                	mv	a0,s2
    15e0:	00000097          	auipc	ra,0x0
    15e4:	9c8080e7          	jalr	-1592(ra) # fa8 <create_thread>
    15e8:	892a                	mv	s2,a0
  if (res != -1) {
    15ea:	57fd                	li	a5,-1
    15ec:	04f50d63          	beq	a0,a5,1646 <ithread_create+0xd6>
    num_threads++;
    15f0:	00001717          	auipc	a4,0x1
    15f4:	00070713          	mv	a4,a4
    15f8:	431c                	lw	a5,0(a4)
    15fa:	2785                	addiw	a5,a5,1
    15fc:	c31c                	sw	a5,0(a4)
    15fe:	64e2                	ld	s1,24(sp)
  } else {
    free(stack_ptr);
    stacks[num_threads] = 0;
  }
  return res;
}
    1600:	854a                	mv	a0,s2
    1602:	70a2                	ld	ra,40(sp)
    1604:	7402                	ld	s0,32(sp)
    1606:	6942                	ld	s2,16(sp)
    1608:	69a2                	ld	s3,8(sp)
    160a:	6145                	addi	sp,sp,48
    160c:	8082                	ret
    stacks = malloc(max_stacks*sizeof(char*));
    160e:	00001517          	auipc	a0,0x1
    1612:	fca52503          	lw	a0,-54(a0) # 25d8 <max_stacks>
    1616:	0035151b          	slliw	a0,a0,0x3
    161a:	00000097          	auipc	ra,0x0
    161e:	d50080e7          	jalr	-688(ra) # 136a <malloc>
    1622:	00001797          	auipc	a5,0x1
    1626:	fca7b323          	sd	a0,-58(a5) # 25e8 <stacks>
    162a:	b785                	j	158a <ithread_create+0x1a>
      printf("ERROR: Thread capacity has been reached\n");
    162c:	00000517          	auipc	a0,0x0
    1630:	3a450513          	addi	a0,a0,932 # 19d0 <ithread_join+0x364>
    1634:	00000097          	auipc	ra,0x0
    1638:	c7a080e7          	jalr	-902(ra) # 12ae <printf>
      return -1;
    163c:	57fd                	li	a5,-1
    163e:	893e                	mv	s2,a5
    1640:	b7c1                	j	1600 <ithread_create+0x90>
    1642:	ec26                	sd	s1,24(sp)
    1644:	b7b5                	j	15b0 <ithread_create+0x40>
    free(stack_ptr);
    1646:	8526                	mv	a0,s1
    1648:	00000097          	auipc	ra,0x0
    164c:	c9c080e7          	jalr	-868(ra) # 12e4 <free>
    stacks[num_threads] = 0;
    1650:	00001717          	auipc	a4,0x1
    1654:	fa072703          	lw	a4,-96(a4) # 25f0 <num_threads>
    1658:	070e                	slli	a4,a4,0x3
    165a:	00001797          	auipc	a5,0x1
    165e:	f8e7b783          	ld	a5,-114(a5) # 25e8 <stacks>
    1662:	97ba                	add	a5,a5,a4
    1664:	0007b023          	sd	zero,0(a5)
    1668:	64e2                	ld	s1,24(sp)
    166a:	bf59                	j	1600 <ithread_create+0x90>

000000000000166c <ithread_join>:

int ithread_join(int thread_id) {
    166c:	1101                	addi	sp,sp,-32
    166e:	ec06                	sd	ra,24(sp)
    1670:	e822                	sd	s0,16(sp)
    1672:	1000                	addi	s0,sp,32
  int status;
  join_thread(thread_id, (uint64)&status);
    1674:	ff040793          	addi	a5,s0,-16
    1678:	ffc7859b          	addiw	a1,a5,-4
    167c:	00000097          	auipc	ra,0x0
    1680:	934080e7          	jalr	-1740(ra) # fb0 <join_thread>
  threads_done++;
    1684:	00001717          	auipc	a4,0x1
    1688:	f7070713          	addi	a4,a4,-144 # 25f4 <threads_done>
    168c:	431c                	lw	a5,0(a4)
    168e:	2785                	addiw	a5,a5,1
    1690:	c31c                	sw	a5,0(a4)
  if (threads_done == num_threads) {
    1692:	00001717          	auipc	a4,0x1
    1696:	f5e72703          	lw	a4,-162(a4) # 25f0 <num_threads>
    169a:	00f70863          	beq	a4,a5,16aa <ithread_join+0x3e>
    free_stacks();
  }
  return status;
}
    169e:	fec42503          	lw	a0,-20(s0)
    16a2:	60e2                	ld	ra,24(sp)
    16a4:	6442                	ld	s0,16(sp)
    16a6:	6105                	addi	sp,sp,32
    16a8:	8082                	ret
    free_stacks();
    16aa:	00000097          	auipc	ra,0x0
    16ae:	dd4080e7          	jalr	-556(ra) # 147e <free_stacks>
    16b2:	b7f5                	j	169e <ithread_join+0x32>
