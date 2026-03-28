
src/user/_grind:     file format elf64-littleriscv


Disassembly of section .text:

0000000000000000 <do_rand>:
#include "kernel/riscv.h"

// from FreeBSD.
int
do_rand(unsigned long *ctx)
{
       0:	1141                	addi	sp,sp,-16
       2:	e422                	sd	s0,8(sp)
       4:	0800                	addi	s0,sp,16
 * October 1988, p. 1195.
 */
    long hi, lo, x;

    /* Transform to [1, 0x7ffffffe] range. */
    x = (*ctx % 0x7ffffffe) + 1;
       6:	611c                	ld	a5,0(a0)
       8:	80000737          	lui	a4,0x80000
       c:	ffe74713          	xori	a4,a4,-2
      10:	02e7f7b3          	remu	a5,a5,a4
      14:	0785                	addi	a5,a5,1
    hi = x / 127773;
    lo = x % 127773;
      16:	66fd                	lui	a3,0x1f
      18:	31d68693          	addi	a3,a3,797 # 1f31d <base+0x1cf05>
      1c:	02d7e733          	rem	a4,a5,a3
    x = 16807 * lo - 2836 * hi;
      20:	6611                	lui	a2,0x4
      22:	1a760613          	addi	a2,a2,423 # 41a7 <base+0x1d8f>
      26:	02c70733          	mul	a4,a4,a2
    hi = x / 127773;
      2a:	02d7c7b3          	div	a5,a5,a3
    x = 16807 * lo - 2836 * hi;
      2e:	76fd                	lui	a3,0xfffff
      30:	4ec68693          	addi	a3,a3,1260 # fffffffffffff4ec <base+0xffffffffffffd0d4>
      34:	02d787b3          	mul	a5,a5,a3
      38:	97ba                	add	a5,a5,a4
    if (x < 0)
      3a:	0007c963          	bltz	a5,4c <do_rand+0x4c>
        x += 0x7fffffff;
    /* Transform to [0, 0x7ffffffd] range. */
    x--;
      3e:	17fd                	addi	a5,a5,-1
    *ctx = x;
      40:	e11c                	sd	a5,0(a0)
    return (x);
}
      42:	0007851b          	sext.w	a0,a5
      46:	6422                	ld	s0,8(sp)
      48:	0141                	addi	sp,sp,16
      4a:	8082                	ret
        x += 0x7fffffff;
      4c:	80000737          	lui	a4,0x80000
      50:	fff74713          	not	a4,a4
      54:	97ba                	add	a5,a5,a4
      56:	b7e5                	j	3e <do_rand+0x3e>

0000000000000058 <rand>:

unsigned long rand_next = 1;

int
rand(void)
{
      58:	1141                	addi	sp,sp,-16
      5a:	e406                	sd	ra,8(sp)
      5c:	e022                	sd	s0,0(sp)
      5e:	0800                	addi	s0,sp,16
    return (do_rand(&rand_next));
      60:	00002517          	auipc	a0,0x2
      64:	fa050513          	addi	a0,a0,-96 # 2000 <rand_next>
      68:	00000097          	auipc	ra,0x0
      6c:	f98080e7          	jalr	-104(ra) # 0 <do_rand>
}
      70:	60a2                	ld	ra,8(sp)
      72:	6402                	ld	s0,0(sp)
      74:	0141                	addi	sp,sp,16
      76:	8082                	ret

0000000000000078 <go>:

void
go(int which_child)
{
      78:	7159                	addi	sp,sp,-112
      7a:	f486                	sd	ra,104(sp)
      7c:	f0a2                	sd	s0,96(sp)
      7e:	eca6                	sd	s1,88(sp)
      80:	fc56                	sd	s5,56(sp)
      82:	1880                	addi	s0,sp,112
      84:	84aa                	mv	s1,a0
  int fd = -1;
  static char buf[999];
  char *break0 = sbrk(0);
      86:	4501                	li	a0,0
      88:	00001097          	auipc	ra,0x1
      8c:	f4c080e7          	jalr	-180(ra) # fd4 <sbrk>
      90:	8aaa                	mv	s5,a0
  uint64 iters = 0;

  mkdir("grindir");
      92:	00001517          	auipc	a0,0x1
      96:	69e50513          	addi	a0,a0,1694 # 1730 <ithread_join+0x50>
      9a:	00001097          	auipc	ra,0x1
      9e:	f1a080e7          	jalr	-230(ra) # fb4 <mkdir>
  if(chdir("grindir") != 0){
      a2:	00001517          	auipc	a0,0x1
      a6:	68e50513          	addi	a0,a0,1678 # 1730 <ithread_join+0x50>
      aa:	00001097          	auipc	ra,0x1
      ae:	f12080e7          	jalr	-238(ra) # fbc <chdir>
      b2:	c115                	beqz	a0,d6 <go+0x5e>
      b4:	e8ca                	sd	s2,80(sp)
      b6:	e4ce                	sd	s3,72(sp)
      b8:	e0d2                	sd	s4,64(sp)
      ba:	f85a                	sd	s6,48(sp)
    printf("grind: chdir grindir failed\n");
      bc:	00001517          	auipc	a0,0x1
      c0:	67c50513          	addi	a0,a0,1660 # 1738 <ithread_join+0x58>
      c4:	00001097          	auipc	ra,0x1
      c8:	25e080e7          	jalr	606(ra) # 1322 <printf>
    exit(1);
      cc:	4505                	li	a0,1
      ce:	00001097          	auipc	ra,0x1
      d2:	e7e080e7          	jalr	-386(ra) # f4c <exit>
      d6:	e8ca                	sd	s2,80(sp)
      d8:	e4ce                	sd	s3,72(sp)
      da:	e0d2                	sd	s4,64(sp)
      dc:	f85a                	sd	s6,48(sp)
  }
  chdir("/");
      de:	00001517          	auipc	a0,0x1
      e2:	68250513          	addi	a0,a0,1666 # 1760 <ithread_join+0x80>
      e6:	00001097          	auipc	ra,0x1
      ea:	ed6080e7          	jalr	-298(ra) # fbc <chdir>
      ee:	00001997          	auipc	s3,0x1
      f2:	68298993          	addi	s3,s3,1666 # 1770 <ithread_join+0x90>
      f6:	c489                	beqz	s1,100 <go+0x88>
      f8:	00001997          	auipc	s3,0x1
      fc:	67098993          	addi	s3,s3,1648 # 1768 <ithread_join+0x88>
  uint64 iters = 0;
     100:	4481                	li	s1,0
  int fd = -1;
     102:	5a7d                	li	s4,-1
     104:	00002917          	auipc	s2,0x2
     108:	96890913          	addi	s2,s2,-1688 # 1a6c <ithread_join+0x38c>
     10c:	a839                	j	12a <go+0xb2>
    iters++;
    if((iters % 500) == 0)
      write(1, which_child?"B":"A", 1);
    int what = rand() % 23;
    if(what == 1){
      close(open("grindir/../a", O_CREATE|O_RDWR));
     10e:	20200593          	li	a1,514
     112:	00001517          	auipc	a0,0x1
     116:	66650513          	addi	a0,a0,1638 # 1778 <ithread_join+0x98>
     11a:	00001097          	auipc	ra,0x1
     11e:	e72080e7          	jalr	-398(ra) # f8c <open>
     122:	00001097          	auipc	ra,0x1
     126:	e52080e7          	jalr	-430(ra) # f74 <close>
    iters++;
     12a:	0485                	addi	s1,s1,1
    if((iters % 500) == 0)
     12c:	1f400793          	li	a5,500
     130:	02f4f7b3          	remu	a5,s1,a5
     134:	eb81                	bnez	a5,144 <go+0xcc>
      write(1, which_child?"B":"A", 1);
     136:	4605                	li	a2,1
     138:	85ce                	mv	a1,s3
     13a:	4505                	li	a0,1
     13c:	00001097          	auipc	ra,0x1
     140:	e30080e7          	jalr	-464(ra) # f6c <write>
    int what = rand() % 23;
     144:	00000097          	auipc	ra,0x0
     148:	f14080e7          	jalr	-236(ra) # 58 <rand>
     14c:	47dd                	li	a5,23
     14e:	02f5653b          	remw	a0,a0,a5
     152:	0005071b          	sext.w	a4,a0
     156:	47d9                	li	a5,22
     158:	fce7e9e3          	bltu	a5,a4,12a <go+0xb2>
     15c:	02051793          	slli	a5,a0,0x20
     160:	01e7d513          	srli	a0,a5,0x1e
     164:	954a                	add	a0,a0,s2
     166:	411c                	lw	a5,0(a0)
     168:	97ca                	add	a5,a5,s2
     16a:	8782                	jr	a5
    } else if(what == 2){
      close(open("grindir/../grindir/../b", O_CREATE|O_RDWR));
     16c:	20200593          	li	a1,514
     170:	00001517          	auipc	a0,0x1
     174:	61850513          	addi	a0,a0,1560 # 1788 <ithread_join+0xa8>
     178:	00001097          	auipc	ra,0x1
     17c:	e14080e7          	jalr	-492(ra) # f8c <open>
     180:	00001097          	auipc	ra,0x1
     184:	df4080e7          	jalr	-524(ra) # f74 <close>
     188:	b74d                	j	12a <go+0xb2>
    } else if(what == 3){
      unlink("grindir/../a");
     18a:	00001517          	auipc	a0,0x1
     18e:	5ee50513          	addi	a0,a0,1518 # 1778 <ithread_join+0x98>
     192:	00001097          	auipc	ra,0x1
     196:	e0a080e7          	jalr	-502(ra) # f9c <unlink>
     19a:	bf41                	j	12a <go+0xb2>
    } else if(what == 4){
      if(chdir("grindir") != 0){
     19c:	00001517          	auipc	a0,0x1
     1a0:	59450513          	addi	a0,a0,1428 # 1730 <ithread_join+0x50>
     1a4:	00001097          	auipc	ra,0x1
     1a8:	e18080e7          	jalr	-488(ra) # fbc <chdir>
     1ac:	e115                	bnez	a0,1d0 <go+0x158>
        printf("grind: chdir grindir failed\n");
        exit(1);
      }
      unlink("../b");
     1ae:	00001517          	auipc	a0,0x1
     1b2:	5f250513          	addi	a0,a0,1522 # 17a0 <ithread_join+0xc0>
     1b6:	00001097          	auipc	ra,0x1
     1ba:	de6080e7          	jalr	-538(ra) # f9c <unlink>
      chdir("/");
     1be:	00001517          	auipc	a0,0x1
     1c2:	5a250513          	addi	a0,a0,1442 # 1760 <ithread_join+0x80>
     1c6:	00001097          	auipc	ra,0x1
     1ca:	df6080e7          	jalr	-522(ra) # fbc <chdir>
     1ce:	bfb1                	j	12a <go+0xb2>
        printf("grind: chdir grindir failed\n");
     1d0:	00001517          	auipc	a0,0x1
     1d4:	56850513          	addi	a0,a0,1384 # 1738 <ithread_join+0x58>
     1d8:	00001097          	auipc	ra,0x1
     1dc:	14a080e7          	jalr	330(ra) # 1322 <printf>
        exit(1);
     1e0:	4505                	li	a0,1
     1e2:	00001097          	auipc	ra,0x1
     1e6:	d6a080e7          	jalr	-662(ra) # f4c <exit>
    } else if(what == 5){
      close(fd);
     1ea:	8552                	mv	a0,s4
     1ec:	00001097          	auipc	ra,0x1
     1f0:	d88080e7          	jalr	-632(ra) # f74 <close>
      fd = open("/grindir/../a", O_CREATE|O_RDWR);
     1f4:	20200593          	li	a1,514
     1f8:	00001517          	auipc	a0,0x1
     1fc:	5b050513          	addi	a0,a0,1456 # 17a8 <ithread_join+0xc8>
     200:	00001097          	auipc	ra,0x1
     204:	d8c080e7          	jalr	-628(ra) # f8c <open>
     208:	8a2a                	mv	s4,a0
     20a:	b705                	j	12a <go+0xb2>
    } else if(what == 6){
      close(fd);
     20c:	8552                	mv	a0,s4
     20e:	00001097          	auipc	ra,0x1
     212:	d66080e7          	jalr	-666(ra) # f74 <close>
      fd = open("/./grindir/./../b", O_CREATE|O_RDWR);
     216:	20200593          	li	a1,514
     21a:	00001517          	auipc	a0,0x1
     21e:	59e50513          	addi	a0,a0,1438 # 17b8 <ithread_join+0xd8>
     222:	00001097          	auipc	ra,0x1
     226:	d6a080e7          	jalr	-662(ra) # f8c <open>
     22a:	8a2a                	mv	s4,a0
     22c:	bdfd                	j	12a <go+0xb2>
    } else if(what == 7){
      write(fd, buf, sizeof(buf));
     22e:	3e700613          	li	a2,999
     232:	00002597          	auipc	a1,0x2
     236:	dfe58593          	addi	a1,a1,-514 # 2030 <buf.0>
     23a:	8552                	mv	a0,s4
     23c:	00001097          	auipc	ra,0x1
     240:	d30080e7          	jalr	-720(ra) # f6c <write>
     244:	b5dd                	j	12a <go+0xb2>
    } else if(what == 8){
      read(fd, buf, sizeof(buf));
     246:	3e700613          	li	a2,999
     24a:	00002597          	auipc	a1,0x2
     24e:	de658593          	addi	a1,a1,-538 # 2030 <buf.0>
     252:	8552                	mv	a0,s4
     254:	00001097          	auipc	ra,0x1
     258:	d10080e7          	jalr	-752(ra) # f64 <read>
     25c:	b5f9                	j	12a <go+0xb2>
    } else if(what == 9){
      mkdir("grindir/../a");
     25e:	00001517          	auipc	a0,0x1
     262:	51a50513          	addi	a0,a0,1306 # 1778 <ithread_join+0x98>
     266:	00001097          	auipc	ra,0x1
     26a:	d4e080e7          	jalr	-690(ra) # fb4 <mkdir>
      close(open("a/../a/./a", O_CREATE|O_RDWR));
     26e:	20200593          	li	a1,514
     272:	00001517          	auipc	a0,0x1
     276:	55e50513          	addi	a0,a0,1374 # 17d0 <ithread_join+0xf0>
     27a:	00001097          	auipc	ra,0x1
     27e:	d12080e7          	jalr	-750(ra) # f8c <open>
     282:	00001097          	auipc	ra,0x1
     286:	cf2080e7          	jalr	-782(ra) # f74 <close>
      unlink("a/a");
     28a:	00001517          	auipc	a0,0x1
     28e:	55650513          	addi	a0,a0,1366 # 17e0 <ithread_join+0x100>
     292:	00001097          	auipc	ra,0x1
     296:	d0a080e7          	jalr	-758(ra) # f9c <unlink>
     29a:	bd41                	j	12a <go+0xb2>
    } else if(what == 10){
      mkdir("/../b");
     29c:	00001517          	auipc	a0,0x1
     2a0:	54c50513          	addi	a0,a0,1356 # 17e8 <ithread_join+0x108>
     2a4:	00001097          	auipc	ra,0x1
     2a8:	d10080e7          	jalr	-752(ra) # fb4 <mkdir>
      close(open("grindir/../b/b", O_CREATE|O_RDWR));
     2ac:	20200593          	li	a1,514
     2b0:	00001517          	auipc	a0,0x1
     2b4:	54050513          	addi	a0,a0,1344 # 17f0 <ithread_join+0x110>
     2b8:	00001097          	auipc	ra,0x1
     2bc:	cd4080e7          	jalr	-812(ra) # f8c <open>
     2c0:	00001097          	auipc	ra,0x1
     2c4:	cb4080e7          	jalr	-844(ra) # f74 <close>
      unlink("b/b");
     2c8:	00001517          	auipc	a0,0x1
     2cc:	53850513          	addi	a0,a0,1336 # 1800 <ithread_join+0x120>
     2d0:	00001097          	auipc	ra,0x1
     2d4:	ccc080e7          	jalr	-820(ra) # f9c <unlink>
     2d8:	bd89                	j	12a <go+0xb2>
    } else if(what == 11){
      unlink("b");
     2da:	00001517          	auipc	a0,0x1
     2de:	52e50513          	addi	a0,a0,1326 # 1808 <ithread_join+0x128>
     2e2:	00001097          	auipc	ra,0x1
     2e6:	cba080e7          	jalr	-838(ra) # f9c <unlink>
      link("../grindir/./../a", "../b");
     2ea:	00001597          	auipc	a1,0x1
     2ee:	4b658593          	addi	a1,a1,1206 # 17a0 <ithread_join+0xc0>
     2f2:	00001517          	auipc	a0,0x1
     2f6:	51e50513          	addi	a0,a0,1310 # 1810 <ithread_join+0x130>
     2fa:	00001097          	auipc	ra,0x1
     2fe:	cb2080e7          	jalr	-846(ra) # fac <link>
     302:	b525                	j	12a <go+0xb2>
    } else if(what == 12){
      unlink("../grindir/../a");
     304:	00001517          	auipc	a0,0x1
     308:	52450513          	addi	a0,a0,1316 # 1828 <ithread_join+0x148>
     30c:	00001097          	auipc	ra,0x1
     310:	c90080e7          	jalr	-880(ra) # f9c <unlink>
      link(".././b", "/grindir/../a");
     314:	00001597          	auipc	a1,0x1
     318:	49458593          	addi	a1,a1,1172 # 17a8 <ithread_join+0xc8>
     31c:	00001517          	auipc	a0,0x1
     320:	51c50513          	addi	a0,a0,1308 # 1838 <ithread_join+0x158>
     324:	00001097          	auipc	ra,0x1
     328:	c88080e7          	jalr	-888(ra) # fac <link>
     32c:	bbfd                	j	12a <go+0xb2>
    } else if(what == 13){
      int pid = fork();
     32e:	00001097          	auipc	ra,0x1
     332:	c16080e7          	jalr	-1002(ra) # f44 <fork>
      if(pid == 0){
     336:	c909                	beqz	a0,348 <go+0x2d0>
        exit(0);
      } else if(pid < 0){
     338:	00054c63          	bltz	a0,350 <go+0x2d8>
        printf("grind: fork failed\n");
        exit(1);
      }
      wait(0);
     33c:	4501                	li	a0,0
     33e:	00001097          	auipc	ra,0x1
     342:	c16080e7          	jalr	-1002(ra) # f54 <wait>
     346:	b3d5                	j	12a <go+0xb2>
        exit(0);
     348:	00001097          	auipc	ra,0x1
     34c:	c04080e7          	jalr	-1020(ra) # f4c <exit>
        printf("grind: fork failed\n");
     350:	00001517          	auipc	a0,0x1
     354:	4f050513          	addi	a0,a0,1264 # 1840 <ithread_join+0x160>
     358:	00001097          	auipc	ra,0x1
     35c:	fca080e7          	jalr	-54(ra) # 1322 <printf>
        exit(1);
     360:	4505                	li	a0,1
     362:	00001097          	auipc	ra,0x1
     366:	bea080e7          	jalr	-1046(ra) # f4c <exit>
    } else if(what == 14){
      int pid = fork();
     36a:	00001097          	auipc	ra,0x1
     36e:	bda080e7          	jalr	-1062(ra) # f44 <fork>
      if(pid == 0){
     372:	c909                	beqz	a0,384 <go+0x30c>
        fork();
        fork();
        exit(0);
      } else if(pid < 0){
     374:	02054563          	bltz	a0,39e <go+0x326>
        printf("grind: fork failed\n");
        exit(1);
      }
      wait(0);
     378:	4501                	li	a0,0
     37a:	00001097          	auipc	ra,0x1
     37e:	bda080e7          	jalr	-1062(ra) # f54 <wait>
     382:	b365                	j	12a <go+0xb2>
        fork();
     384:	00001097          	auipc	ra,0x1
     388:	bc0080e7          	jalr	-1088(ra) # f44 <fork>
        fork();
     38c:	00001097          	auipc	ra,0x1
     390:	bb8080e7          	jalr	-1096(ra) # f44 <fork>
        exit(0);
     394:	4501                	li	a0,0
     396:	00001097          	auipc	ra,0x1
     39a:	bb6080e7          	jalr	-1098(ra) # f4c <exit>
        printf("grind: fork failed\n");
     39e:	00001517          	auipc	a0,0x1
     3a2:	4a250513          	addi	a0,a0,1186 # 1840 <ithread_join+0x160>
     3a6:	00001097          	auipc	ra,0x1
     3aa:	f7c080e7          	jalr	-132(ra) # 1322 <printf>
        exit(1);
     3ae:	4505                	li	a0,1
     3b0:	00001097          	auipc	ra,0x1
     3b4:	b9c080e7          	jalr	-1124(ra) # f4c <exit>
    } else if(what == 15){
      sbrk(6011);
     3b8:	6505                	lui	a0,0x1
     3ba:	77b50513          	addi	a0,a0,1915 # 177b <ithread_join+0x9b>
     3be:	00001097          	auipc	ra,0x1
     3c2:	c16080e7          	jalr	-1002(ra) # fd4 <sbrk>
     3c6:	b395                	j	12a <go+0xb2>
    } else if(what == 16){
      if(sbrk(0) > break0)
     3c8:	4501                	li	a0,0
     3ca:	00001097          	auipc	ra,0x1
     3ce:	c0a080e7          	jalr	-1014(ra) # fd4 <sbrk>
     3d2:	d4aafce3          	bgeu	s5,a0,12a <go+0xb2>
        sbrk(-(sbrk(0) - break0));
     3d6:	4501                	li	a0,0
     3d8:	00001097          	auipc	ra,0x1
     3dc:	bfc080e7          	jalr	-1028(ra) # fd4 <sbrk>
     3e0:	40aa853b          	subw	a0,s5,a0
     3e4:	00001097          	auipc	ra,0x1
     3e8:	bf0080e7          	jalr	-1040(ra) # fd4 <sbrk>
     3ec:	bb3d                	j	12a <go+0xb2>
    } else if(what == 17){
      int pid = fork();
     3ee:	00001097          	auipc	ra,0x1
     3f2:	b56080e7          	jalr	-1194(ra) # f44 <fork>
     3f6:	8b2a                	mv	s6,a0
      if(pid == 0){
     3f8:	c51d                	beqz	a0,426 <go+0x3ae>
        close(open("a", O_CREATE|O_RDWR));
        exit(0);
      } else if(pid < 0){
     3fa:	04054963          	bltz	a0,44c <go+0x3d4>
        printf("grind: fork failed\n");
        exit(1);
      }
      if(chdir("../grindir/..") != 0){
     3fe:	00001517          	auipc	a0,0x1
     402:	46250513          	addi	a0,a0,1122 # 1860 <ithread_join+0x180>
     406:	00001097          	auipc	ra,0x1
     40a:	bb6080e7          	jalr	-1098(ra) # fbc <chdir>
     40e:	ed21                	bnez	a0,466 <go+0x3ee>
        printf("grind: chdir failed\n");
        exit(1);
      }
      kill(pid);
     410:	855a                	mv	a0,s6
     412:	00001097          	auipc	ra,0x1
     416:	b6a080e7          	jalr	-1174(ra) # f7c <kill>
      wait(0);
     41a:	4501                	li	a0,0
     41c:	00001097          	auipc	ra,0x1
     420:	b38080e7          	jalr	-1224(ra) # f54 <wait>
     424:	b319                	j	12a <go+0xb2>
        close(open("a", O_CREATE|O_RDWR));
     426:	20200593          	li	a1,514
     42a:	00001517          	auipc	a0,0x1
     42e:	42e50513          	addi	a0,a0,1070 # 1858 <ithread_join+0x178>
     432:	00001097          	auipc	ra,0x1
     436:	b5a080e7          	jalr	-1190(ra) # f8c <open>
     43a:	00001097          	auipc	ra,0x1
     43e:	b3a080e7          	jalr	-1222(ra) # f74 <close>
        exit(0);
     442:	4501                	li	a0,0
     444:	00001097          	auipc	ra,0x1
     448:	b08080e7          	jalr	-1272(ra) # f4c <exit>
        printf("grind: fork failed\n");
     44c:	00001517          	auipc	a0,0x1
     450:	3f450513          	addi	a0,a0,1012 # 1840 <ithread_join+0x160>
     454:	00001097          	auipc	ra,0x1
     458:	ece080e7          	jalr	-306(ra) # 1322 <printf>
        exit(1);
     45c:	4505                	li	a0,1
     45e:	00001097          	auipc	ra,0x1
     462:	aee080e7          	jalr	-1298(ra) # f4c <exit>
        printf("grind: chdir failed\n");
     466:	00001517          	auipc	a0,0x1
     46a:	40a50513          	addi	a0,a0,1034 # 1870 <ithread_join+0x190>
     46e:	00001097          	auipc	ra,0x1
     472:	eb4080e7          	jalr	-332(ra) # 1322 <printf>
        exit(1);
     476:	4505                	li	a0,1
     478:	00001097          	auipc	ra,0x1
     47c:	ad4080e7          	jalr	-1324(ra) # f4c <exit>
    } else if(what == 18){
      int pid = fork();
     480:	00001097          	auipc	ra,0x1
     484:	ac4080e7          	jalr	-1340(ra) # f44 <fork>
      if(pid == 0){
     488:	c909                	beqz	a0,49a <go+0x422>
        kill(getpid());
        exit(0);
      } else if(pid < 0){
     48a:	02054563          	bltz	a0,4b4 <go+0x43c>
        printf("grind: fork failed\n");
        exit(1);
      }
      wait(0);
     48e:	4501                	li	a0,0
     490:	00001097          	auipc	ra,0x1
     494:	ac4080e7          	jalr	-1340(ra) # f54 <wait>
     498:	b949                	j	12a <go+0xb2>
        kill(getpid());
     49a:	00001097          	auipc	ra,0x1
     49e:	b32080e7          	jalr	-1230(ra) # fcc <getpid>
     4a2:	00001097          	auipc	ra,0x1
     4a6:	ada080e7          	jalr	-1318(ra) # f7c <kill>
        exit(0);
     4aa:	4501                	li	a0,0
     4ac:	00001097          	auipc	ra,0x1
     4b0:	aa0080e7          	jalr	-1376(ra) # f4c <exit>
        printf("grind: fork failed\n");
     4b4:	00001517          	auipc	a0,0x1
     4b8:	38c50513          	addi	a0,a0,908 # 1840 <ithread_join+0x160>
     4bc:	00001097          	auipc	ra,0x1
     4c0:	e66080e7          	jalr	-410(ra) # 1322 <printf>
        exit(1);
     4c4:	4505                	li	a0,1
     4c6:	00001097          	auipc	ra,0x1
     4ca:	a86080e7          	jalr	-1402(ra) # f4c <exit>
    } else if(what == 19){
      int fds[2];
      if(pipe(fds) < 0){
     4ce:	fa840513          	addi	a0,s0,-88
     4d2:	00001097          	auipc	ra,0x1
     4d6:	a8a080e7          	jalr	-1398(ra) # f5c <pipe>
     4da:	02054b63          	bltz	a0,510 <go+0x498>
        printf("grind: pipe failed\n");
        exit(1);
      }
      int pid = fork();
     4de:	00001097          	auipc	ra,0x1
     4e2:	a66080e7          	jalr	-1434(ra) # f44 <fork>
      if(pid == 0){
     4e6:	c131                	beqz	a0,52a <go+0x4b2>
          printf("grind: pipe write failed\n");
        char c;
        if(read(fds[0], &c, 1) != 1)
          printf("grind: pipe read failed\n");
        exit(0);
      } else if(pid < 0){
     4e8:	0a054a63          	bltz	a0,59c <go+0x524>
        printf("grind: fork failed\n");
        exit(1);
      }
      close(fds[0]);
     4ec:	fa842503          	lw	a0,-88(s0)
     4f0:	00001097          	auipc	ra,0x1
     4f4:	a84080e7          	jalr	-1404(ra) # f74 <close>
      close(fds[1]);
     4f8:	fac42503          	lw	a0,-84(s0)
     4fc:	00001097          	auipc	ra,0x1
     500:	a78080e7          	jalr	-1416(ra) # f74 <close>
      wait(0);
     504:	4501                	li	a0,0
     506:	00001097          	auipc	ra,0x1
     50a:	a4e080e7          	jalr	-1458(ra) # f54 <wait>
     50e:	b931                	j	12a <go+0xb2>
        printf("grind: pipe failed\n");
     510:	00001517          	auipc	a0,0x1
     514:	37850513          	addi	a0,a0,888 # 1888 <ithread_join+0x1a8>
     518:	00001097          	auipc	ra,0x1
     51c:	e0a080e7          	jalr	-502(ra) # 1322 <printf>
        exit(1);
     520:	4505                	li	a0,1
     522:	00001097          	auipc	ra,0x1
     526:	a2a080e7          	jalr	-1494(ra) # f4c <exit>
        fork();
     52a:	00001097          	auipc	ra,0x1
     52e:	a1a080e7          	jalr	-1510(ra) # f44 <fork>
        fork();
     532:	00001097          	auipc	ra,0x1
     536:	a12080e7          	jalr	-1518(ra) # f44 <fork>
        if(write(fds[1], "x", 1) != 1)
     53a:	4605                	li	a2,1
     53c:	00001597          	auipc	a1,0x1
     540:	36458593          	addi	a1,a1,868 # 18a0 <ithread_join+0x1c0>
     544:	fac42503          	lw	a0,-84(s0)
     548:	00001097          	auipc	ra,0x1
     54c:	a24080e7          	jalr	-1500(ra) # f6c <write>
     550:	4785                	li	a5,1
     552:	02f51363          	bne	a0,a5,578 <go+0x500>
        if(read(fds[0], &c, 1) != 1)
     556:	4605                	li	a2,1
     558:	fa040593          	addi	a1,s0,-96
     55c:	fa842503          	lw	a0,-88(s0)
     560:	00001097          	auipc	ra,0x1
     564:	a04080e7          	jalr	-1532(ra) # f64 <read>
     568:	4785                	li	a5,1
     56a:	02f51063          	bne	a0,a5,58a <go+0x512>
        exit(0);
     56e:	4501                	li	a0,0
     570:	00001097          	auipc	ra,0x1
     574:	9dc080e7          	jalr	-1572(ra) # f4c <exit>
          printf("grind: pipe write failed\n");
     578:	00001517          	auipc	a0,0x1
     57c:	33050513          	addi	a0,a0,816 # 18a8 <ithread_join+0x1c8>
     580:	00001097          	auipc	ra,0x1
     584:	da2080e7          	jalr	-606(ra) # 1322 <printf>
     588:	b7f9                	j	556 <go+0x4de>
          printf("grind: pipe read failed\n");
     58a:	00001517          	auipc	a0,0x1
     58e:	33e50513          	addi	a0,a0,830 # 18c8 <ithread_join+0x1e8>
     592:	00001097          	auipc	ra,0x1
     596:	d90080e7          	jalr	-624(ra) # 1322 <printf>
     59a:	bfd1                	j	56e <go+0x4f6>
        printf("grind: fork failed\n");
     59c:	00001517          	auipc	a0,0x1
     5a0:	2a450513          	addi	a0,a0,676 # 1840 <ithread_join+0x160>
     5a4:	00001097          	auipc	ra,0x1
     5a8:	d7e080e7          	jalr	-642(ra) # 1322 <printf>
        exit(1);
     5ac:	4505                	li	a0,1
     5ae:	00001097          	auipc	ra,0x1
     5b2:	99e080e7          	jalr	-1634(ra) # f4c <exit>
    } else if(what == 20){
      int pid = fork();
     5b6:	00001097          	auipc	ra,0x1
     5ba:	98e080e7          	jalr	-1650(ra) # f44 <fork>
      if(pid == 0){
     5be:	c909                	beqz	a0,5d0 <go+0x558>
        chdir("a");
        unlink("../a");
        fd = open("x", O_CREATE|O_RDWR);
        unlink("x");
        exit(0);
      } else if(pid < 0){
     5c0:	06054f63          	bltz	a0,63e <go+0x5c6>
        printf("grind: fork failed\n");
        exit(1);
      }
      wait(0);
     5c4:	4501                	li	a0,0
     5c6:	00001097          	auipc	ra,0x1
     5ca:	98e080e7          	jalr	-1650(ra) # f54 <wait>
     5ce:	beb1                	j	12a <go+0xb2>
        unlink("a");
     5d0:	00001517          	auipc	a0,0x1
     5d4:	28850513          	addi	a0,a0,648 # 1858 <ithread_join+0x178>
     5d8:	00001097          	auipc	ra,0x1
     5dc:	9c4080e7          	jalr	-1596(ra) # f9c <unlink>
        mkdir("a");
     5e0:	00001517          	auipc	a0,0x1
     5e4:	27850513          	addi	a0,a0,632 # 1858 <ithread_join+0x178>
     5e8:	00001097          	auipc	ra,0x1
     5ec:	9cc080e7          	jalr	-1588(ra) # fb4 <mkdir>
        chdir("a");
     5f0:	00001517          	auipc	a0,0x1
     5f4:	26850513          	addi	a0,a0,616 # 1858 <ithread_join+0x178>
     5f8:	00001097          	auipc	ra,0x1
     5fc:	9c4080e7          	jalr	-1596(ra) # fbc <chdir>
        unlink("../a");
     600:	00001517          	auipc	a0,0x1
     604:	2e850513          	addi	a0,a0,744 # 18e8 <ithread_join+0x208>
     608:	00001097          	auipc	ra,0x1
     60c:	994080e7          	jalr	-1644(ra) # f9c <unlink>
        fd = open("x", O_CREATE|O_RDWR);
     610:	20200593          	li	a1,514
     614:	00001517          	auipc	a0,0x1
     618:	28c50513          	addi	a0,a0,652 # 18a0 <ithread_join+0x1c0>
     61c:	00001097          	auipc	ra,0x1
     620:	970080e7          	jalr	-1680(ra) # f8c <open>
        unlink("x");
     624:	00001517          	auipc	a0,0x1
     628:	27c50513          	addi	a0,a0,636 # 18a0 <ithread_join+0x1c0>
     62c:	00001097          	auipc	ra,0x1
     630:	970080e7          	jalr	-1680(ra) # f9c <unlink>
        exit(0);
     634:	4501                	li	a0,0
     636:	00001097          	auipc	ra,0x1
     63a:	916080e7          	jalr	-1770(ra) # f4c <exit>
        printf("grind: fork failed\n");
     63e:	00001517          	auipc	a0,0x1
     642:	20250513          	addi	a0,a0,514 # 1840 <ithread_join+0x160>
     646:	00001097          	auipc	ra,0x1
     64a:	cdc080e7          	jalr	-804(ra) # 1322 <printf>
        exit(1);
     64e:	4505                	li	a0,1
     650:	00001097          	auipc	ra,0x1
     654:	8fc080e7          	jalr	-1796(ra) # f4c <exit>
    } else if(what == 21){
      unlink("c");
     658:	00001517          	auipc	a0,0x1
     65c:	29850513          	addi	a0,a0,664 # 18f0 <ithread_join+0x210>
     660:	00001097          	auipc	ra,0x1
     664:	93c080e7          	jalr	-1732(ra) # f9c <unlink>
      // should always succeed. check that there are free i-nodes,
      // file descriptors, blocks.
      int fd1 = open("c", O_CREATE|O_RDWR);
     668:	20200593          	li	a1,514
     66c:	00001517          	auipc	a0,0x1
     670:	28450513          	addi	a0,a0,644 # 18f0 <ithread_join+0x210>
     674:	00001097          	auipc	ra,0x1
     678:	918080e7          	jalr	-1768(ra) # f8c <open>
     67c:	8b2a                	mv	s6,a0
      if(fd1 < 0){
     67e:	04054f63          	bltz	a0,6dc <go+0x664>
        printf("grind: create c failed\n");
        exit(1);
      }
      if(write(fd1, "x", 1) != 1){
     682:	4605                	li	a2,1
     684:	00001597          	auipc	a1,0x1
     688:	21c58593          	addi	a1,a1,540 # 18a0 <ithread_join+0x1c0>
     68c:	00001097          	auipc	ra,0x1
     690:	8e0080e7          	jalr	-1824(ra) # f6c <write>
     694:	4785                	li	a5,1
     696:	06f51063          	bne	a0,a5,6f6 <go+0x67e>
        printf("grind: write c failed\n");
        exit(1);
      }
      struct stat st;
      if(fstat(fd1, &st) != 0){
     69a:	fa840593          	addi	a1,s0,-88
     69e:	855a                	mv	a0,s6
     6a0:	00001097          	auipc	ra,0x1
     6a4:	904080e7          	jalr	-1788(ra) # fa4 <fstat>
     6a8:	e525                	bnez	a0,710 <go+0x698>
        printf("grind: fstat failed\n");
        exit(1);
      }
      if(st.size != 1){
     6aa:	fb843583          	ld	a1,-72(s0)
     6ae:	4785                	li	a5,1
     6b0:	06f59d63          	bne	a1,a5,72a <go+0x6b2>
        printf("grind: fstat reports wrong size %d\n", (int)st.size);
        exit(1);
      }
      if(st.ino > 200){
     6b4:	fac42583          	lw	a1,-84(s0)
     6b8:	0c800793          	li	a5,200
     6bc:	08b7e563          	bltu	a5,a1,746 <go+0x6ce>
        printf("grind: fstat reports crazy i-number %d\n", st.ino);
        exit(1);
      }
      close(fd1);
     6c0:	855a                	mv	a0,s6
     6c2:	00001097          	auipc	ra,0x1
     6c6:	8b2080e7          	jalr	-1870(ra) # f74 <close>
      unlink("c");
     6ca:	00001517          	auipc	a0,0x1
     6ce:	22650513          	addi	a0,a0,550 # 18f0 <ithread_join+0x210>
     6d2:	00001097          	auipc	ra,0x1
     6d6:	8ca080e7          	jalr	-1846(ra) # f9c <unlink>
     6da:	bc81                	j	12a <go+0xb2>
        printf("grind: create c failed\n");
     6dc:	00001517          	auipc	a0,0x1
     6e0:	21c50513          	addi	a0,a0,540 # 18f8 <ithread_join+0x218>
     6e4:	00001097          	auipc	ra,0x1
     6e8:	c3e080e7          	jalr	-962(ra) # 1322 <printf>
        exit(1);
     6ec:	4505                	li	a0,1
     6ee:	00001097          	auipc	ra,0x1
     6f2:	85e080e7          	jalr	-1954(ra) # f4c <exit>
        printf("grind: write c failed\n");
     6f6:	00001517          	auipc	a0,0x1
     6fa:	21a50513          	addi	a0,a0,538 # 1910 <ithread_join+0x230>
     6fe:	00001097          	auipc	ra,0x1
     702:	c24080e7          	jalr	-988(ra) # 1322 <printf>
        exit(1);
     706:	4505                	li	a0,1
     708:	00001097          	auipc	ra,0x1
     70c:	844080e7          	jalr	-1980(ra) # f4c <exit>
        printf("grind: fstat failed\n");
     710:	00001517          	auipc	a0,0x1
     714:	21850513          	addi	a0,a0,536 # 1928 <ithread_join+0x248>
     718:	00001097          	auipc	ra,0x1
     71c:	c0a080e7          	jalr	-1014(ra) # 1322 <printf>
        exit(1);
     720:	4505                	li	a0,1
     722:	00001097          	auipc	ra,0x1
     726:	82a080e7          	jalr	-2006(ra) # f4c <exit>
        printf("grind: fstat reports wrong size %d\n", (int)st.size);
     72a:	2581                	sext.w	a1,a1
     72c:	00001517          	auipc	a0,0x1
     730:	21450513          	addi	a0,a0,532 # 1940 <ithread_join+0x260>
     734:	00001097          	auipc	ra,0x1
     738:	bee080e7          	jalr	-1042(ra) # 1322 <printf>
        exit(1);
     73c:	4505                	li	a0,1
     73e:	00001097          	auipc	ra,0x1
     742:	80e080e7          	jalr	-2034(ra) # f4c <exit>
        printf("grind: fstat reports crazy i-number %d\n", st.ino);
     746:	00001517          	auipc	a0,0x1
     74a:	22250513          	addi	a0,a0,546 # 1968 <ithread_join+0x288>
     74e:	00001097          	auipc	ra,0x1
     752:	bd4080e7          	jalr	-1068(ra) # 1322 <printf>
        exit(1);
     756:	4505                	li	a0,1
     758:	00000097          	auipc	ra,0x0
     75c:	7f4080e7          	jalr	2036(ra) # f4c <exit>
    } else if(what == 22){
      // echo hi | cat
      int aa[2], bb[2];
      if(pipe(aa) < 0){
     760:	f9840513          	addi	a0,s0,-104
     764:	00000097          	auipc	ra,0x0
     768:	7f8080e7          	jalr	2040(ra) # f5c <pipe>
     76c:	10054063          	bltz	a0,86c <go+0x7f4>
        fprintf(2, "grind: pipe failed\n");
        exit(1);
      }
      if(pipe(bb) < 0){
     770:	fa040513          	addi	a0,s0,-96
     774:	00000097          	auipc	ra,0x0
     778:	7e8080e7          	jalr	2024(ra) # f5c <pipe>
     77c:	10054663          	bltz	a0,888 <go+0x810>
        fprintf(2, "grind: pipe failed\n");
        exit(1);
      }
      int pid1 = fork();
     780:	00000097          	auipc	ra,0x0
     784:	7c4080e7          	jalr	1988(ra) # f44 <fork>
      if(pid1 == 0){
     788:	10050e63          	beqz	a0,8a4 <go+0x82c>
        close(aa[1]);
        char *args[3] = { "echo", "hi", 0 };
        exec("grindir/../echo", args);
        fprintf(2, "grind: echo: not found\n");
        exit(2);
      } else if(pid1 < 0){
     78c:	1c054663          	bltz	a0,958 <go+0x8e0>
        fprintf(2, "grind: fork failed\n");
        exit(3);
      }
      int pid2 = fork();
     790:	00000097          	auipc	ra,0x0
     794:	7b4080e7          	jalr	1972(ra) # f44 <fork>
      if(pid2 == 0){
     798:	1c050e63          	beqz	a0,974 <go+0x8fc>
        close(bb[1]);
        char *args[2] = { "cat", 0 };
        exec("/cat", args);
        fprintf(2, "grind: cat: not found\n");
        exit(6);
      } else if(pid2 < 0){
     79c:	2a054a63          	bltz	a0,a50 <go+0x9d8>
        fprintf(2, "grind: fork failed\n");
        exit(7);
      }
      close(aa[0]);
     7a0:	f9842503          	lw	a0,-104(s0)
     7a4:	00000097          	auipc	ra,0x0
     7a8:	7d0080e7          	jalr	2000(ra) # f74 <close>
      close(aa[1]);
     7ac:	f9c42503          	lw	a0,-100(s0)
     7b0:	00000097          	auipc	ra,0x0
     7b4:	7c4080e7          	jalr	1988(ra) # f74 <close>
      close(bb[1]);
     7b8:	fa442503          	lw	a0,-92(s0)
     7bc:	00000097          	auipc	ra,0x0
     7c0:	7b8080e7          	jalr	1976(ra) # f74 <close>
      char buf[4] = { 0, 0, 0, 0 };
     7c4:	f8042823          	sw	zero,-112(s0)
      read(bb[0], buf+0, 1);
     7c8:	4605                	li	a2,1
     7ca:	f9040593          	addi	a1,s0,-112
     7ce:	fa042503          	lw	a0,-96(s0)
     7d2:	00000097          	auipc	ra,0x0
     7d6:	792080e7          	jalr	1938(ra) # f64 <read>
      read(bb[0], buf+1, 1);
     7da:	4605                	li	a2,1
     7dc:	f9140593          	addi	a1,s0,-111
     7e0:	fa042503          	lw	a0,-96(s0)
     7e4:	00000097          	auipc	ra,0x0
     7e8:	780080e7          	jalr	1920(ra) # f64 <read>
      read(bb[0], buf+2, 1);
     7ec:	4605                	li	a2,1
     7ee:	f9240593          	addi	a1,s0,-110
     7f2:	fa042503          	lw	a0,-96(s0)
     7f6:	00000097          	auipc	ra,0x0
     7fa:	76e080e7          	jalr	1902(ra) # f64 <read>
      close(bb[0]);
     7fe:	fa042503          	lw	a0,-96(s0)
     802:	00000097          	auipc	ra,0x0
     806:	772080e7          	jalr	1906(ra) # f74 <close>
      int st1, st2;
      wait(&st1);
     80a:	f9440513          	addi	a0,s0,-108
     80e:	00000097          	auipc	ra,0x0
     812:	746080e7          	jalr	1862(ra) # f54 <wait>
      wait(&st2);
     816:	fa840513          	addi	a0,s0,-88
     81a:	00000097          	auipc	ra,0x0
     81e:	73a080e7          	jalr	1850(ra) # f54 <wait>
      if(st1 != 0 || st2 != 0 || strcmp(buf, "hi\n") != 0){
     822:	f9442783          	lw	a5,-108(s0)
     826:	fa842703          	lw	a4,-88(s0)
     82a:	8fd9                	or	a5,a5,a4
     82c:	ef89                	bnez	a5,846 <go+0x7ce>
     82e:	00001597          	auipc	a1,0x1
     832:	1da58593          	addi	a1,a1,474 # 1a08 <ithread_join+0x328>
     836:	f9040513          	addi	a0,s0,-112
     83a:	00000097          	auipc	ra,0x0
     83e:	3b6080e7          	jalr	950(ra) # bf0 <strcmp>
     842:	8e0504e3          	beqz	a0,12a <go+0xb2>
        printf("grind: exec pipeline failed %d %d \"%s\"\n", st1, st2, buf);
     846:	f9040693          	addi	a3,s0,-112
     84a:	fa842603          	lw	a2,-88(s0)
     84e:	f9442583          	lw	a1,-108(s0)
     852:	00001517          	auipc	a0,0x1
     856:	1be50513          	addi	a0,a0,446 # 1a10 <ithread_join+0x330>
     85a:	00001097          	auipc	ra,0x1
     85e:	ac8080e7          	jalr	-1336(ra) # 1322 <printf>
        exit(1);
     862:	4505                	li	a0,1
     864:	00000097          	auipc	ra,0x0
     868:	6e8080e7          	jalr	1768(ra) # f4c <exit>
        fprintf(2, "grind: pipe failed\n");
     86c:	00001597          	auipc	a1,0x1
     870:	01c58593          	addi	a1,a1,28 # 1888 <ithread_join+0x1a8>
     874:	4509                	li	a0,2
     876:	00001097          	auipc	ra,0x1
     87a:	a7e080e7          	jalr	-1410(ra) # 12f4 <fprintf>
        exit(1);
     87e:	4505                	li	a0,1
     880:	00000097          	auipc	ra,0x0
     884:	6cc080e7          	jalr	1740(ra) # f4c <exit>
        fprintf(2, "grind: pipe failed\n");
     888:	00001597          	auipc	a1,0x1
     88c:	00058593          	mv	a1,a1
     890:	4509                	li	a0,2
     892:	00001097          	auipc	ra,0x1
     896:	a62080e7          	jalr	-1438(ra) # 12f4 <fprintf>
        exit(1);
     89a:	4505                	li	a0,1
     89c:	00000097          	auipc	ra,0x0
     8a0:	6b0080e7          	jalr	1712(ra) # f4c <exit>
        close(bb[0]);
     8a4:	fa042503          	lw	a0,-96(s0)
     8a8:	00000097          	auipc	ra,0x0
     8ac:	6cc080e7          	jalr	1740(ra) # f74 <close>
        close(bb[1]);
     8b0:	fa442503          	lw	a0,-92(s0)
     8b4:	00000097          	auipc	ra,0x0
     8b8:	6c0080e7          	jalr	1728(ra) # f74 <close>
        close(aa[0]);
     8bc:	f9842503          	lw	a0,-104(s0)
     8c0:	00000097          	auipc	ra,0x0
     8c4:	6b4080e7          	jalr	1716(ra) # f74 <close>
        close(1);
     8c8:	4505                	li	a0,1
     8ca:	00000097          	auipc	ra,0x0
     8ce:	6aa080e7          	jalr	1706(ra) # f74 <close>
        if(dup(aa[1]) != 1){
     8d2:	f9c42503          	lw	a0,-100(s0)
     8d6:	00000097          	auipc	ra,0x0
     8da:	6ee080e7          	jalr	1774(ra) # fc4 <dup>
     8de:	4785                	li	a5,1
     8e0:	02f50063          	beq	a0,a5,900 <go+0x888>
          fprintf(2, "grind: dup failed\n");
     8e4:	00001597          	auipc	a1,0x1
     8e8:	0ac58593          	addi	a1,a1,172 # 1990 <ithread_join+0x2b0>
     8ec:	4509                	li	a0,2
     8ee:	00001097          	auipc	ra,0x1
     8f2:	a06080e7          	jalr	-1530(ra) # 12f4 <fprintf>
          exit(1);
     8f6:	4505                	li	a0,1
     8f8:	00000097          	auipc	ra,0x0
     8fc:	654080e7          	jalr	1620(ra) # f4c <exit>
        close(aa[1]);
     900:	f9c42503          	lw	a0,-100(s0)
     904:	00000097          	auipc	ra,0x0
     908:	670080e7          	jalr	1648(ra) # f74 <close>
        char *args[3] = { "echo", "hi", 0 };
     90c:	00001797          	auipc	a5,0x1
     910:	09c78793          	addi	a5,a5,156 # 19a8 <ithread_join+0x2c8>
     914:	faf43423          	sd	a5,-88(s0)
     918:	00001797          	auipc	a5,0x1
     91c:	09878793          	addi	a5,a5,152 # 19b0 <ithread_join+0x2d0>
     920:	faf43823          	sd	a5,-80(s0)
     924:	fa043c23          	sd	zero,-72(s0)
        exec("grindir/../echo", args);
     928:	fa840593          	addi	a1,s0,-88
     92c:	00001517          	auipc	a0,0x1
     930:	08c50513          	addi	a0,a0,140 # 19b8 <ithread_join+0x2d8>
     934:	00000097          	auipc	ra,0x0
     938:	650080e7          	jalr	1616(ra) # f84 <exec>
        fprintf(2, "grind: echo: not found\n");
     93c:	00001597          	auipc	a1,0x1
     940:	08c58593          	addi	a1,a1,140 # 19c8 <ithread_join+0x2e8>
     944:	4509                	li	a0,2
     946:	00001097          	auipc	ra,0x1
     94a:	9ae080e7          	jalr	-1618(ra) # 12f4 <fprintf>
        exit(2);
     94e:	4509                	li	a0,2
     950:	00000097          	auipc	ra,0x0
     954:	5fc080e7          	jalr	1532(ra) # f4c <exit>
        fprintf(2, "grind: fork failed\n");
     958:	00001597          	auipc	a1,0x1
     95c:	ee858593          	addi	a1,a1,-280 # 1840 <ithread_join+0x160>
     960:	4509                	li	a0,2
     962:	00001097          	auipc	ra,0x1
     966:	992080e7          	jalr	-1646(ra) # 12f4 <fprintf>
        exit(3);
     96a:	450d                	li	a0,3
     96c:	00000097          	auipc	ra,0x0
     970:	5e0080e7          	jalr	1504(ra) # f4c <exit>
        close(aa[1]);
     974:	f9c42503          	lw	a0,-100(s0)
     978:	00000097          	auipc	ra,0x0
     97c:	5fc080e7          	jalr	1532(ra) # f74 <close>
        close(bb[0]);
     980:	fa042503          	lw	a0,-96(s0)
     984:	00000097          	auipc	ra,0x0
     988:	5f0080e7          	jalr	1520(ra) # f74 <close>
        close(0);
     98c:	4501                	li	a0,0
     98e:	00000097          	auipc	ra,0x0
     992:	5e6080e7          	jalr	1510(ra) # f74 <close>
        if(dup(aa[0]) != 0){
     996:	f9842503          	lw	a0,-104(s0)
     99a:	00000097          	auipc	ra,0x0
     99e:	62a080e7          	jalr	1578(ra) # fc4 <dup>
     9a2:	cd19                	beqz	a0,9c0 <go+0x948>
          fprintf(2, "grind: dup failed\n");
     9a4:	00001597          	auipc	a1,0x1
     9a8:	fec58593          	addi	a1,a1,-20 # 1990 <ithread_join+0x2b0>
     9ac:	4509                	li	a0,2
     9ae:	00001097          	auipc	ra,0x1
     9b2:	946080e7          	jalr	-1722(ra) # 12f4 <fprintf>
          exit(4);
     9b6:	4511                	li	a0,4
     9b8:	00000097          	auipc	ra,0x0
     9bc:	594080e7          	jalr	1428(ra) # f4c <exit>
        close(aa[0]);
     9c0:	f9842503          	lw	a0,-104(s0)
     9c4:	00000097          	auipc	ra,0x0
     9c8:	5b0080e7          	jalr	1456(ra) # f74 <close>
        close(1);
     9cc:	4505                	li	a0,1
     9ce:	00000097          	auipc	ra,0x0
     9d2:	5a6080e7          	jalr	1446(ra) # f74 <close>
        if(dup(bb[1]) != 1){
     9d6:	fa442503          	lw	a0,-92(s0)
     9da:	00000097          	auipc	ra,0x0
     9de:	5ea080e7          	jalr	1514(ra) # fc4 <dup>
     9e2:	4785                	li	a5,1
     9e4:	02f50063          	beq	a0,a5,a04 <go+0x98c>
          fprintf(2, "grind: dup failed\n");
     9e8:	00001597          	auipc	a1,0x1
     9ec:	fa858593          	addi	a1,a1,-88 # 1990 <ithread_join+0x2b0>
     9f0:	4509                	li	a0,2
     9f2:	00001097          	auipc	ra,0x1
     9f6:	902080e7          	jalr	-1790(ra) # 12f4 <fprintf>
          exit(5);
     9fa:	4515                	li	a0,5
     9fc:	00000097          	auipc	ra,0x0
     a00:	550080e7          	jalr	1360(ra) # f4c <exit>
        close(bb[1]);
     a04:	fa442503          	lw	a0,-92(s0)
     a08:	00000097          	auipc	ra,0x0
     a0c:	56c080e7          	jalr	1388(ra) # f74 <close>
        char *args[2] = { "cat", 0 };
     a10:	00001797          	auipc	a5,0x1
     a14:	fd078793          	addi	a5,a5,-48 # 19e0 <ithread_join+0x300>
     a18:	faf43423          	sd	a5,-88(s0)
     a1c:	fa043823          	sd	zero,-80(s0)
        exec("/cat", args);
     a20:	fa840593          	addi	a1,s0,-88
     a24:	00001517          	auipc	a0,0x1
     a28:	fc450513          	addi	a0,a0,-60 # 19e8 <ithread_join+0x308>
     a2c:	00000097          	auipc	ra,0x0
     a30:	558080e7          	jalr	1368(ra) # f84 <exec>
        fprintf(2, "grind: cat: not found\n");
     a34:	00001597          	auipc	a1,0x1
     a38:	fbc58593          	addi	a1,a1,-68 # 19f0 <ithread_join+0x310>
     a3c:	4509                	li	a0,2
     a3e:	00001097          	auipc	ra,0x1
     a42:	8b6080e7          	jalr	-1866(ra) # 12f4 <fprintf>
        exit(6);
     a46:	4519                	li	a0,6
     a48:	00000097          	auipc	ra,0x0
     a4c:	504080e7          	jalr	1284(ra) # f4c <exit>
        fprintf(2, "grind: fork failed\n");
     a50:	00001597          	auipc	a1,0x1
     a54:	df058593          	addi	a1,a1,-528 # 1840 <ithread_join+0x160>
     a58:	4509                	li	a0,2
     a5a:	00001097          	auipc	ra,0x1
     a5e:	89a080e7          	jalr	-1894(ra) # 12f4 <fprintf>
        exit(7);
     a62:	451d                	li	a0,7
     a64:	00000097          	auipc	ra,0x0
     a68:	4e8080e7          	jalr	1256(ra) # f4c <exit>

0000000000000a6c <iter>:
  }
}

void
iter()
{
     a6c:	7179                	addi	sp,sp,-48
     a6e:	f406                	sd	ra,40(sp)
     a70:	f022                	sd	s0,32(sp)
     a72:	1800                	addi	s0,sp,48
  unlink("a");
     a74:	00001517          	auipc	a0,0x1
     a78:	de450513          	addi	a0,a0,-540 # 1858 <ithread_join+0x178>
     a7c:	00000097          	auipc	ra,0x0
     a80:	520080e7          	jalr	1312(ra) # f9c <unlink>
  unlink("b");
     a84:	00001517          	auipc	a0,0x1
     a88:	d8450513          	addi	a0,a0,-636 # 1808 <ithread_join+0x128>
     a8c:	00000097          	auipc	ra,0x0
     a90:	510080e7          	jalr	1296(ra) # f9c <unlink>
  
  int pid1 = fork();
     a94:	00000097          	auipc	ra,0x0
     a98:	4b0080e7          	jalr	1200(ra) # f44 <fork>
  if(pid1 < 0){
     a9c:	02054363          	bltz	a0,ac2 <iter+0x56>
     aa0:	ec26                	sd	s1,24(sp)
     aa2:	84aa                	mv	s1,a0
    printf("grind: fork failed\n");
    exit(1);
  }
  if(pid1 == 0){
     aa4:	ed15                	bnez	a0,ae0 <iter+0x74>
     aa6:	e84a                	sd	s2,16(sp)
    rand_next ^= 31;
     aa8:	00001717          	auipc	a4,0x1
     aac:	55870713          	addi	a4,a4,1368 # 2000 <rand_next>
     ab0:	631c                	ld	a5,0(a4)
     ab2:	01f7c793          	xori	a5,a5,31
     ab6:	e31c                	sd	a5,0(a4)
    go(0);
     ab8:	4501                	li	a0,0
     aba:	fffff097          	auipc	ra,0xfffff
     abe:	5be080e7          	jalr	1470(ra) # 78 <go>
     ac2:	ec26                	sd	s1,24(sp)
     ac4:	e84a                	sd	s2,16(sp)
    printf("grind: fork failed\n");
     ac6:	00001517          	auipc	a0,0x1
     aca:	d7a50513          	addi	a0,a0,-646 # 1840 <ithread_join+0x160>
     ace:	00001097          	auipc	ra,0x1
     ad2:	854080e7          	jalr	-1964(ra) # 1322 <printf>
    exit(1);
     ad6:	4505                	li	a0,1
     ad8:	00000097          	auipc	ra,0x0
     adc:	474080e7          	jalr	1140(ra) # f4c <exit>
     ae0:	e84a                	sd	s2,16(sp)
    exit(0);
  }

  int pid2 = fork();
     ae2:	00000097          	auipc	ra,0x0
     ae6:	462080e7          	jalr	1122(ra) # f44 <fork>
     aea:	892a                	mv	s2,a0
  if(pid2 < 0){
     aec:	02054263          	bltz	a0,b10 <iter+0xa4>
    printf("grind: fork failed\n");
    exit(1);
  }
  if(pid2 == 0){
     af0:	ed0d                	bnez	a0,b2a <iter+0xbe>
    rand_next ^= 7177;
     af2:	00001697          	auipc	a3,0x1
     af6:	50e68693          	addi	a3,a3,1294 # 2000 <rand_next>
     afa:	629c                	ld	a5,0(a3)
     afc:	6709                	lui	a4,0x2
     afe:	c0970713          	addi	a4,a4,-1015 # 1c09 <digits+0xe9>
     b02:	8fb9                	xor	a5,a5,a4
     b04:	e29c                	sd	a5,0(a3)
    go(1);
     b06:	4505                	li	a0,1
     b08:	fffff097          	auipc	ra,0xfffff
     b0c:	570080e7          	jalr	1392(ra) # 78 <go>
    printf("grind: fork failed\n");
     b10:	00001517          	auipc	a0,0x1
     b14:	d3050513          	addi	a0,a0,-720 # 1840 <ithread_join+0x160>
     b18:	00001097          	auipc	ra,0x1
     b1c:	80a080e7          	jalr	-2038(ra) # 1322 <printf>
    exit(1);
     b20:	4505                	li	a0,1
     b22:	00000097          	auipc	ra,0x0
     b26:	42a080e7          	jalr	1066(ra) # f4c <exit>
    exit(0);
  }

  int st1 = -1;
     b2a:	57fd                	li	a5,-1
     b2c:	fcf42e23          	sw	a5,-36(s0)
  wait(&st1);
     b30:	fdc40513          	addi	a0,s0,-36
     b34:	00000097          	auipc	ra,0x0
     b38:	420080e7          	jalr	1056(ra) # f54 <wait>
  if(st1 != 0){
     b3c:	fdc42783          	lw	a5,-36(s0)
     b40:	ef99                	bnez	a5,b5e <iter+0xf2>
    kill(pid1);
    kill(pid2);
  }
  int st2 = -1;
     b42:	57fd                	li	a5,-1
     b44:	fcf42c23          	sw	a5,-40(s0)
  wait(&st2);
     b48:	fd840513          	addi	a0,s0,-40
     b4c:	00000097          	auipc	ra,0x0
     b50:	408080e7          	jalr	1032(ra) # f54 <wait>

  exit(0);
     b54:	4501                	li	a0,0
     b56:	00000097          	auipc	ra,0x0
     b5a:	3f6080e7          	jalr	1014(ra) # f4c <exit>
    kill(pid1);
     b5e:	8526                	mv	a0,s1
     b60:	00000097          	auipc	ra,0x0
     b64:	41c080e7          	jalr	1052(ra) # f7c <kill>
    kill(pid2);
     b68:	854a                	mv	a0,s2
     b6a:	00000097          	auipc	ra,0x0
     b6e:	412080e7          	jalr	1042(ra) # f7c <kill>
     b72:	bfc1                	j	b42 <iter+0xd6>

0000000000000b74 <main>:
}

int
main()
{
     b74:	1101                	addi	sp,sp,-32
     b76:	ec06                	sd	ra,24(sp)
     b78:	e822                	sd	s0,16(sp)
     b7a:	e426                	sd	s1,8(sp)
     b7c:	1000                	addi	s0,sp,32
    }
    if(pid > 0){
      wait(0);
    }
    sleep(20);
    rand_next += 1;
     b7e:	00001497          	auipc	s1,0x1
     b82:	48248493          	addi	s1,s1,1154 # 2000 <rand_next>
     b86:	a829                	j	ba0 <main+0x2c>
      iter();
     b88:	00000097          	auipc	ra,0x0
     b8c:	ee4080e7          	jalr	-284(ra) # a6c <iter>
    sleep(20);
     b90:	4551                	li	a0,20
     b92:	00000097          	auipc	ra,0x0
     b96:	44a080e7          	jalr	1098(ra) # fdc <sleep>
    rand_next += 1;
     b9a:	609c                	ld	a5,0(s1)
     b9c:	0785                	addi	a5,a5,1
     b9e:	e09c                	sd	a5,0(s1)
    int pid = fork();
     ba0:	00000097          	auipc	ra,0x0
     ba4:	3a4080e7          	jalr	932(ra) # f44 <fork>
    if(pid == 0){
     ba8:	d165                	beqz	a0,b88 <main+0x14>
    if(pid > 0){
     baa:	fea053e3          	blez	a0,b90 <main+0x1c>
      wait(0);
     bae:	4501                	li	a0,0
     bb0:	00000097          	auipc	ra,0x0
     bb4:	3a4080e7          	jalr	932(ra) # f54 <wait>
     bb8:	bfe1                	j	b90 <main+0x1c>

0000000000000bba <_main>:
//
// wrapper so that it's OK if main() does not call exit().
//
void
_main()
{
     bba:	1141                	addi	sp,sp,-16
     bbc:	e406                	sd	ra,8(sp)
     bbe:	e022                	sd	s0,0(sp)
     bc0:	0800                	addi	s0,sp,16
  extern int main();
  main();
     bc2:	00000097          	auipc	ra,0x0
     bc6:	fb2080e7          	jalr	-78(ra) # b74 <main>
  exit(0);
     bca:	4501                	li	a0,0
     bcc:	00000097          	auipc	ra,0x0
     bd0:	380080e7          	jalr	896(ra) # f4c <exit>

0000000000000bd4 <strcpy>:
}

char*
strcpy(char *s, const char *t)
{
     bd4:	1141                	addi	sp,sp,-16
     bd6:	e422                	sd	s0,8(sp)
     bd8:	0800                	addi	s0,sp,16
  char *os;

  os = s;
  while((*s++ = *t++) != 0)
     bda:	87aa                	mv	a5,a0
     bdc:	0585                	addi	a1,a1,1
     bde:	0785                	addi	a5,a5,1
     be0:	fff5c703          	lbu	a4,-1(a1)
     be4:	fee78fa3          	sb	a4,-1(a5)
     be8:	fb75                	bnez	a4,bdc <strcpy+0x8>
    ;
  return os;
}
     bea:	6422                	ld	s0,8(sp)
     bec:	0141                	addi	sp,sp,16
     bee:	8082                	ret

0000000000000bf0 <strcmp>:

int
strcmp(const char *p, const char *q)
{
     bf0:	1141                	addi	sp,sp,-16
     bf2:	e422                	sd	s0,8(sp)
     bf4:	0800                	addi	s0,sp,16
  while(*p && *p == *q)
     bf6:	00054783          	lbu	a5,0(a0)
     bfa:	cb91                	beqz	a5,c0e <strcmp+0x1e>
     bfc:	0005c703          	lbu	a4,0(a1)
     c00:	00f71763          	bne	a4,a5,c0e <strcmp+0x1e>
    p++, q++;
     c04:	0505                	addi	a0,a0,1
     c06:	0585                	addi	a1,a1,1
  while(*p && *p == *q)
     c08:	00054783          	lbu	a5,0(a0)
     c0c:	fbe5                	bnez	a5,bfc <strcmp+0xc>
  return (uchar)*p - (uchar)*q;
     c0e:	0005c503          	lbu	a0,0(a1)
}
     c12:	40a7853b          	subw	a0,a5,a0
     c16:	6422                	ld	s0,8(sp)
     c18:	0141                	addi	sp,sp,16
     c1a:	8082                	ret

0000000000000c1c <strlen>:

uint
strlen(const char *s)
{
     c1c:	1141                	addi	sp,sp,-16
     c1e:	e422                	sd	s0,8(sp)
     c20:	0800                	addi	s0,sp,16
  int n;

  for(n = 0; s[n]; n++)
     c22:	00054783          	lbu	a5,0(a0)
     c26:	cf91                	beqz	a5,c42 <strlen+0x26>
     c28:	0505                	addi	a0,a0,1
     c2a:	87aa                	mv	a5,a0
     c2c:	86be                	mv	a3,a5
     c2e:	0785                	addi	a5,a5,1
     c30:	fff7c703          	lbu	a4,-1(a5)
     c34:	ff65                	bnez	a4,c2c <strlen+0x10>
     c36:	40a6853b          	subw	a0,a3,a0
     c3a:	2505                	addiw	a0,a0,1
    ;
  return n;
}
     c3c:	6422                	ld	s0,8(sp)
     c3e:	0141                	addi	sp,sp,16
     c40:	8082                	ret
  for(n = 0; s[n]; n++)
     c42:	4501                	li	a0,0
     c44:	bfe5                	j	c3c <strlen+0x20>

0000000000000c46 <memset>:

void*
memset(void *dst, int c, uint n)
{
     c46:	1141                	addi	sp,sp,-16
     c48:	e422                	sd	s0,8(sp)
     c4a:	0800                	addi	s0,sp,16
  char *cdst = (char *) dst;
  int i;
  for(i = 0; i < n; i++){
     c4c:	ca19                	beqz	a2,c62 <memset+0x1c>
     c4e:	87aa                	mv	a5,a0
     c50:	1602                	slli	a2,a2,0x20
     c52:	9201                	srli	a2,a2,0x20
     c54:	00a60733          	add	a4,a2,a0
    cdst[i] = c;
     c58:	00b78023          	sb	a1,0(a5)
  for(i = 0; i < n; i++){
     c5c:	0785                	addi	a5,a5,1
     c5e:	fee79de3          	bne	a5,a4,c58 <memset+0x12>
  }
  return dst;
}
     c62:	6422                	ld	s0,8(sp)
     c64:	0141                	addi	sp,sp,16
     c66:	8082                	ret

0000000000000c68 <strchr>:

char*
strchr(const char *s, char c)
{
     c68:	1141                	addi	sp,sp,-16
     c6a:	e422                	sd	s0,8(sp)
     c6c:	0800                	addi	s0,sp,16
  for(; *s; s++)
     c6e:	00054783          	lbu	a5,0(a0)
     c72:	cb99                	beqz	a5,c88 <strchr+0x20>
    if(*s == c)
     c74:	00f58763          	beq	a1,a5,c82 <strchr+0x1a>
  for(; *s; s++)
     c78:	0505                	addi	a0,a0,1
     c7a:	00054783          	lbu	a5,0(a0)
     c7e:	fbfd                	bnez	a5,c74 <strchr+0xc>
      return (char*)s;
  return 0;
     c80:	4501                	li	a0,0
}
     c82:	6422                	ld	s0,8(sp)
     c84:	0141                	addi	sp,sp,16
     c86:	8082                	ret
  return 0;
     c88:	4501                	li	a0,0
     c8a:	bfe5                	j	c82 <strchr+0x1a>

0000000000000c8c <gets>:

char*
gets(char *buf, int max)
{
     c8c:	711d                	addi	sp,sp,-96
     c8e:	ec86                	sd	ra,88(sp)
     c90:	e8a2                	sd	s0,80(sp)
     c92:	e4a6                	sd	s1,72(sp)
     c94:	e0ca                	sd	s2,64(sp)
     c96:	fc4e                	sd	s3,56(sp)
     c98:	f852                	sd	s4,48(sp)
     c9a:	f456                	sd	s5,40(sp)
     c9c:	f05a                	sd	s6,32(sp)
     c9e:	ec5e                	sd	s7,24(sp)
     ca0:	1080                	addi	s0,sp,96
     ca2:	8baa                	mv	s7,a0
     ca4:	8a2e                	mv	s4,a1
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
     ca6:	892a                	mv	s2,a0
     ca8:	4481                	li	s1,0
    cc = read(0, &c, 1);
    if(cc < 1)
      break;
    buf[i++] = c;
    if(c == '\n' || c == '\r')
     caa:	4aa9                	li	s5,10
     cac:	4b35                	li	s6,13
  for(i=0; i+1 < max; ){
     cae:	89a6                	mv	s3,s1
     cb0:	2485                	addiw	s1,s1,1
     cb2:	0344d863          	bge	s1,s4,ce2 <gets+0x56>
    cc = read(0, &c, 1);
     cb6:	4605                	li	a2,1
     cb8:	faf40593          	addi	a1,s0,-81
     cbc:	4501                	li	a0,0
     cbe:	00000097          	auipc	ra,0x0
     cc2:	2a6080e7          	jalr	678(ra) # f64 <read>
    if(cc < 1)
     cc6:	00a05e63          	blez	a0,ce2 <gets+0x56>
    buf[i++] = c;
     cca:	faf44783          	lbu	a5,-81(s0)
     cce:	00f90023          	sb	a5,0(s2)
    if(c == '\n' || c == '\r')
     cd2:	01578763          	beq	a5,s5,ce0 <gets+0x54>
     cd6:	0905                	addi	s2,s2,1
     cd8:	fd679be3          	bne	a5,s6,cae <gets+0x22>
    buf[i++] = c;
     cdc:	89a6                	mv	s3,s1
     cde:	a011                	j	ce2 <gets+0x56>
     ce0:	89a6                	mv	s3,s1
      break;
  }
  buf[i] = '\0';
     ce2:	99de                	add	s3,s3,s7
     ce4:	00098023          	sb	zero,0(s3)
  return buf;
}
     ce8:	855e                	mv	a0,s7
     cea:	60e6                	ld	ra,88(sp)
     cec:	6446                	ld	s0,80(sp)
     cee:	64a6                	ld	s1,72(sp)
     cf0:	6906                	ld	s2,64(sp)
     cf2:	79e2                	ld	s3,56(sp)
     cf4:	7a42                	ld	s4,48(sp)
     cf6:	7aa2                	ld	s5,40(sp)
     cf8:	7b02                	ld	s6,32(sp)
     cfa:	6be2                	ld	s7,24(sp)
     cfc:	6125                	addi	sp,sp,96
     cfe:	8082                	ret

0000000000000d00 <fgetstdin>:

int
fgetstdin(char *buf, int size) {
     d00:	711d                	addi	sp,sp,-96
     d02:	ec86                	sd	ra,88(sp)
     d04:	e8a2                	sd	s0,80(sp)
     d06:	e4a6                	sd	s1,72(sp)
     d08:	e0ca                	sd	s2,64(sp)
     d0a:	fc4e                	sd	s3,56(sp)
     d0c:	f852                	sd	s4,48(sp)
     d0e:	f456                	sd	s5,40(sp)
     d10:	f05a                	sd	s6,32(sp)
     d12:	ec5e                	sd	s7,24(sp)
     d14:	1080                	addi	s0,sp,96
     d16:	8baa                	mv	s7,a0
     d18:	89ae                	mv	s3,a1
  int i, cc;
  char c;

  for(i=0; i+1 < size; ){
     d1a:	892a                	mv	s2,a0
     d1c:	4481                	li	s1,0
    cc = read(0, &c, 1);
    if(cc < 1)
      break;
    buf[i++] = c;
    if(c == '\n' || c == '\r')
     d1e:	4aa9                	li	s5,10
     d20:	4b35                	li	s6,13
  for(i=0; i+1 < size; ){
     d22:	8a26                	mv	s4,s1
     d24:	2485                	addiw	s1,s1,1
     d26:	0334d863          	bge	s1,s3,d56 <fgetstdin+0x56>
    cc = read(0, &c, 1);
     d2a:	4605                	li	a2,1
     d2c:	faf40593          	addi	a1,s0,-81
     d30:	4501                	li	a0,0
     d32:	00000097          	auipc	ra,0x0
     d36:	232080e7          	jalr	562(ra) # f64 <read>
    if(cc < 1)
     d3a:	00a05e63          	blez	a0,d56 <fgetstdin+0x56>
    buf[i++] = c;
     d3e:	faf44783          	lbu	a5,-81(s0)
     d42:	00f90023          	sb	a5,0(s2)
    if(c == '\n' || c == '\r')
     d46:	01578763          	beq	a5,s5,d54 <fgetstdin+0x54>
     d4a:	0905                	addi	s2,s2,1
     d4c:	fd679be3          	bne	a5,s6,d22 <fgetstdin+0x22>
    buf[i++] = c;
     d50:	8a26                	mv	s4,s1
     d52:	a011                	j	d56 <fgetstdin+0x56>
     d54:	8a26                	mv	s4,s1
      break;
  }
  buf[i] = '\0';
     d56:	9bd2                	add	s7,s7,s4
     d58:	000b8023          	sb	zero,0(s7)
  return i;
}
     d5c:	8552                	mv	a0,s4
     d5e:	60e6                	ld	ra,88(sp)
     d60:	6446                	ld	s0,80(sp)
     d62:	64a6                	ld	s1,72(sp)
     d64:	6906                	ld	s2,64(sp)
     d66:	79e2                	ld	s3,56(sp)
     d68:	7a42                	ld	s4,48(sp)
     d6a:	7aa2                	ld	s5,40(sp)
     d6c:	7b02                	ld	s6,32(sp)
     d6e:	6be2                	ld	s7,24(sp)
     d70:	6125                	addi	sp,sp,96
     d72:	8082                	ret

0000000000000d74 <stat>:

int
stat(const char *n, struct stat *st)
{
     d74:	1101                	addi	sp,sp,-32
     d76:	ec06                	sd	ra,24(sp)
     d78:	e822                	sd	s0,16(sp)
     d7a:	e04a                	sd	s2,0(sp)
     d7c:	1000                	addi	s0,sp,32
     d7e:	892e                	mv	s2,a1
  int fd;
  int r;

  fd = open(n, O_RDONLY);
     d80:	4581                	li	a1,0
     d82:	00000097          	auipc	ra,0x0
     d86:	20a080e7          	jalr	522(ra) # f8c <open>
  if(fd < 0)
     d8a:	02054663          	bltz	a0,db6 <stat+0x42>
     d8e:	e426                	sd	s1,8(sp)
     d90:	84aa                	mv	s1,a0
    return -1;
  r = fstat(fd, st);
     d92:	85ca                	mv	a1,s2
     d94:	00000097          	auipc	ra,0x0
     d98:	210080e7          	jalr	528(ra) # fa4 <fstat>
     d9c:	892a                	mv	s2,a0
  close(fd);
     d9e:	8526                	mv	a0,s1
     da0:	00000097          	auipc	ra,0x0
     da4:	1d4080e7          	jalr	468(ra) # f74 <close>
  return r;
     da8:	64a2                	ld	s1,8(sp)
}
     daa:	854a                	mv	a0,s2
     dac:	60e2                	ld	ra,24(sp)
     dae:	6442                	ld	s0,16(sp)
     db0:	6902                	ld	s2,0(sp)
     db2:	6105                	addi	sp,sp,32
     db4:	8082                	ret
    return -1;
     db6:	597d                	li	s2,-1
     db8:	bfcd                	j	daa <stat+0x36>

0000000000000dba <atoi>:

int
atoi(const char *s)
{
     dba:	1141                	addi	sp,sp,-16
     dbc:	e422                	sd	s0,8(sp)
     dbe:	0800                	addi	s0,sp,16
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
     dc0:	00054683          	lbu	a3,0(a0)
     dc4:	fd06879b          	addiw	a5,a3,-48
     dc8:	0ff7f793          	zext.b	a5,a5
     dcc:	4625                	li	a2,9
     dce:	02f66863          	bltu	a2,a5,dfe <atoi+0x44>
     dd2:	872a                	mv	a4,a0
  n = 0;
     dd4:	4501                	li	a0,0
    n = n*10 + *s++ - '0';
     dd6:	0705                	addi	a4,a4,1
     dd8:	0025179b          	slliw	a5,a0,0x2
     ddc:	9fa9                	addw	a5,a5,a0
     dde:	0017979b          	slliw	a5,a5,0x1
     de2:	9fb5                	addw	a5,a5,a3
     de4:	fd07851b          	addiw	a0,a5,-48
  while('0' <= *s && *s <= '9')
     de8:	00074683          	lbu	a3,0(a4)
     dec:	fd06879b          	addiw	a5,a3,-48
     df0:	0ff7f793          	zext.b	a5,a5
     df4:	fef671e3          	bgeu	a2,a5,dd6 <atoi+0x1c>
  return n;
}
     df8:	6422                	ld	s0,8(sp)
     dfa:	0141                	addi	sp,sp,16
     dfc:	8082                	ret
  n = 0;
     dfe:	4501                	li	a0,0
     e00:	bfe5                	j	df8 <atoi+0x3e>

0000000000000e02 <memmove>:

void*
memmove(void *vdst, const void *vsrc, int n)
{
     e02:	1141                	addi	sp,sp,-16
     e04:	e422                	sd	s0,8(sp)
     e06:	0800                	addi	s0,sp,16
  char *dst;
  const char *src;

  dst = vdst;
  src = vsrc;
  if (src > dst) {
     e08:	02b57463          	bgeu	a0,a1,e30 <memmove+0x2e>
    while(n-- > 0)
     e0c:	00c05f63          	blez	a2,e2a <memmove+0x28>
     e10:	1602                	slli	a2,a2,0x20
     e12:	9201                	srli	a2,a2,0x20
     e14:	00c507b3          	add	a5,a0,a2
  dst = vdst;
     e18:	872a                	mv	a4,a0
      *dst++ = *src++;
     e1a:	0585                	addi	a1,a1,1
     e1c:	0705                	addi	a4,a4,1
     e1e:	fff5c683          	lbu	a3,-1(a1)
     e22:	fed70fa3          	sb	a3,-1(a4)
    while(n-- > 0)
     e26:	fef71ae3          	bne	a4,a5,e1a <memmove+0x18>
    src += n;
    while(n-- > 0)
      *--dst = *--src;
  }
  return vdst;
}
     e2a:	6422                	ld	s0,8(sp)
     e2c:	0141                	addi	sp,sp,16
     e2e:	8082                	ret
    dst += n;
     e30:	00c50733          	add	a4,a0,a2
    src += n;
     e34:	95b2                	add	a1,a1,a2
    while(n-- > 0)
     e36:	fec05ae3          	blez	a2,e2a <memmove+0x28>
     e3a:	fff6079b          	addiw	a5,a2,-1
     e3e:	1782                	slli	a5,a5,0x20
     e40:	9381                	srli	a5,a5,0x20
     e42:	fff7c793          	not	a5,a5
     e46:	97ba                	add	a5,a5,a4
      *--dst = *--src;
     e48:	15fd                	addi	a1,a1,-1
     e4a:	177d                	addi	a4,a4,-1
     e4c:	0005c683          	lbu	a3,0(a1)
     e50:	00d70023          	sb	a3,0(a4)
    while(n-- > 0)
     e54:	fee79ae3          	bne	a5,a4,e48 <memmove+0x46>
     e58:	bfc9                	j	e2a <memmove+0x28>

0000000000000e5a <memcmp>:

int
memcmp(const void *s1, const void *s2, uint n)
{
     e5a:	1141                	addi	sp,sp,-16
     e5c:	e422                	sd	s0,8(sp)
     e5e:	0800                	addi	s0,sp,16
  const char *p1 = s1, *p2 = s2;
  while (n-- > 0) {
     e60:	ca05                	beqz	a2,e90 <memcmp+0x36>
     e62:	fff6069b          	addiw	a3,a2,-1
     e66:	1682                	slli	a3,a3,0x20
     e68:	9281                	srli	a3,a3,0x20
     e6a:	0685                	addi	a3,a3,1
     e6c:	96aa                	add	a3,a3,a0
    if (*p1 != *p2) {
     e6e:	00054783          	lbu	a5,0(a0)
     e72:	0005c703          	lbu	a4,0(a1)
     e76:	00e79863          	bne	a5,a4,e86 <memcmp+0x2c>
      return *p1 - *p2;
    }
    p1++;
     e7a:	0505                	addi	a0,a0,1
    p2++;
     e7c:	0585                	addi	a1,a1,1
  while (n-- > 0) {
     e7e:	fed518e3          	bne	a0,a3,e6e <memcmp+0x14>
  }
  return 0;
     e82:	4501                	li	a0,0
     e84:	a019                	j	e8a <memcmp+0x30>
      return *p1 - *p2;
     e86:	40e7853b          	subw	a0,a5,a4
}
     e8a:	6422                	ld	s0,8(sp)
     e8c:	0141                	addi	sp,sp,16
     e8e:	8082                	ret
  return 0;
     e90:	4501                	li	a0,0
     e92:	bfe5                	j	e8a <memcmp+0x30>

0000000000000e94 <memcpy>:

void *
memcpy(void *dst, const void *src, uint n)
{
     e94:	1141                	addi	sp,sp,-16
     e96:	e406                	sd	ra,8(sp)
     e98:	e022                	sd	s0,0(sp)
     e9a:	0800                	addi	s0,sp,16
  return memmove(dst, src, n);
     e9c:	00000097          	auipc	ra,0x0
     ea0:	f66080e7          	jalr	-154(ra) # e02 <memmove>
}
     ea4:	60a2                	ld	ra,8(sp)
     ea6:	6402                	ld	s0,0(sp)
     ea8:	0141                	addi	sp,sp,16
     eaa:	8082                	ret

0000000000000eac <inet_addr>:

// Parse a dotted-decimal IPv4 string (e.g. "10.10.0.2") and return the
// address as a 32-bit integer in host byte order, or 0 on failure.
uint
inet_addr(const char *s)
{
     eac:	1141                	addi	sp,sp,-16
     eae:	e422                	sd	s0,8(sp)
     eb0:	0800                	addi	s0,sp,16
  uint result = 0;
  int octet = 0;
  int digits = 0;
  int dots = 0;

  for (; *s; s++) {
     eb2:	00054783          	lbu	a5,0(a0)
     eb6:	cfbd                	beqz	a5,f34 <inet_addr+0x88>
  int dots = 0;
     eb8:	4801                	li	a6,0
  int digits = 0;
     eba:	4601                	li	a2,0
  int octet = 0;
     ebc:	4681                	li	a3,0
  uint result = 0;
     ebe:	4581                	li	a1,0
    if (*s >= '0' && *s <= '9') {
     ec0:	48a5                	li	a7,9
      octet = octet * 10 + (*s - '0');
      digits++;
      if (octet > 255)
        return 0;
    } else if (*s == '.') {
     ec2:	02e00e93          	li	t4,46
      if (digits == 0 || dots == 3)
     ec6:	4f0d                	li	t5,3
        return 0;
      result = (result << 8) | (uint)octet;
      octet = 0;
      digits = 0;
     ec8:	4301                	li	t1,0
      if (octet > 255)
     eca:	0ff00e13          	li	t3,255
     ece:	a015                	j	ef2 <inet_addr+0x46>
    } else if (*s == '.') {
     ed0:	07d79463          	bne	a5,t4,f38 <inet_addr+0x8c>
      if (digits == 0 || dots == 3)
     ed4:	c625                	beqz	a2,f3c <inet_addr+0x90>
     ed6:	07e80563          	beq	a6,t5,f40 <inet_addr+0x94>
      result = (result << 8) | (uint)octet;
     eda:	0085959b          	slliw	a1,a1,0x8
     ede:	8ecd                	or	a3,a3,a1
     ee0:	0006859b          	sext.w	a1,a3
      dots++;
     ee4:	2805                	addiw	a6,a6,1
      digits = 0;
     ee6:	861a                	mv	a2,t1
      octet = 0;
     ee8:	869a                	mv	a3,t1
  for (; *s; s++) {
     eea:	0505                	addi	a0,a0,1
     eec:	00054783          	lbu	a5,0(a0)
     ef0:	c79d                	beqz	a5,f1e <inet_addr+0x72>
    if (*s >= '0' && *s <= '9') {
     ef2:	fd07871b          	addiw	a4,a5,-48
     ef6:	0ff77713          	zext.b	a4,a4
     efa:	fce8ebe3          	bltu	a7,a4,ed0 <inet_addr+0x24>
      octet = octet * 10 + (*s - '0');
     efe:	0026971b          	slliw	a4,a3,0x2
     f02:	9f35                	addw	a4,a4,a3
     f04:	0017171b          	slliw	a4,a4,0x1
     f08:	fd07879b          	addiw	a5,a5,-48
     f0c:	00e786bb          	addw	a3,a5,a4
      digits++;
     f10:	2605                	addiw	a2,a2,1
      if (octet > 255)
     f12:	fcde5ce3          	bge	t3,a3,eea <inet_addr+0x3e>
        return 0;
     f16:	4501                	li	a0,0
  if (digits == 0 || dots != 3)
    return 0;

  result = (result << 8) | (uint)octet;
  return result;
}
     f18:	6422                	ld	s0,8(sp)
     f1a:	0141                	addi	sp,sp,16
     f1c:	8082                	ret
    return 0;
     f1e:	4501                	li	a0,0
  if (digits == 0 || dots != 3)
     f20:	de65                	beqz	a2,f18 <inet_addr+0x6c>
     f22:	478d                	li	a5,3
     f24:	fef81ae3          	bne	a6,a5,f18 <inet_addr+0x6c>
  result = (result << 8) | (uint)octet;
     f28:	0085959b          	slliw	a1,a1,0x8
     f2c:	8ecd                	or	a3,a3,a1
     f2e:	0006851b          	sext.w	a0,a3
  return result;
     f32:	b7dd                	j	f18 <inet_addr+0x6c>
    return 0;
     f34:	4501                	li	a0,0
     f36:	b7cd                	j	f18 <inet_addr+0x6c>
      return 0;
     f38:	4501                	li	a0,0
     f3a:	bff9                	j	f18 <inet_addr+0x6c>
        return 0;
     f3c:	4501                	li	a0,0
     f3e:	bfe9                	j	f18 <inet_addr+0x6c>
     f40:	4501                	li	a0,0
     f42:	bfd9                	j	f18 <inet_addr+0x6c>

0000000000000f44 <fork>:
# generated by usys.pl - do not edit
#include "kernel/syscall.h"
.global fork
fork:
 li a7, SYS_fork
     f44:	4885                	li	a7,1
 ecall
     f46:	00000073          	ecall
 ret
     f4a:	8082                	ret

0000000000000f4c <exit>:
.global exit
exit:
 li a7, SYS_exit
     f4c:	4889                	li	a7,2
 ecall
     f4e:	00000073          	ecall
 ret
     f52:	8082                	ret

0000000000000f54 <wait>:
.global wait
wait:
 li a7, SYS_wait
     f54:	488d                	li	a7,3
 ecall
     f56:	00000073          	ecall
 ret
     f5a:	8082                	ret

0000000000000f5c <pipe>:
.global pipe
pipe:
 li a7, SYS_pipe
     f5c:	4891                	li	a7,4
 ecall
     f5e:	00000073          	ecall
 ret
     f62:	8082                	ret

0000000000000f64 <read>:
.global read
read:
 li a7, SYS_read
     f64:	4895                	li	a7,5
 ecall
     f66:	00000073          	ecall
 ret
     f6a:	8082                	ret

0000000000000f6c <write>:
.global write
write:
 li a7, SYS_write
     f6c:	48c1                	li	a7,16
 ecall
     f6e:	00000073          	ecall
 ret
     f72:	8082                	ret

0000000000000f74 <close>:
.global close
close:
 li a7, SYS_close
     f74:	48d5                	li	a7,21
 ecall
     f76:	00000073          	ecall
 ret
     f7a:	8082                	ret

0000000000000f7c <kill>:
.global kill
kill:
 li a7, SYS_kill
     f7c:	4899                	li	a7,6
 ecall
     f7e:	00000073          	ecall
 ret
     f82:	8082                	ret

0000000000000f84 <exec>:
.global exec
exec:
 li a7, SYS_exec
     f84:	489d                	li	a7,7
 ecall
     f86:	00000073          	ecall
 ret
     f8a:	8082                	ret

0000000000000f8c <open>:
.global open
open:
 li a7, SYS_open
     f8c:	48bd                	li	a7,15
 ecall
     f8e:	00000073          	ecall
 ret
     f92:	8082                	ret

0000000000000f94 <mknod>:
.global mknod
mknod:
 li a7, SYS_mknod
     f94:	48c5                	li	a7,17
 ecall
     f96:	00000073          	ecall
 ret
     f9a:	8082                	ret

0000000000000f9c <unlink>:
.global unlink
unlink:
 li a7, SYS_unlink
     f9c:	48c9                	li	a7,18
 ecall
     f9e:	00000073          	ecall
 ret
     fa2:	8082                	ret

0000000000000fa4 <fstat>:
.global fstat
fstat:
 li a7, SYS_fstat
     fa4:	48a1                	li	a7,8
 ecall
     fa6:	00000073          	ecall
 ret
     faa:	8082                	ret

0000000000000fac <link>:
.global link
link:
 li a7, SYS_link
     fac:	48cd                	li	a7,19
 ecall
     fae:	00000073          	ecall
 ret
     fb2:	8082                	ret

0000000000000fb4 <mkdir>:
.global mkdir
mkdir:
 li a7, SYS_mkdir
     fb4:	48d1                	li	a7,20
 ecall
     fb6:	00000073          	ecall
 ret
     fba:	8082                	ret

0000000000000fbc <chdir>:
.global chdir
chdir:
 li a7, SYS_chdir
     fbc:	48a5                	li	a7,9
 ecall
     fbe:	00000073          	ecall
 ret
     fc2:	8082                	ret

0000000000000fc4 <dup>:
.global dup
dup:
 li a7, SYS_dup
     fc4:	48a9                	li	a7,10
 ecall
     fc6:	00000073          	ecall
 ret
     fca:	8082                	ret

0000000000000fcc <getpid>:
.global getpid
getpid:
 li a7, SYS_getpid
     fcc:	48ad                	li	a7,11
 ecall
     fce:	00000073          	ecall
 ret
     fd2:	8082                	ret

0000000000000fd4 <sbrk>:
.global sbrk
sbrk:
 li a7, SYS_sbrk
     fd4:	48b1                	li	a7,12
 ecall
     fd6:	00000073          	ecall
 ret
     fda:	8082                	ret

0000000000000fdc <sleep>:
.global sleep
sleep:
 li a7, SYS_sleep
     fdc:	48b5                	li	a7,13
 ecall
     fde:	00000073          	ecall
 ret
     fe2:	8082                	ret

0000000000000fe4 <uptime>:
.global uptime
uptime:
 li a7, SYS_uptime
     fe4:	48b9                	li	a7,14
 ecall
     fe6:	00000073          	ecall
 ret
     fea:	8082                	ret

0000000000000fec <spoon>:
.global spoon
spoon:
 li a7, SYS_spoon
     fec:	48d9                	li	a7,22
 ecall
     fee:	00000073          	ecall
 ret
     ff2:	8082                	ret

0000000000000ff4 <create_thread>:
.global create_thread
create_thread:
 li a7, SYS_create_thread
     ff4:	48dd                	li	a7,23
 ecall
     ff6:	00000073          	ecall
 ret
     ffa:	8082                	ret

0000000000000ffc <join_thread>:
.global join_thread
join_thread:
 li a7, SYS_join_thread
     ffc:	48e1                	li	a7,24
 ecall
     ffe:	00000073          	ecall
 ret
    1002:	8082                	ret

0000000000001004 <thread_exit>:
.global thread_exit
thread_exit:
 li a7, SYS_thread_exit
    1004:	48e5                	li	a7,25
 ecall
    1006:	00000073          	ecall
 ret
    100a:	8082                	ret

000000000000100c <socket>:
.global socket
socket:
 li a7, SYS_socket
    100c:	48e9                	li	a7,26
 ecall
    100e:	00000073          	ecall
 ret
    1012:	8082                	ret

0000000000001014 <bind>:
.global bind
bind:
 li a7, SYS_bind
    1014:	48ed                	li	a7,27
 ecall
    1016:	00000073          	ecall
 ret
    101a:	8082                	ret

000000000000101c <accept>:
.global accept
accept:
 li a7, SYS_accept
    101c:	48f5                	li	a7,29
 ecall
    101e:	00000073          	ecall
 ret
    1022:	8082                	ret

0000000000001024 <listen>:
.global listen
listen:
 li a7, SYS_listen
    1024:	48f1                	li	a7,28
 ecall
    1026:	00000073          	ecall
 ret
    102a:	8082                	ret

000000000000102c <connect>:
.global connect
connect:
 li a7, SYS_connect
    102c:	48f9                	li	a7,30
 ecall
    102e:	00000073          	ecall
 ret
    1032:	8082                	ret

0000000000001034 <send>:
.global send
send:
 li a7, SYS_send
    1034:	48fd                	li	a7,31
 ecall
    1036:	00000073          	ecall
 ret
    103a:	8082                	ret

000000000000103c <recv>:
.global recv
recv:
 li a7, SYS_recv
    103c:	02000893          	li	a7,32
 ecall
    1040:	00000073          	ecall
 ret
    1044:	8082                	ret

0000000000001046 <sendto>:
.global sendto
sendto:
 li a7, SYS_sendto
    1046:	02100893          	li	a7,33
 ecall
    104a:	00000073          	ecall
 ret
    104e:	8082                	ret

0000000000001050 <recvfrom>:
.global recvfrom
recvfrom:
 li a7, SYS_recvfrom
    1050:	02200893          	li	a7,34
 ecall
    1054:	00000073          	ecall
 ret
    1058:	8082                	ret

000000000000105a <putc>:

static char digits[] = "0123456789ABCDEF";

static void
putc(int fd, char c)
{
    105a:	1101                	addi	sp,sp,-32
    105c:	ec06                	sd	ra,24(sp)
    105e:	e822                	sd	s0,16(sp)
    1060:	1000                	addi	s0,sp,32
    1062:	feb407a3          	sb	a1,-17(s0)
  write(fd, &c, 1);
    1066:	4605                	li	a2,1
    1068:	fef40593          	addi	a1,s0,-17
    106c:	00000097          	auipc	ra,0x0
    1070:	f00080e7          	jalr	-256(ra) # f6c <write>
}
    1074:	60e2                	ld	ra,24(sp)
    1076:	6442                	ld	s0,16(sp)
    1078:	6105                	addi	sp,sp,32
    107a:	8082                	ret

000000000000107c <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
    107c:	7139                	addi	sp,sp,-64
    107e:	fc06                	sd	ra,56(sp)
    1080:	f822                	sd	s0,48(sp)
    1082:	f426                	sd	s1,40(sp)
    1084:	0080                	addi	s0,sp,64
    1086:	84aa                	mv	s1,a0
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
  if(sgn && xx < 0){
    1088:	c299                	beqz	a3,108e <printint+0x12>
    108a:	0805cb63          	bltz	a1,1120 <printint+0xa4>
    neg = 1;
    x = -xx;
  } else {
    x = xx;
    108e:	2581                	sext.w	a1,a1
  neg = 0;
    1090:	4881                	li	a7,0
    1092:	fc040693          	addi	a3,s0,-64
  }

  i = 0;
    1096:	4701                	li	a4,0
  do{
    buf[i++] = digits[x % base];
    1098:	2601                	sext.w	a2,a2
    109a:	00001517          	auipc	a0,0x1
    109e:	a8650513          	addi	a0,a0,-1402 # 1b20 <digits>
    10a2:	883a                	mv	a6,a4
    10a4:	2705                	addiw	a4,a4,1
    10a6:	02c5f7bb          	remuw	a5,a1,a2
    10aa:	1782                	slli	a5,a5,0x20
    10ac:	9381                	srli	a5,a5,0x20
    10ae:	97aa                	add	a5,a5,a0
    10b0:	0007c783          	lbu	a5,0(a5)
    10b4:	00f68023          	sb	a5,0(a3)
  }while((x /= base) != 0);
    10b8:	0005879b          	sext.w	a5,a1
    10bc:	02c5d5bb          	divuw	a1,a1,a2
    10c0:	0685                	addi	a3,a3,1
    10c2:	fec7f0e3          	bgeu	a5,a2,10a2 <printint+0x26>
  if(neg)
    10c6:	00088c63          	beqz	a7,10de <printint+0x62>
    buf[i++] = '-';
    10ca:	fd070793          	addi	a5,a4,-48
    10ce:	00878733          	add	a4,a5,s0
    10d2:	02d00793          	li	a5,45
    10d6:	fef70823          	sb	a5,-16(a4)
    10da:	0028071b          	addiw	a4,a6,2

  while(--i >= 0)
    10de:	02e05c63          	blez	a4,1116 <printint+0x9a>
    10e2:	f04a                	sd	s2,32(sp)
    10e4:	ec4e                	sd	s3,24(sp)
    10e6:	fc040793          	addi	a5,s0,-64
    10ea:	00e78933          	add	s2,a5,a4
    10ee:	fff78993          	addi	s3,a5,-1
    10f2:	99ba                	add	s3,s3,a4
    10f4:	377d                	addiw	a4,a4,-1
    10f6:	1702                	slli	a4,a4,0x20
    10f8:	9301                	srli	a4,a4,0x20
    10fa:	40e989b3          	sub	s3,s3,a4
    putc(fd, buf[i]);
    10fe:	fff94583          	lbu	a1,-1(s2)
    1102:	8526                	mv	a0,s1
    1104:	00000097          	auipc	ra,0x0
    1108:	f56080e7          	jalr	-170(ra) # 105a <putc>
  while(--i >= 0)
    110c:	197d                	addi	s2,s2,-1
    110e:	ff3918e3          	bne	s2,s3,10fe <printint+0x82>
    1112:	7902                	ld	s2,32(sp)
    1114:	69e2                	ld	s3,24(sp)
}
    1116:	70e2                	ld	ra,56(sp)
    1118:	7442                	ld	s0,48(sp)
    111a:	74a2                	ld	s1,40(sp)
    111c:	6121                	addi	sp,sp,64
    111e:	8082                	ret
    x = -xx;
    1120:	40b005bb          	negw	a1,a1
    neg = 1;
    1124:	4885                	li	a7,1
    x = -xx;
    1126:	b7b5                	j	1092 <printint+0x16>

0000000000001128 <vprintf>:
}

// Print to the given fd. Only understands %d, %x, %p, %s.
void
vprintf(int fd, const char *fmt, va_list ap)
{
    1128:	715d                	addi	sp,sp,-80
    112a:	e486                	sd	ra,72(sp)
    112c:	e0a2                	sd	s0,64(sp)
    112e:	f84a                	sd	s2,48(sp)
    1130:	0880                	addi	s0,sp,80
  char *s;
  int c, i, state;

  state = 0;
  for(i = 0; fmt[i]; i++){
    1132:	0005c903          	lbu	s2,0(a1)
    1136:	1a090a63          	beqz	s2,12ea <vprintf+0x1c2>
    113a:	fc26                	sd	s1,56(sp)
    113c:	f44e                	sd	s3,40(sp)
    113e:	f052                	sd	s4,32(sp)
    1140:	ec56                	sd	s5,24(sp)
    1142:	e85a                	sd	s6,16(sp)
    1144:	e45e                	sd	s7,8(sp)
    1146:	8aaa                	mv	s5,a0
    1148:	8bb2                	mv	s7,a2
    114a:	00158493          	addi	s1,a1,1
  state = 0;
    114e:	4981                	li	s3,0
      if(c == '%'){
        state = '%';
      } else {
        putc(fd, c);
      }
    } else if(state == '%'){
    1150:	02500a13          	li	s4,37
    1154:	4b55                	li	s6,21
    1156:	a839                	j	1174 <vprintf+0x4c>
        putc(fd, c);
    1158:	85ca                	mv	a1,s2
    115a:	8556                	mv	a0,s5
    115c:	00000097          	auipc	ra,0x0
    1160:	efe080e7          	jalr	-258(ra) # 105a <putc>
    1164:	a019                	j	116a <vprintf+0x42>
    } else if(state == '%'){
    1166:	01498d63          	beq	s3,s4,1180 <vprintf+0x58>
  for(i = 0; fmt[i]; i++){
    116a:	0485                	addi	s1,s1,1
    116c:	fff4c903          	lbu	s2,-1(s1)
    1170:	16090763          	beqz	s2,12de <vprintf+0x1b6>
    if(state == 0){
    1174:	fe0999e3          	bnez	s3,1166 <vprintf+0x3e>
      if(c == '%'){
    1178:	ff4910e3          	bne	s2,s4,1158 <vprintf+0x30>
        state = '%';
    117c:	89d2                	mv	s3,s4
    117e:	b7f5                	j	116a <vprintf+0x42>
      if(c == 'd'){
    1180:	13490463          	beq	s2,s4,12a8 <vprintf+0x180>
    1184:	f9d9079b          	addiw	a5,s2,-99
    1188:	0ff7f793          	zext.b	a5,a5
    118c:	12fb6763          	bltu	s6,a5,12ba <vprintf+0x192>
    1190:	f9d9079b          	addiw	a5,s2,-99
    1194:	0ff7f713          	zext.b	a4,a5
    1198:	12eb6163          	bltu	s6,a4,12ba <vprintf+0x192>
    119c:	00271793          	slli	a5,a4,0x2
    11a0:	00001717          	auipc	a4,0x1
    11a4:	92870713          	addi	a4,a4,-1752 # 1ac8 <ithread_join+0x3e8>
    11a8:	97ba                	add	a5,a5,a4
    11aa:	439c                	lw	a5,0(a5)
    11ac:	97ba                	add	a5,a5,a4
    11ae:	8782                	jr	a5
        printint(fd, va_arg(ap, int), 10, 1);
    11b0:	008b8913          	addi	s2,s7,8
    11b4:	4685                	li	a3,1
    11b6:	4629                	li	a2,10
    11b8:	000ba583          	lw	a1,0(s7)
    11bc:	8556                	mv	a0,s5
    11be:	00000097          	auipc	ra,0x0
    11c2:	ebe080e7          	jalr	-322(ra) # 107c <printint>
    11c6:	8bca                	mv	s7,s2
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
        putc(fd, c);
      }
      state = 0;
    11c8:	4981                	li	s3,0
    11ca:	b745                	j	116a <vprintf+0x42>
        printint(fd, va_arg(ap, uint64), 10, 0);
    11cc:	008b8913          	addi	s2,s7,8
    11d0:	4681                	li	a3,0
    11d2:	4629                	li	a2,10
    11d4:	000ba583          	lw	a1,0(s7)
    11d8:	8556                	mv	a0,s5
    11da:	00000097          	auipc	ra,0x0
    11de:	ea2080e7          	jalr	-350(ra) # 107c <printint>
    11e2:	8bca                	mv	s7,s2
      state = 0;
    11e4:	4981                	li	s3,0
    11e6:	b751                	j	116a <vprintf+0x42>
        printint(fd, va_arg(ap, int), 16, 0);
    11e8:	008b8913          	addi	s2,s7,8
    11ec:	4681                	li	a3,0
    11ee:	4641                	li	a2,16
    11f0:	000ba583          	lw	a1,0(s7)
    11f4:	8556                	mv	a0,s5
    11f6:	00000097          	auipc	ra,0x0
    11fa:	e86080e7          	jalr	-378(ra) # 107c <printint>
    11fe:	8bca                	mv	s7,s2
      state = 0;
    1200:	4981                	li	s3,0
    1202:	b7a5                	j	116a <vprintf+0x42>
    1204:	e062                	sd	s8,0(sp)
        printptr(fd, va_arg(ap, uint64));
    1206:	008b8c13          	addi	s8,s7,8
    120a:	000bb983          	ld	s3,0(s7)
  putc(fd, '0');
    120e:	03000593          	li	a1,48
    1212:	8556                	mv	a0,s5
    1214:	00000097          	auipc	ra,0x0
    1218:	e46080e7          	jalr	-442(ra) # 105a <putc>
  putc(fd, 'x');
    121c:	07800593          	li	a1,120
    1220:	8556                	mv	a0,s5
    1222:	00000097          	auipc	ra,0x0
    1226:	e38080e7          	jalr	-456(ra) # 105a <putc>
    122a:	4941                	li	s2,16
    putc(fd, digits[x >> (sizeof(uint64) * 8 - 4)]);
    122c:	00001b97          	auipc	s7,0x1
    1230:	8f4b8b93          	addi	s7,s7,-1804 # 1b20 <digits>
    1234:	03c9d793          	srli	a5,s3,0x3c
    1238:	97de                	add	a5,a5,s7
    123a:	0007c583          	lbu	a1,0(a5)
    123e:	8556                	mv	a0,s5
    1240:	00000097          	auipc	ra,0x0
    1244:	e1a080e7          	jalr	-486(ra) # 105a <putc>
  for (i = 0; i < (sizeof(uint64) * 2); i++, x <<= 4)
    1248:	0992                	slli	s3,s3,0x4
    124a:	397d                	addiw	s2,s2,-1
    124c:	fe0914e3          	bnez	s2,1234 <vprintf+0x10c>
        printptr(fd, va_arg(ap, uint64));
    1250:	8be2                	mv	s7,s8
      state = 0;
    1252:	4981                	li	s3,0
    1254:	6c02                	ld	s8,0(sp)
    1256:	bf11                	j	116a <vprintf+0x42>
        s = va_arg(ap, char*);
    1258:	008b8993          	addi	s3,s7,8
    125c:	000bb903          	ld	s2,0(s7)
        if(s == 0)
    1260:	02090163          	beqz	s2,1282 <vprintf+0x15a>
        while(*s != 0){
    1264:	00094583          	lbu	a1,0(s2)
    1268:	c9a5                	beqz	a1,12d8 <vprintf+0x1b0>
          putc(fd, *s);
    126a:	8556                	mv	a0,s5
    126c:	00000097          	auipc	ra,0x0
    1270:	dee080e7          	jalr	-530(ra) # 105a <putc>
          s++;
    1274:	0905                	addi	s2,s2,1
        while(*s != 0){
    1276:	00094583          	lbu	a1,0(s2)
    127a:	f9e5                	bnez	a1,126a <vprintf+0x142>
        s = va_arg(ap, char*);
    127c:	8bce                	mv	s7,s3
      state = 0;
    127e:	4981                	li	s3,0
    1280:	b5ed                	j	116a <vprintf+0x42>
          s = "(null)";
    1282:	00000917          	auipc	s2,0x0
    1286:	7b690913          	addi	s2,s2,1974 # 1a38 <ithread_join+0x358>
        while(*s != 0){
    128a:	02800593          	li	a1,40
    128e:	bff1                	j	126a <vprintf+0x142>
        putc(fd, va_arg(ap, uint));
    1290:	008b8913          	addi	s2,s7,8
    1294:	000bc583          	lbu	a1,0(s7)
    1298:	8556                	mv	a0,s5
    129a:	00000097          	auipc	ra,0x0
    129e:	dc0080e7          	jalr	-576(ra) # 105a <putc>
    12a2:	8bca                	mv	s7,s2
      state = 0;
    12a4:	4981                	li	s3,0
    12a6:	b5d1                	j	116a <vprintf+0x42>
        putc(fd, c);
    12a8:	02500593          	li	a1,37
    12ac:	8556                	mv	a0,s5
    12ae:	00000097          	auipc	ra,0x0
    12b2:	dac080e7          	jalr	-596(ra) # 105a <putc>
      state = 0;
    12b6:	4981                	li	s3,0
    12b8:	bd4d                	j	116a <vprintf+0x42>
        putc(fd, '%');
    12ba:	02500593          	li	a1,37
    12be:	8556                	mv	a0,s5
    12c0:	00000097          	auipc	ra,0x0
    12c4:	d9a080e7          	jalr	-614(ra) # 105a <putc>
        putc(fd, c);
    12c8:	85ca                	mv	a1,s2
    12ca:	8556                	mv	a0,s5
    12cc:	00000097          	auipc	ra,0x0
    12d0:	d8e080e7          	jalr	-626(ra) # 105a <putc>
      state = 0;
    12d4:	4981                	li	s3,0
    12d6:	bd51                	j	116a <vprintf+0x42>
        s = va_arg(ap, char*);
    12d8:	8bce                	mv	s7,s3
      state = 0;
    12da:	4981                	li	s3,0
    12dc:	b579                	j	116a <vprintf+0x42>
    12de:	74e2                	ld	s1,56(sp)
    12e0:	79a2                	ld	s3,40(sp)
    12e2:	7a02                	ld	s4,32(sp)
    12e4:	6ae2                	ld	s5,24(sp)
    12e6:	6b42                	ld	s6,16(sp)
    12e8:	6ba2                	ld	s7,8(sp)
    }
  }
}
    12ea:	60a6                	ld	ra,72(sp)
    12ec:	6406                	ld	s0,64(sp)
    12ee:	7942                	ld	s2,48(sp)
    12f0:	6161                	addi	sp,sp,80
    12f2:	8082                	ret

00000000000012f4 <fprintf>:

void
fprintf(int fd, const char *fmt, ...)
{
    12f4:	715d                	addi	sp,sp,-80
    12f6:	ec06                	sd	ra,24(sp)
    12f8:	e822                	sd	s0,16(sp)
    12fa:	1000                	addi	s0,sp,32
    12fc:	e010                	sd	a2,0(s0)
    12fe:	e414                	sd	a3,8(s0)
    1300:	e818                	sd	a4,16(s0)
    1302:	ec1c                	sd	a5,24(s0)
    1304:	03043023          	sd	a6,32(s0)
    1308:	03143423          	sd	a7,40(s0)
  va_list ap;

  va_start(ap, fmt);
    130c:	fe843423          	sd	s0,-24(s0)
  vprintf(fd, fmt, ap);
    1310:	8622                	mv	a2,s0
    1312:	00000097          	auipc	ra,0x0
    1316:	e16080e7          	jalr	-490(ra) # 1128 <vprintf>
}
    131a:	60e2                	ld	ra,24(sp)
    131c:	6442                	ld	s0,16(sp)
    131e:	6161                	addi	sp,sp,80
    1320:	8082                	ret

0000000000001322 <printf>:

void
printf(const char *fmt, ...)
{
    1322:	711d                	addi	sp,sp,-96
    1324:	ec06                	sd	ra,24(sp)
    1326:	e822                	sd	s0,16(sp)
    1328:	1000                	addi	s0,sp,32
    132a:	e40c                	sd	a1,8(s0)
    132c:	e810                	sd	a2,16(s0)
    132e:	ec14                	sd	a3,24(s0)
    1330:	f018                	sd	a4,32(s0)
    1332:	f41c                	sd	a5,40(s0)
    1334:	03043823          	sd	a6,48(s0)
    1338:	03143c23          	sd	a7,56(s0)
  va_list ap;

  va_start(ap, fmt);
    133c:	00840613          	addi	a2,s0,8
    1340:	fec43423          	sd	a2,-24(s0)
  vprintf(1, fmt, ap);
    1344:	85aa                	mv	a1,a0
    1346:	4505                	li	a0,1
    1348:	00000097          	auipc	ra,0x0
    134c:	de0080e7          	jalr	-544(ra) # 1128 <vprintf>
}
    1350:	60e2                	ld	ra,24(sp)
    1352:	6442                	ld	s0,16(sp)
    1354:	6125                	addi	sp,sp,96
    1356:	8082                	ret

0000000000001358 <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
    1358:	1141                	addi	sp,sp,-16
    135a:	e422                	sd	s0,8(sp)
    135c:	0800                	addi	s0,sp,16
  Header *bp, *p;

  bp = (Header*)ap - 1;
    135e:	ff050693          	addi	a3,a0,-16
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
    1362:	00001797          	auipc	a5,0x1
    1366:	cae7b783          	ld	a5,-850(a5) # 2010 <freep>
    136a:	a02d                	j	1394 <free+0x3c>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
      break;
  if(bp + bp->s.size == p->s.ptr){
    bp->s.size += p->s.ptr->s.size;
    136c:	4618                	lw	a4,8(a2)
    136e:	9f2d                	addw	a4,a4,a1
    1370:	fee52c23          	sw	a4,-8(a0)
    bp->s.ptr = p->s.ptr->s.ptr;
    1374:	6398                	ld	a4,0(a5)
    1376:	6310                	ld	a2,0(a4)
    1378:	a83d                	j	13b6 <free+0x5e>
  } else
    bp->s.ptr = p->s.ptr;
  if(p + p->s.size == bp){
    p->s.size += bp->s.size;
    137a:	ff852703          	lw	a4,-8(a0)
    137e:	9f31                	addw	a4,a4,a2
    1380:	c798                	sw	a4,8(a5)
    p->s.ptr = bp->s.ptr;
    1382:	ff053683          	ld	a3,-16(a0)
    1386:	a091                	j	13ca <free+0x72>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
    1388:	6398                	ld	a4,0(a5)
    138a:	00e7e463          	bltu	a5,a4,1392 <free+0x3a>
    138e:	00e6ea63          	bltu	a3,a4,13a2 <free+0x4a>
{
    1392:	87ba                	mv	a5,a4
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
    1394:	fed7fae3          	bgeu	a5,a3,1388 <free+0x30>
    1398:	6398                	ld	a4,0(a5)
    139a:	00e6e463          	bltu	a3,a4,13a2 <free+0x4a>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
    139e:	fee7eae3          	bltu	a5,a4,1392 <free+0x3a>
  if(bp + bp->s.size == p->s.ptr){
    13a2:	ff852583          	lw	a1,-8(a0)
    13a6:	6390                	ld	a2,0(a5)
    13a8:	02059813          	slli	a6,a1,0x20
    13ac:	01c85713          	srli	a4,a6,0x1c
    13b0:	9736                	add	a4,a4,a3
    13b2:	fae60de3          	beq	a2,a4,136c <free+0x14>
    bp->s.ptr = p->s.ptr->s.ptr;
    13b6:	fec53823          	sd	a2,-16(a0)
  if(p + p->s.size == bp){
    13ba:	4790                	lw	a2,8(a5)
    13bc:	02061593          	slli	a1,a2,0x20
    13c0:	01c5d713          	srli	a4,a1,0x1c
    13c4:	973e                	add	a4,a4,a5
    13c6:	fae68ae3          	beq	a3,a4,137a <free+0x22>
    p->s.ptr = bp->s.ptr;
    13ca:	e394                	sd	a3,0(a5)
  } else
    p->s.ptr = bp;
  freep = p;
    13cc:	00001717          	auipc	a4,0x1
    13d0:	c4f73223          	sd	a5,-956(a4) # 2010 <freep>
}
    13d4:	6422                	ld	s0,8(sp)
    13d6:	0141                	addi	sp,sp,16
    13d8:	8082                	ret

00000000000013da <malloc>:
  return freep;
}

void*
malloc(uint nbytes)
{
    13da:	7139                	addi	sp,sp,-64
    13dc:	fc06                	sd	ra,56(sp)
    13de:	f822                	sd	s0,48(sp)
    13e0:	f426                	sd	s1,40(sp)
    13e2:	ec4e                	sd	s3,24(sp)
    13e4:	0080                	addi	s0,sp,64
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
    13e6:	02051493          	slli	s1,a0,0x20
    13ea:	9081                	srli	s1,s1,0x20
    13ec:	04bd                	addi	s1,s1,15
    13ee:	8091                	srli	s1,s1,0x4
    13f0:	0014899b          	addiw	s3,s1,1
    13f4:	0485                	addi	s1,s1,1
  if((prevp = freep) == 0){
    13f6:	00001517          	auipc	a0,0x1
    13fa:	c1a53503          	ld	a0,-998(a0) # 2010 <freep>
    13fe:	c915                	beqz	a0,1432 <malloc+0x58>
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
    1400:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
    1402:	4798                	lw	a4,8(a5)
    1404:	08977e63          	bgeu	a4,s1,14a0 <malloc+0xc6>
    1408:	f04a                	sd	s2,32(sp)
    140a:	e852                	sd	s4,16(sp)
    140c:	e456                	sd	s5,8(sp)
    140e:	e05a                	sd	s6,0(sp)
  if(nu < 4096)
    1410:	8a4e                	mv	s4,s3
    1412:	0009871b          	sext.w	a4,s3
    1416:	6685                	lui	a3,0x1
    1418:	00d77363          	bgeu	a4,a3,141e <malloc+0x44>
    141c:	6a05                	lui	s4,0x1
    141e:	000a0b1b          	sext.w	s6,s4
  p = sbrk(nu * sizeof(Header));
    1422:	004a1a1b          	slliw	s4,s4,0x4
        p->s.size = nunits;
      }
      freep = prevp;
      return (void*)(p + 1);
    }
    if(p == freep)
    1426:	00001917          	auipc	s2,0x1
    142a:	bea90913          	addi	s2,s2,-1046 # 2010 <freep>
  if(p == (char*)-1)
    142e:	5afd                	li	s5,-1
    1430:	a091                	j	1474 <malloc+0x9a>
    1432:	f04a                	sd	s2,32(sp)
    1434:	e852                	sd	s4,16(sp)
    1436:	e456                	sd	s5,8(sp)
    1438:	e05a                	sd	s6,0(sp)
    base.s.ptr = freep = prevp = &base;
    143a:	00001797          	auipc	a5,0x1
    143e:	fde78793          	addi	a5,a5,-34 # 2418 <base>
    1442:	00001717          	auipc	a4,0x1
    1446:	bcf73723          	sd	a5,-1074(a4) # 2010 <freep>
    144a:	e39c                	sd	a5,0(a5)
    base.s.size = 0;
    144c:	0007a423          	sw	zero,8(a5)
    if(p->s.size >= nunits){
    1450:	b7c1                	j	1410 <malloc+0x36>
        prevp->s.ptr = p->s.ptr;
    1452:	6398                	ld	a4,0(a5)
    1454:	e118                	sd	a4,0(a0)
    1456:	a08d                	j	14b8 <malloc+0xde>
  hp->s.size = nu;
    1458:	01652423          	sw	s6,8(a0)
  free((void*)(hp + 1));
    145c:	0541                	addi	a0,a0,16
    145e:	00000097          	auipc	ra,0x0
    1462:	efa080e7          	jalr	-262(ra) # 1358 <free>
  return freep;
    1466:	00093503          	ld	a0,0(s2)
      if((p = morecore(nunits)) == 0)
    146a:	c13d                	beqz	a0,14d0 <malloc+0xf6>
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
    146c:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
    146e:	4798                	lw	a4,8(a5)
    1470:	02977463          	bgeu	a4,s1,1498 <malloc+0xbe>
    if(p == freep)
    1474:	00093703          	ld	a4,0(s2)
    1478:	853e                	mv	a0,a5
    147a:	fef719e3          	bne	a4,a5,146c <malloc+0x92>
  p = sbrk(nu * sizeof(Header));
    147e:	8552                	mv	a0,s4
    1480:	00000097          	auipc	ra,0x0
    1484:	b54080e7          	jalr	-1196(ra) # fd4 <sbrk>
  if(p == (char*)-1)
    1488:	fd5518e3          	bne	a0,s5,1458 <malloc+0x7e>
        return 0;
    148c:	4501                	li	a0,0
    148e:	7902                	ld	s2,32(sp)
    1490:	6a42                	ld	s4,16(sp)
    1492:	6aa2                	ld	s5,8(sp)
    1494:	6b02                	ld	s6,0(sp)
    1496:	a03d                	j	14c4 <malloc+0xea>
    1498:	7902                	ld	s2,32(sp)
    149a:	6a42                	ld	s4,16(sp)
    149c:	6aa2                	ld	s5,8(sp)
    149e:	6b02                	ld	s6,0(sp)
      if(p->s.size == nunits)
    14a0:	fae489e3          	beq	s1,a4,1452 <malloc+0x78>
        p->s.size -= nunits;
    14a4:	4137073b          	subw	a4,a4,s3
    14a8:	c798                	sw	a4,8(a5)
        p += p->s.size;
    14aa:	02071693          	slli	a3,a4,0x20
    14ae:	01c6d713          	srli	a4,a3,0x1c
    14b2:	97ba                	add	a5,a5,a4
        p->s.size = nunits;
    14b4:	0137a423          	sw	s3,8(a5)
      freep = prevp;
    14b8:	00001717          	auipc	a4,0x1
    14bc:	b4a73c23          	sd	a0,-1192(a4) # 2010 <freep>
      return (void*)(p + 1);
    14c0:	01078513          	addi	a0,a5,16
  }
}
    14c4:	70e2                	ld	ra,56(sp)
    14c6:	7442                	ld	s0,48(sp)
    14c8:	74a2                	ld	s1,40(sp)
    14ca:	69e2                	ld	s3,24(sp)
    14cc:	6121                	addi	sp,sp,64
    14ce:	8082                	ret
    14d0:	7902                	ld	s2,32(sp)
    14d2:	6a42                	ld	s4,16(sp)
    14d4:	6aa2                	ld	s5,8(sp)
    14d6:	6b02                	ld	s6,0(sp)
    14d8:	b7f5                	j	14c4 <malloc+0xea>

00000000000014da <ithread_exit>:
  free(stacks);
  stacks = new_stacks;
  return 0;
}

void ithread_exit(uint64 status) {
    14da:	1141                	addi	sp,sp,-16
    14dc:	e406                	sd	ra,8(sp)
    14de:	e022                	sd	s0,0(sp)
    14e0:	0800                	addi	s0,sp,16
  thread_exit(status);
    14e2:	2501                	sext.w	a0,a0
    14e4:	00000097          	auipc	ra,0x0
    14e8:	b20080e7          	jalr	-1248(ra) # 1004 <thread_exit>
}
    14ec:	60a2                	ld	ra,8(sp)
    14ee:	6402                	ld	s0,0(sp)
    14f0:	0141                	addi	sp,sp,16
    14f2:	8082                	ret

00000000000014f4 <free_stacks>:
int free_stacks() {
    14f4:	7179                	addi	sp,sp,-48
    14f6:	f406                	sd	ra,40(sp)
    14f8:	f022                	sd	s0,32(sp)
    14fa:	ec26                	sd	s1,24(sp)
    14fc:	1800                	addi	s0,sp,48
  for (int i = 0; i < num_threads; i++) {
    14fe:	00001797          	auipc	a5,0x1
    1502:	b227a783          	lw	a5,-1246(a5) # 2020 <num_threads>
    1506:	04f05063          	blez	a5,1546 <free_stacks+0x52>
    150a:	e84a                	sd	s2,16(sp)
    150c:	e44e                	sd	s3,8(sp)
    150e:	4481                	li	s1,0
    free(stacks[i]);
    1510:	00001997          	auipc	s3,0x1
    1514:	b0898993          	addi	s3,s3,-1272 # 2018 <stacks>
  for (int i = 0; i < num_threads; i++) {
    1518:	00001917          	auipc	s2,0x1
    151c:	b0890913          	addi	s2,s2,-1272 # 2020 <num_threads>
    free(stacks[i]);
    1520:	0009b783          	ld	a5,0(s3)
    1524:	00349713          	slli	a4,s1,0x3
    1528:	97ba                	add	a5,a5,a4
    152a:	6388                	ld	a0,0(a5)
    152c:	00000097          	auipc	ra,0x0
    1530:	e2c080e7          	jalr	-468(ra) # 1358 <free>
  for (int i = 0; i < num_threads; i++) {
    1534:	0485                	addi	s1,s1,1
    1536:	00092703          	lw	a4,0(s2)
    153a:	0004879b          	sext.w	a5,s1
    153e:	fee7c1e3          	blt	a5,a4,1520 <free_stacks+0x2c>
    1542:	6942                	ld	s2,16(sp)
    1544:	69a2                	ld	s3,8(sp)
  free(stacks);
    1546:	00001497          	auipc	s1,0x1
    154a:	ad248493          	addi	s1,s1,-1326 # 2018 <stacks>
    154e:	6088                	ld	a0,0(s1)
    1550:	00000097          	auipc	ra,0x0
    1554:	e08080e7          	jalr	-504(ra) # 1358 <free>
  stacks = 0;
    1558:	0004b023          	sd	zero,0(s1)
  num_threads = 0;
    155c:	00001797          	auipc	a5,0x1
    1560:	ac07a223          	sw	zero,-1340(a5) # 2020 <num_threads>
  max_stacks = INIT_MAX_STACKS;
    1564:	47a1                	li	a5,8
    1566:	00001717          	auipc	a4,0x1
    156a:	aaf72123          	sw	a5,-1374(a4) # 2008 <max_stacks>
  threads_done = 0;
    156e:	00001797          	auipc	a5,0x1
    1572:	aa07ab23          	sw	zero,-1354(a5) # 2024 <threads_done>
}
    1576:	4501                	li	a0,0
    1578:	70a2                	ld	ra,40(sp)
    157a:	7402                	ld	s0,32(sp)
    157c:	64e2                	ld	s1,24(sp)
    157e:	6145                	addi	sp,sp,48
    1580:	8082                	ret

0000000000001582 <expand_num_threads>:
int expand_num_threads() {
    1582:	1101                	addi	sp,sp,-32
    1584:	ec06                	sd	ra,24(sp)
    1586:	e822                	sd	s0,16(sp)
    1588:	e426                	sd	s1,8(sp)
    158a:	e04a                	sd	s2,0(sp)
    158c:	1000                	addi	s0,sp,32
  max_stacks *= 2;
    158e:	00001797          	auipc	a5,0x1
    1592:	a7a78793          	addi	a5,a5,-1414 # 2008 <max_stacks>
    1596:	4388                	lw	a0,0(a5)
    1598:	0015151b          	slliw	a0,a0,0x1
    159c:	c388                	sw	a0,0(a5)
  void **new_stacks = malloc(max_stacks*sizeof(char*));
    159e:	0035151b          	slliw	a0,a0,0x3
    15a2:	00000097          	auipc	ra,0x0
    15a6:	e38080e7          	jalr	-456(ra) # 13da <malloc>
    15aa:	892a                	mv	s2,a0
  memmove(new_stacks, stacks, num_threads*sizeof(char*));
    15ac:	00001617          	auipc	a2,0x1
    15b0:	a7462603          	lw	a2,-1420(a2) # 2020 <num_threads>
    15b4:	00001497          	auipc	s1,0x1
    15b8:	a6448493          	addi	s1,s1,-1436 # 2018 <stacks>
    15bc:	0036161b          	slliw	a2,a2,0x3
    15c0:	608c                	ld	a1,0(s1)
    15c2:	00000097          	auipc	ra,0x0
    15c6:	840080e7          	jalr	-1984(ra) # e02 <memmove>
  free(stacks);
    15ca:	6088                	ld	a0,0(s1)
    15cc:	00000097          	auipc	ra,0x0
    15d0:	d8c080e7          	jalr	-628(ra) # 1358 <free>
  stacks = new_stacks;
    15d4:	0124b023          	sd	s2,0(s1)
}
    15d8:	4501                	li	a0,0
    15da:	60e2                	ld	ra,24(sp)
    15dc:	6442                	ld	s0,16(sp)
    15de:	64a2                	ld	s1,8(sp)
    15e0:	6902                	ld	s2,0(sp)
    15e2:	6105                	addi	sp,sp,32
    15e4:	8082                	ret

00000000000015e6 <ithread_create>:

int ithread_create(void* (*fn_ptr)(void *), void *args) {
    15e6:	7179                	addi	sp,sp,-48
    15e8:	f406                	sd	ra,40(sp)
    15ea:	f022                	sd	s0,32(sp)
    15ec:	e84a                	sd	s2,16(sp)
    15ee:	e44e                	sd	s3,8(sp)
    15f0:	1800                	addi	s0,sp,48
    15f2:	892a                	mv	s2,a0
    15f4:	89ae                	mv	s3,a1
  if (stacks == 0) {
    15f6:	00001797          	auipc	a5,0x1
    15fa:	a227b783          	ld	a5,-1502(a5) # 2018 <stacks>
    15fe:	c3d9                	beqz	a5,1684 <ithread_create+0x9e>
    stacks = malloc(max_stacks*sizeof(char*));
  }
  if (num_threads == max_stacks) {
    1600:	00001797          	auipc	a5,0x1
    1604:	a087a783          	lw	a5,-1528(a5) # 2008 <max_stacks>
    1608:	00001717          	auipc	a4,0x1
    160c:	a1872703          	lw	a4,-1512(a4) # 2020 <num_threads>
    1610:	0af71363          	bne	a4,a5,16b6 <ithread_create+0xd0>
    if (max_stacks == MAX_THREADS) {
    1614:	04000713          	li	a4,64
    1618:	08e78563          	beq	a5,a4,16a2 <ithread_create+0xbc>
    161c:	ec26                	sd	s1,24(sp)
      printf("ERROR: Thread capacity has been reached\n");
      return -1;
    }
    expand_num_threads();
    161e:	00000097          	auipc	ra,0x0
    1622:	f64080e7          	jalr	-156(ra) # 1582 <expand_num_threads>
  }

  void *stack_ptr = malloc(PGSIZE);
    1626:	6505                	lui	a0,0x1
    1628:	00000097          	auipc	ra,0x0
    162c:	db2080e7          	jalr	-590(ra) # 13da <malloc>
    1630:	84aa                	mv	s1,a0
  stacks[num_threads] = stack_ptr;
    1632:	00001717          	auipc	a4,0x1
    1636:	9ee72703          	lw	a4,-1554(a4) # 2020 <num_threads>
    163a:	070e                	slli	a4,a4,0x3
    163c:	00001797          	auipc	a5,0x1
    1640:	9dc7b783          	ld	a5,-1572(a5) # 2018 <stacks>
    1644:	97ba                	add	a5,a5,a4
    1646:	e388                	sd	a0,0(a5)
  int res = create_thread(fn_ptr, args, stack_ptr, &ithread_exit);
    1648:	00000697          	auipc	a3,0x0
    164c:	e9268693          	addi	a3,a3,-366 # 14da <ithread_exit>
    1650:	862a                	mv	a2,a0
    1652:	85ce                	mv	a1,s3
    1654:	854a                	mv	a0,s2
    1656:	00000097          	auipc	ra,0x0
    165a:	99e080e7          	jalr	-1634(ra) # ff4 <create_thread>
    165e:	892a                	mv	s2,a0
  if (res != -1) {
    1660:	57fd                	li	a5,-1
    1662:	04f50c63          	beq	a0,a5,16ba <ithread_create+0xd4>
    num_threads++;
    1666:	00001717          	auipc	a4,0x1
    166a:	9ba70713          	addi	a4,a4,-1606 # 2020 <num_threads>
    166e:	431c                	lw	a5,0(a4)
    1670:	2785                	addiw	a5,a5,1
    1672:	c31c                	sw	a5,0(a4)
    1674:	64e2                	ld	s1,24(sp)
  } else {
    free(stack_ptr);
    stacks[num_threads] = 0;
  }
  return res;
}
    1676:	854a                	mv	a0,s2
    1678:	70a2                	ld	ra,40(sp)
    167a:	7402                	ld	s0,32(sp)
    167c:	6942                	ld	s2,16(sp)
    167e:	69a2                	ld	s3,8(sp)
    1680:	6145                	addi	sp,sp,48
    1682:	8082                	ret
    stacks = malloc(max_stacks*sizeof(char*));
    1684:	00001517          	auipc	a0,0x1
    1688:	98452503          	lw	a0,-1660(a0) # 2008 <max_stacks>
    168c:	0035151b          	slliw	a0,a0,0x3
    1690:	00000097          	auipc	ra,0x0
    1694:	d4a080e7          	jalr	-694(ra) # 13da <malloc>
    1698:	00001797          	auipc	a5,0x1
    169c:	98a7b023          	sd	a0,-1664(a5) # 2018 <stacks>
    16a0:	b785                	j	1600 <ithread_create+0x1a>
      printf("ERROR: Thread capacity has been reached\n");
    16a2:	00000517          	auipc	a0,0x0
    16a6:	39e50513          	addi	a0,a0,926 # 1a40 <ithread_join+0x360>
    16aa:	00000097          	auipc	ra,0x0
    16ae:	c78080e7          	jalr	-904(ra) # 1322 <printf>
      return -1;
    16b2:	597d                	li	s2,-1
    16b4:	b7c9                	j	1676 <ithread_create+0x90>
    16b6:	ec26                	sd	s1,24(sp)
    16b8:	b7bd                	j	1626 <ithread_create+0x40>
    free(stack_ptr);
    16ba:	8526                	mv	a0,s1
    16bc:	00000097          	auipc	ra,0x0
    16c0:	c9c080e7          	jalr	-868(ra) # 1358 <free>
    stacks[num_threads] = 0;
    16c4:	00001717          	auipc	a4,0x1
    16c8:	95c72703          	lw	a4,-1700(a4) # 2020 <num_threads>
    16cc:	070e                	slli	a4,a4,0x3
    16ce:	00001797          	auipc	a5,0x1
    16d2:	94a7b783          	ld	a5,-1718(a5) # 2018 <stacks>
    16d6:	97ba                	add	a5,a5,a4
    16d8:	0007b023          	sd	zero,0(a5)
    16dc:	64e2                	ld	s1,24(sp)
    16de:	bf61                	j	1676 <ithread_create+0x90>

00000000000016e0 <ithread_join>:

int ithread_join(int thread_id) {
    16e0:	1101                	addi	sp,sp,-32
    16e2:	ec06                	sd	ra,24(sp)
    16e4:	e822                	sd	s0,16(sp)
    16e6:	1000                	addi	s0,sp,32
  int status;
  join_thread(thread_id, (uint64)&status);
    16e8:	ff040793          	addi	a5,s0,-16
    16ec:	ffc7859b          	addiw	a1,a5,-4
    16f0:	00000097          	auipc	ra,0x0
    16f4:	90c080e7          	jalr	-1780(ra) # ffc <join_thread>
  threads_done++;
    16f8:	00001717          	auipc	a4,0x1
    16fc:	92c70713          	addi	a4,a4,-1748 # 2024 <threads_done>
    1700:	431c                	lw	a5,0(a4)
    1702:	2785                	addiw	a5,a5,1
    1704:	0007869b          	sext.w	a3,a5
    1708:	c31c                	sw	a5,0(a4)
  if (threads_done == num_threads) {
    170a:	00001797          	auipc	a5,0x1
    170e:	9167a783          	lw	a5,-1770(a5) # 2020 <num_threads>
    1712:	00d78863          	beq	a5,a3,1722 <ithread_join+0x42>
    free_stacks();
  }
  return status;
}
    1716:	fec42503          	lw	a0,-20(s0)
    171a:	60e2                	ld	ra,24(sp)
    171c:	6442                	ld	s0,16(sp)
    171e:	6105                	addi	sp,sp,32
    1720:	8082                	ret
    free_stacks();
    1722:	00000097          	auipc	ra,0x0
    1726:	dd2080e7          	jalr	-558(ra) # 14f4 <free_stacks>
    172a:	b7f5                	j	1716 <ithread_join+0x36>
