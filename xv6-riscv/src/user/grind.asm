
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
      8c:	e40080e7          	jalr	-448(ra) # ec8 <sbrk>
      90:	8aaa                	mv	s5,a0
  uint64 iters = 0;

  mkdir("grindir");
      92:	00001517          	auipc	a0,0x1
      96:	58e50513          	addi	a0,a0,1422 # 1620 <ithread_join+0x4c>
      9a:	00001097          	auipc	ra,0x1
      9e:	e0e080e7          	jalr	-498(ra) # ea8 <mkdir>
  if(chdir("grindir") != 0){
      a2:	00001517          	auipc	a0,0x1
      a6:	57e50513          	addi	a0,a0,1406 # 1620 <ithread_join+0x4c>
      aa:	00001097          	auipc	ra,0x1
      ae:	e06080e7          	jalr	-506(ra) # eb0 <chdir>
      b2:	c115                	beqz	a0,d6 <go+0x5e>
      b4:	e8ca                	sd	s2,80(sp)
      b6:	e4ce                	sd	s3,72(sp)
      b8:	e0d2                	sd	s4,64(sp)
      ba:	f85a                	sd	s6,48(sp)
    printf("grind: chdir grindir failed\n");
      bc:	00001517          	auipc	a0,0x1
      c0:	56c50513          	addi	a0,a0,1388 # 1628 <ithread_join+0x54>
      c4:	00001097          	auipc	ra,0x1
      c8:	152080e7          	jalr	338(ra) # 1216 <printf>
    exit(1);
      cc:	4505                	li	a0,1
      ce:	00001097          	auipc	ra,0x1
      d2:	d72080e7          	jalr	-654(ra) # e40 <exit>
      d6:	e8ca                	sd	s2,80(sp)
      d8:	e4ce                	sd	s3,72(sp)
      da:	e0d2                	sd	s4,64(sp)
      dc:	f85a                	sd	s6,48(sp)
  }
  chdir("/");
      de:	00001517          	auipc	a0,0x1
      e2:	57250513          	addi	a0,a0,1394 # 1650 <ithread_join+0x7c>
      e6:	00001097          	auipc	ra,0x1
      ea:	dca080e7          	jalr	-566(ra) # eb0 <chdir>
      ee:	00001997          	auipc	s3,0x1
      f2:	57298993          	addi	s3,s3,1394 # 1660 <ithread_join+0x8c>
      f6:	c489                	beqz	s1,100 <go+0x88>
      f8:	00001997          	auipc	s3,0x1
      fc:	56098993          	addi	s3,s3,1376 # 1658 <ithread_join+0x84>
  uint64 iters = 0;
     100:	4481                	li	s1,0
  int fd = -1;
     102:	5a7d                	li	s4,-1
     104:	00002917          	auipc	s2,0x2
     108:	85890913          	addi	s2,s2,-1960 # 195c <ithread_join+0x388>
     10c:	a839                	j	12a <go+0xb2>
    iters++;
    if((iters % 500) == 0)
      write(1, which_child?"B":"A", 1);
    int what = rand() % 23;
    if(what == 1){
      close(open("grindir/../a", O_CREATE|O_RDWR));
     10e:	20200593          	li	a1,514
     112:	00001517          	auipc	a0,0x1
     116:	55650513          	addi	a0,a0,1366 # 1668 <ithread_join+0x94>
     11a:	00001097          	auipc	ra,0x1
     11e:	d66080e7          	jalr	-666(ra) # e80 <open>
     122:	00001097          	auipc	ra,0x1
     126:	d46080e7          	jalr	-698(ra) # e68 <close>
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
     140:	d24080e7          	jalr	-732(ra) # e60 <write>
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
     174:	50850513          	addi	a0,a0,1288 # 1678 <ithread_join+0xa4>
     178:	00001097          	auipc	ra,0x1
     17c:	d08080e7          	jalr	-760(ra) # e80 <open>
     180:	00001097          	auipc	ra,0x1
     184:	ce8080e7          	jalr	-792(ra) # e68 <close>
     188:	b74d                	j	12a <go+0xb2>
    } else if(what == 3){
      unlink("grindir/../a");
     18a:	00001517          	auipc	a0,0x1
     18e:	4de50513          	addi	a0,a0,1246 # 1668 <ithread_join+0x94>
     192:	00001097          	auipc	ra,0x1
     196:	cfe080e7          	jalr	-770(ra) # e90 <unlink>
     19a:	bf41                	j	12a <go+0xb2>
    } else if(what == 4){
      if(chdir("grindir") != 0){
     19c:	00001517          	auipc	a0,0x1
     1a0:	48450513          	addi	a0,a0,1156 # 1620 <ithread_join+0x4c>
     1a4:	00001097          	auipc	ra,0x1
     1a8:	d0c080e7          	jalr	-756(ra) # eb0 <chdir>
     1ac:	e115                	bnez	a0,1d0 <go+0x158>
        printf("grind: chdir grindir failed\n");
        exit(1);
      }
      unlink("../b");
     1ae:	00001517          	auipc	a0,0x1
     1b2:	4e250513          	addi	a0,a0,1250 # 1690 <ithread_join+0xbc>
     1b6:	00001097          	auipc	ra,0x1
     1ba:	cda080e7          	jalr	-806(ra) # e90 <unlink>
      chdir("/");
     1be:	00001517          	auipc	a0,0x1
     1c2:	49250513          	addi	a0,a0,1170 # 1650 <ithread_join+0x7c>
     1c6:	00001097          	auipc	ra,0x1
     1ca:	cea080e7          	jalr	-790(ra) # eb0 <chdir>
     1ce:	bfb1                	j	12a <go+0xb2>
        printf("grind: chdir grindir failed\n");
     1d0:	00001517          	auipc	a0,0x1
     1d4:	45850513          	addi	a0,a0,1112 # 1628 <ithread_join+0x54>
     1d8:	00001097          	auipc	ra,0x1
     1dc:	03e080e7          	jalr	62(ra) # 1216 <printf>
        exit(1);
     1e0:	4505                	li	a0,1
     1e2:	00001097          	auipc	ra,0x1
     1e6:	c5e080e7          	jalr	-930(ra) # e40 <exit>
    } else if(what == 5){
      close(fd);
     1ea:	8552                	mv	a0,s4
     1ec:	00001097          	auipc	ra,0x1
     1f0:	c7c080e7          	jalr	-900(ra) # e68 <close>
      fd = open("/grindir/../a", O_CREATE|O_RDWR);
     1f4:	20200593          	li	a1,514
     1f8:	00001517          	auipc	a0,0x1
     1fc:	4a050513          	addi	a0,a0,1184 # 1698 <ithread_join+0xc4>
     200:	00001097          	auipc	ra,0x1
     204:	c80080e7          	jalr	-896(ra) # e80 <open>
     208:	8a2a                	mv	s4,a0
     20a:	b705                	j	12a <go+0xb2>
    } else if(what == 6){
      close(fd);
     20c:	8552                	mv	a0,s4
     20e:	00001097          	auipc	ra,0x1
     212:	c5a080e7          	jalr	-934(ra) # e68 <close>
      fd = open("/./grindir/./../b", O_CREATE|O_RDWR);
     216:	20200593          	li	a1,514
     21a:	00001517          	auipc	a0,0x1
     21e:	48e50513          	addi	a0,a0,1166 # 16a8 <ithread_join+0xd4>
     222:	00001097          	auipc	ra,0x1
     226:	c5e080e7          	jalr	-930(ra) # e80 <open>
     22a:	8a2a                	mv	s4,a0
     22c:	bdfd                	j	12a <go+0xb2>
    } else if(what == 7){
      write(fd, buf, sizeof(buf));
     22e:	3e700613          	li	a2,999
     232:	00002597          	auipc	a1,0x2
     236:	dfe58593          	addi	a1,a1,-514 # 2030 <buf.0>
     23a:	8552                	mv	a0,s4
     23c:	00001097          	auipc	ra,0x1
     240:	c24080e7          	jalr	-988(ra) # e60 <write>
     244:	b5dd                	j	12a <go+0xb2>
    } else if(what == 8){
      read(fd, buf, sizeof(buf));
     246:	3e700613          	li	a2,999
     24a:	00002597          	auipc	a1,0x2
     24e:	de658593          	addi	a1,a1,-538 # 2030 <buf.0>
     252:	8552                	mv	a0,s4
     254:	00001097          	auipc	ra,0x1
     258:	c04080e7          	jalr	-1020(ra) # e58 <read>
     25c:	b5f9                	j	12a <go+0xb2>
    } else if(what == 9){
      mkdir("grindir/../a");
     25e:	00001517          	auipc	a0,0x1
     262:	40a50513          	addi	a0,a0,1034 # 1668 <ithread_join+0x94>
     266:	00001097          	auipc	ra,0x1
     26a:	c42080e7          	jalr	-958(ra) # ea8 <mkdir>
      close(open("a/../a/./a", O_CREATE|O_RDWR));
     26e:	20200593          	li	a1,514
     272:	00001517          	auipc	a0,0x1
     276:	44e50513          	addi	a0,a0,1102 # 16c0 <ithread_join+0xec>
     27a:	00001097          	auipc	ra,0x1
     27e:	c06080e7          	jalr	-1018(ra) # e80 <open>
     282:	00001097          	auipc	ra,0x1
     286:	be6080e7          	jalr	-1050(ra) # e68 <close>
      unlink("a/a");
     28a:	00001517          	auipc	a0,0x1
     28e:	44650513          	addi	a0,a0,1094 # 16d0 <ithread_join+0xfc>
     292:	00001097          	auipc	ra,0x1
     296:	bfe080e7          	jalr	-1026(ra) # e90 <unlink>
     29a:	bd41                	j	12a <go+0xb2>
    } else if(what == 10){
      mkdir("/../b");
     29c:	00001517          	auipc	a0,0x1
     2a0:	43c50513          	addi	a0,a0,1084 # 16d8 <ithread_join+0x104>
     2a4:	00001097          	auipc	ra,0x1
     2a8:	c04080e7          	jalr	-1020(ra) # ea8 <mkdir>
      close(open("grindir/../b/b", O_CREATE|O_RDWR));
     2ac:	20200593          	li	a1,514
     2b0:	00001517          	auipc	a0,0x1
     2b4:	43050513          	addi	a0,a0,1072 # 16e0 <ithread_join+0x10c>
     2b8:	00001097          	auipc	ra,0x1
     2bc:	bc8080e7          	jalr	-1080(ra) # e80 <open>
     2c0:	00001097          	auipc	ra,0x1
     2c4:	ba8080e7          	jalr	-1112(ra) # e68 <close>
      unlink("b/b");
     2c8:	00001517          	auipc	a0,0x1
     2cc:	42850513          	addi	a0,a0,1064 # 16f0 <ithread_join+0x11c>
     2d0:	00001097          	auipc	ra,0x1
     2d4:	bc0080e7          	jalr	-1088(ra) # e90 <unlink>
     2d8:	bd89                	j	12a <go+0xb2>
    } else if(what == 11){
      unlink("b");
     2da:	00001517          	auipc	a0,0x1
     2de:	41e50513          	addi	a0,a0,1054 # 16f8 <ithread_join+0x124>
     2e2:	00001097          	auipc	ra,0x1
     2e6:	bae080e7          	jalr	-1106(ra) # e90 <unlink>
      link("../grindir/./../a", "../b");
     2ea:	00001597          	auipc	a1,0x1
     2ee:	3a658593          	addi	a1,a1,934 # 1690 <ithread_join+0xbc>
     2f2:	00001517          	auipc	a0,0x1
     2f6:	40e50513          	addi	a0,a0,1038 # 1700 <ithread_join+0x12c>
     2fa:	00001097          	auipc	ra,0x1
     2fe:	ba6080e7          	jalr	-1114(ra) # ea0 <link>
     302:	b525                	j	12a <go+0xb2>
    } else if(what == 12){
      unlink("../grindir/../a");
     304:	00001517          	auipc	a0,0x1
     308:	41450513          	addi	a0,a0,1044 # 1718 <ithread_join+0x144>
     30c:	00001097          	auipc	ra,0x1
     310:	b84080e7          	jalr	-1148(ra) # e90 <unlink>
      link(".././b", "/grindir/../a");
     314:	00001597          	auipc	a1,0x1
     318:	38458593          	addi	a1,a1,900 # 1698 <ithread_join+0xc4>
     31c:	00001517          	auipc	a0,0x1
     320:	40c50513          	addi	a0,a0,1036 # 1728 <ithread_join+0x154>
     324:	00001097          	auipc	ra,0x1
     328:	b7c080e7          	jalr	-1156(ra) # ea0 <link>
     32c:	bbfd                	j	12a <go+0xb2>
    } else if(what == 13){
      int pid = fork();
     32e:	00001097          	auipc	ra,0x1
     332:	b0a080e7          	jalr	-1270(ra) # e38 <fork>
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
     342:	b0a080e7          	jalr	-1270(ra) # e48 <wait>
     346:	b3d5                	j	12a <go+0xb2>
        exit(0);
     348:	00001097          	auipc	ra,0x1
     34c:	af8080e7          	jalr	-1288(ra) # e40 <exit>
        printf("grind: fork failed\n");
     350:	00001517          	auipc	a0,0x1
     354:	3e050513          	addi	a0,a0,992 # 1730 <ithread_join+0x15c>
     358:	00001097          	auipc	ra,0x1
     35c:	ebe080e7          	jalr	-322(ra) # 1216 <printf>
        exit(1);
     360:	4505                	li	a0,1
     362:	00001097          	auipc	ra,0x1
     366:	ade080e7          	jalr	-1314(ra) # e40 <exit>
    } else if(what == 14){
      int pid = fork();
     36a:	00001097          	auipc	ra,0x1
     36e:	ace080e7          	jalr	-1330(ra) # e38 <fork>
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
     37e:	ace080e7          	jalr	-1330(ra) # e48 <wait>
     382:	b365                	j	12a <go+0xb2>
        fork();
     384:	00001097          	auipc	ra,0x1
     388:	ab4080e7          	jalr	-1356(ra) # e38 <fork>
        fork();
     38c:	00001097          	auipc	ra,0x1
     390:	aac080e7          	jalr	-1364(ra) # e38 <fork>
        exit(0);
     394:	4501                	li	a0,0
     396:	00001097          	auipc	ra,0x1
     39a:	aaa080e7          	jalr	-1366(ra) # e40 <exit>
        printf("grind: fork failed\n");
     39e:	00001517          	auipc	a0,0x1
     3a2:	39250513          	addi	a0,a0,914 # 1730 <ithread_join+0x15c>
     3a6:	00001097          	auipc	ra,0x1
     3aa:	e70080e7          	jalr	-400(ra) # 1216 <printf>
        exit(1);
     3ae:	4505                	li	a0,1
     3b0:	00001097          	auipc	ra,0x1
     3b4:	a90080e7          	jalr	-1392(ra) # e40 <exit>
    } else if(what == 15){
      sbrk(6011);
     3b8:	6505                	lui	a0,0x1
     3ba:	77b50513          	addi	a0,a0,1915 # 177b <ithread_join+0x1a7>
     3be:	00001097          	auipc	ra,0x1
     3c2:	b0a080e7          	jalr	-1270(ra) # ec8 <sbrk>
     3c6:	b395                	j	12a <go+0xb2>
    } else if(what == 16){
      if(sbrk(0) > break0)
     3c8:	4501                	li	a0,0
     3ca:	00001097          	auipc	ra,0x1
     3ce:	afe080e7          	jalr	-1282(ra) # ec8 <sbrk>
     3d2:	d4aafce3          	bgeu	s5,a0,12a <go+0xb2>
        sbrk(-(sbrk(0) - break0));
     3d6:	4501                	li	a0,0
     3d8:	00001097          	auipc	ra,0x1
     3dc:	af0080e7          	jalr	-1296(ra) # ec8 <sbrk>
     3e0:	40aa853b          	subw	a0,s5,a0
     3e4:	00001097          	auipc	ra,0x1
     3e8:	ae4080e7          	jalr	-1308(ra) # ec8 <sbrk>
     3ec:	bb3d                	j	12a <go+0xb2>
    } else if(what == 17){
      int pid = fork();
     3ee:	00001097          	auipc	ra,0x1
     3f2:	a4a080e7          	jalr	-1462(ra) # e38 <fork>
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
     402:	35250513          	addi	a0,a0,850 # 1750 <ithread_join+0x17c>
     406:	00001097          	auipc	ra,0x1
     40a:	aaa080e7          	jalr	-1366(ra) # eb0 <chdir>
     40e:	ed21                	bnez	a0,466 <go+0x3ee>
        printf("grind: chdir failed\n");
        exit(1);
      }
      kill(pid);
     410:	855a                	mv	a0,s6
     412:	00001097          	auipc	ra,0x1
     416:	a5e080e7          	jalr	-1442(ra) # e70 <kill>
      wait(0);
     41a:	4501                	li	a0,0
     41c:	00001097          	auipc	ra,0x1
     420:	a2c080e7          	jalr	-1492(ra) # e48 <wait>
     424:	b319                	j	12a <go+0xb2>
        close(open("a", O_CREATE|O_RDWR));
     426:	20200593          	li	a1,514
     42a:	00001517          	auipc	a0,0x1
     42e:	31e50513          	addi	a0,a0,798 # 1748 <ithread_join+0x174>
     432:	00001097          	auipc	ra,0x1
     436:	a4e080e7          	jalr	-1458(ra) # e80 <open>
     43a:	00001097          	auipc	ra,0x1
     43e:	a2e080e7          	jalr	-1490(ra) # e68 <close>
        exit(0);
     442:	4501                	li	a0,0
     444:	00001097          	auipc	ra,0x1
     448:	9fc080e7          	jalr	-1540(ra) # e40 <exit>
        printf("grind: fork failed\n");
     44c:	00001517          	auipc	a0,0x1
     450:	2e450513          	addi	a0,a0,740 # 1730 <ithread_join+0x15c>
     454:	00001097          	auipc	ra,0x1
     458:	dc2080e7          	jalr	-574(ra) # 1216 <printf>
        exit(1);
     45c:	4505                	li	a0,1
     45e:	00001097          	auipc	ra,0x1
     462:	9e2080e7          	jalr	-1566(ra) # e40 <exit>
        printf("grind: chdir failed\n");
     466:	00001517          	auipc	a0,0x1
     46a:	2fa50513          	addi	a0,a0,762 # 1760 <ithread_join+0x18c>
     46e:	00001097          	auipc	ra,0x1
     472:	da8080e7          	jalr	-600(ra) # 1216 <printf>
        exit(1);
     476:	4505                	li	a0,1
     478:	00001097          	auipc	ra,0x1
     47c:	9c8080e7          	jalr	-1592(ra) # e40 <exit>
    } else if(what == 18){
      int pid = fork();
     480:	00001097          	auipc	ra,0x1
     484:	9b8080e7          	jalr	-1608(ra) # e38 <fork>
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
     494:	9b8080e7          	jalr	-1608(ra) # e48 <wait>
     498:	b949                	j	12a <go+0xb2>
        kill(getpid());
     49a:	00001097          	auipc	ra,0x1
     49e:	a26080e7          	jalr	-1498(ra) # ec0 <getpid>
     4a2:	00001097          	auipc	ra,0x1
     4a6:	9ce080e7          	jalr	-1586(ra) # e70 <kill>
        exit(0);
     4aa:	4501                	li	a0,0
     4ac:	00001097          	auipc	ra,0x1
     4b0:	994080e7          	jalr	-1644(ra) # e40 <exit>
        printf("grind: fork failed\n");
     4b4:	00001517          	auipc	a0,0x1
     4b8:	27c50513          	addi	a0,a0,636 # 1730 <ithread_join+0x15c>
     4bc:	00001097          	auipc	ra,0x1
     4c0:	d5a080e7          	jalr	-678(ra) # 1216 <printf>
        exit(1);
     4c4:	4505                	li	a0,1
     4c6:	00001097          	auipc	ra,0x1
     4ca:	97a080e7          	jalr	-1670(ra) # e40 <exit>
    } else if(what == 19){
      int fds[2];
      if(pipe(fds) < 0){
     4ce:	fa840513          	addi	a0,s0,-88
     4d2:	00001097          	auipc	ra,0x1
     4d6:	97e080e7          	jalr	-1666(ra) # e50 <pipe>
     4da:	02054b63          	bltz	a0,510 <go+0x498>
        printf("grind: pipe failed\n");
        exit(1);
      }
      int pid = fork();
     4de:	00001097          	auipc	ra,0x1
     4e2:	95a080e7          	jalr	-1702(ra) # e38 <fork>
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
     4f4:	978080e7          	jalr	-1672(ra) # e68 <close>
      close(fds[1]);
     4f8:	fac42503          	lw	a0,-84(s0)
     4fc:	00001097          	auipc	ra,0x1
     500:	96c080e7          	jalr	-1684(ra) # e68 <close>
      wait(0);
     504:	4501                	li	a0,0
     506:	00001097          	auipc	ra,0x1
     50a:	942080e7          	jalr	-1726(ra) # e48 <wait>
     50e:	b931                	j	12a <go+0xb2>
        printf("grind: pipe failed\n");
     510:	00001517          	auipc	a0,0x1
     514:	26850513          	addi	a0,a0,616 # 1778 <ithread_join+0x1a4>
     518:	00001097          	auipc	ra,0x1
     51c:	cfe080e7          	jalr	-770(ra) # 1216 <printf>
        exit(1);
     520:	4505                	li	a0,1
     522:	00001097          	auipc	ra,0x1
     526:	91e080e7          	jalr	-1762(ra) # e40 <exit>
        fork();
     52a:	00001097          	auipc	ra,0x1
     52e:	90e080e7          	jalr	-1778(ra) # e38 <fork>
        fork();
     532:	00001097          	auipc	ra,0x1
     536:	906080e7          	jalr	-1786(ra) # e38 <fork>
        if(write(fds[1], "x", 1) != 1)
     53a:	4605                	li	a2,1
     53c:	00001597          	auipc	a1,0x1
     540:	25458593          	addi	a1,a1,596 # 1790 <ithread_join+0x1bc>
     544:	fac42503          	lw	a0,-84(s0)
     548:	00001097          	auipc	ra,0x1
     54c:	918080e7          	jalr	-1768(ra) # e60 <write>
     550:	4785                	li	a5,1
     552:	02f51363          	bne	a0,a5,578 <go+0x500>
        if(read(fds[0], &c, 1) != 1)
     556:	4605                	li	a2,1
     558:	fa040593          	addi	a1,s0,-96
     55c:	fa842503          	lw	a0,-88(s0)
     560:	00001097          	auipc	ra,0x1
     564:	8f8080e7          	jalr	-1800(ra) # e58 <read>
     568:	4785                	li	a5,1
     56a:	02f51063          	bne	a0,a5,58a <go+0x512>
        exit(0);
     56e:	4501                	li	a0,0
     570:	00001097          	auipc	ra,0x1
     574:	8d0080e7          	jalr	-1840(ra) # e40 <exit>
          printf("grind: pipe write failed\n");
     578:	00001517          	auipc	a0,0x1
     57c:	22050513          	addi	a0,a0,544 # 1798 <ithread_join+0x1c4>
     580:	00001097          	auipc	ra,0x1
     584:	c96080e7          	jalr	-874(ra) # 1216 <printf>
     588:	b7f9                	j	556 <go+0x4de>
          printf("grind: pipe read failed\n");
     58a:	00001517          	auipc	a0,0x1
     58e:	22e50513          	addi	a0,a0,558 # 17b8 <ithread_join+0x1e4>
     592:	00001097          	auipc	ra,0x1
     596:	c84080e7          	jalr	-892(ra) # 1216 <printf>
     59a:	bfd1                	j	56e <go+0x4f6>
        printf("grind: fork failed\n");
     59c:	00001517          	auipc	a0,0x1
     5a0:	19450513          	addi	a0,a0,404 # 1730 <ithread_join+0x15c>
     5a4:	00001097          	auipc	ra,0x1
     5a8:	c72080e7          	jalr	-910(ra) # 1216 <printf>
        exit(1);
     5ac:	4505                	li	a0,1
     5ae:	00001097          	auipc	ra,0x1
     5b2:	892080e7          	jalr	-1902(ra) # e40 <exit>
    } else if(what == 20){
      int pid = fork();
     5b6:	00001097          	auipc	ra,0x1
     5ba:	882080e7          	jalr	-1918(ra) # e38 <fork>
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
     5ca:	882080e7          	jalr	-1918(ra) # e48 <wait>
     5ce:	beb1                	j	12a <go+0xb2>
        unlink("a");
     5d0:	00001517          	auipc	a0,0x1
     5d4:	17850513          	addi	a0,a0,376 # 1748 <ithread_join+0x174>
     5d8:	00001097          	auipc	ra,0x1
     5dc:	8b8080e7          	jalr	-1864(ra) # e90 <unlink>
        mkdir("a");
     5e0:	00001517          	auipc	a0,0x1
     5e4:	16850513          	addi	a0,a0,360 # 1748 <ithread_join+0x174>
     5e8:	00001097          	auipc	ra,0x1
     5ec:	8c0080e7          	jalr	-1856(ra) # ea8 <mkdir>
        chdir("a");
     5f0:	00001517          	auipc	a0,0x1
     5f4:	15850513          	addi	a0,a0,344 # 1748 <ithread_join+0x174>
     5f8:	00001097          	auipc	ra,0x1
     5fc:	8b8080e7          	jalr	-1864(ra) # eb0 <chdir>
        unlink("../a");
     600:	00001517          	auipc	a0,0x1
     604:	1d850513          	addi	a0,a0,472 # 17d8 <ithread_join+0x204>
     608:	00001097          	auipc	ra,0x1
     60c:	888080e7          	jalr	-1912(ra) # e90 <unlink>
        fd = open("x", O_CREATE|O_RDWR);
     610:	20200593          	li	a1,514
     614:	00001517          	auipc	a0,0x1
     618:	17c50513          	addi	a0,a0,380 # 1790 <ithread_join+0x1bc>
     61c:	00001097          	auipc	ra,0x1
     620:	864080e7          	jalr	-1948(ra) # e80 <open>
        unlink("x");
     624:	00001517          	auipc	a0,0x1
     628:	16c50513          	addi	a0,a0,364 # 1790 <ithread_join+0x1bc>
     62c:	00001097          	auipc	ra,0x1
     630:	864080e7          	jalr	-1948(ra) # e90 <unlink>
        exit(0);
     634:	4501                	li	a0,0
     636:	00001097          	auipc	ra,0x1
     63a:	80a080e7          	jalr	-2038(ra) # e40 <exit>
        printf("grind: fork failed\n");
     63e:	00001517          	auipc	a0,0x1
     642:	0f250513          	addi	a0,a0,242 # 1730 <ithread_join+0x15c>
     646:	00001097          	auipc	ra,0x1
     64a:	bd0080e7          	jalr	-1072(ra) # 1216 <printf>
        exit(1);
     64e:	4505                	li	a0,1
     650:	00000097          	auipc	ra,0x0
     654:	7f0080e7          	jalr	2032(ra) # e40 <exit>
    } else if(what == 21){
      unlink("c");
     658:	00001517          	auipc	a0,0x1
     65c:	18850513          	addi	a0,a0,392 # 17e0 <ithread_join+0x20c>
     660:	00001097          	auipc	ra,0x1
     664:	830080e7          	jalr	-2000(ra) # e90 <unlink>
      // should always succeed. check that there are free i-nodes,
      // file descriptors, blocks.
      int fd1 = open("c", O_CREATE|O_RDWR);
     668:	20200593          	li	a1,514
     66c:	00001517          	auipc	a0,0x1
     670:	17450513          	addi	a0,a0,372 # 17e0 <ithread_join+0x20c>
     674:	00001097          	auipc	ra,0x1
     678:	80c080e7          	jalr	-2036(ra) # e80 <open>
     67c:	8b2a                	mv	s6,a0
      if(fd1 < 0){
     67e:	04054f63          	bltz	a0,6dc <go+0x664>
        printf("grind: create c failed\n");
        exit(1);
      }
      if(write(fd1, "x", 1) != 1){
     682:	4605                	li	a2,1
     684:	00001597          	auipc	a1,0x1
     688:	10c58593          	addi	a1,a1,268 # 1790 <ithread_join+0x1bc>
     68c:	00000097          	auipc	ra,0x0
     690:	7d4080e7          	jalr	2004(ra) # e60 <write>
     694:	4785                	li	a5,1
     696:	06f51063          	bne	a0,a5,6f6 <go+0x67e>
        printf("grind: write c failed\n");
        exit(1);
      }
      struct stat st;
      if(fstat(fd1, &st) != 0){
     69a:	fa840593          	addi	a1,s0,-88
     69e:	855a                	mv	a0,s6
     6a0:	00000097          	auipc	ra,0x0
     6a4:	7f8080e7          	jalr	2040(ra) # e98 <fstat>
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
     6c2:	00000097          	auipc	ra,0x0
     6c6:	7a6080e7          	jalr	1958(ra) # e68 <close>
      unlink("c");
     6ca:	00001517          	auipc	a0,0x1
     6ce:	11650513          	addi	a0,a0,278 # 17e0 <ithread_join+0x20c>
     6d2:	00000097          	auipc	ra,0x0
     6d6:	7be080e7          	jalr	1982(ra) # e90 <unlink>
     6da:	bc81                	j	12a <go+0xb2>
        printf("grind: create c failed\n");
     6dc:	00001517          	auipc	a0,0x1
     6e0:	10c50513          	addi	a0,a0,268 # 17e8 <ithread_join+0x214>
     6e4:	00001097          	auipc	ra,0x1
     6e8:	b32080e7          	jalr	-1230(ra) # 1216 <printf>
        exit(1);
     6ec:	4505                	li	a0,1
     6ee:	00000097          	auipc	ra,0x0
     6f2:	752080e7          	jalr	1874(ra) # e40 <exit>
        printf("grind: write c failed\n");
     6f6:	00001517          	auipc	a0,0x1
     6fa:	10a50513          	addi	a0,a0,266 # 1800 <ithread_join+0x22c>
     6fe:	00001097          	auipc	ra,0x1
     702:	b18080e7          	jalr	-1256(ra) # 1216 <printf>
        exit(1);
     706:	4505                	li	a0,1
     708:	00000097          	auipc	ra,0x0
     70c:	738080e7          	jalr	1848(ra) # e40 <exit>
        printf("grind: fstat failed\n");
     710:	00001517          	auipc	a0,0x1
     714:	10850513          	addi	a0,a0,264 # 1818 <ithread_join+0x244>
     718:	00001097          	auipc	ra,0x1
     71c:	afe080e7          	jalr	-1282(ra) # 1216 <printf>
        exit(1);
     720:	4505                	li	a0,1
     722:	00000097          	auipc	ra,0x0
     726:	71e080e7          	jalr	1822(ra) # e40 <exit>
        printf("grind: fstat reports wrong size %d\n", (int)st.size);
     72a:	2581                	sext.w	a1,a1
     72c:	00001517          	auipc	a0,0x1
     730:	10450513          	addi	a0,a0,260 # 1830 <ithread_join+0x25c>
     734:	00001097          	auipc	ra,0x1
     738:	ae2080e7          	jalr	-1310(ra) # 1216 <printf>
        exit(1);
     73c:	4505                	li	a0,1
     73e:	00000097          	auipc	ra,0x0
     742:	702080e7          	jalr	1794(ra) # e40 <exit>
        printf("grind: fstat reports crazy i-number %d\n", st.ino);
     746:	00001517          	auipc	a0,0x1
     74a:	11250513          	addi	a0,a0,274 # 1858 <ithread_join+0x284>
     74e:	00001097          	auipc	ra,0x1
     752:	ac8080e7          	jalr	-1336(ra) # 1216 <printf>
        exit(1);
     756:	4505                	li	a0,1
     758:	00000097          	auipc	ra,0x0
     75c:	6e8080e7          	jalr	1768(ra) # e40 <exit>
    } else if(what == 22){
      // echo hi | cat
      int aa[2], bb[2];
      if(pipe(aa) < 0){
     760:	f9840513          	addi	a0,s0,-104
     764:	00000097          	auipc	ra,0x0
     768:	6ec080e7          	jalr	1772(ra) # e50 <pipe>
     76c:	10054063          	bltz	a0,86c <go+0x7f4>
        fprintf(2, "grind: pipe failed\n");
        exit(1);
      }
      if(pipe(bb) < 0){
     770:	fa040513          	addi	a0,s0,-96
     774:	00000097          	auipc	ra,0x0
     778:	6dc080e7          	jalr	1756(ra) # e50 <pipe>
     77c:	10054663          	bltz	a0,888 <go+0x810>
        fprintf(2, "grind: pipe failed\n");
        exit(1);
      }
      int pid1 = fork();
     780:	00000097          	auipc	ra,0x0
     784:	6b8080e7          	jalr	1720(ra) # e38 <fork>
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
     794:	6a8080e7          	jalr	1704(ra) # e38 <fork>
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
     7a8:	6c4080e7          	jalr	1732(ra) # e68 <close>
      close(aa[1]);
     7ac:	f9c42503          	lw	a0,-100(s0)
     7b0:	00000097          	auipc	ra,0x0
     7b4:	6b8080e7          	jalr	1720(ra) # e68 <close>
      close(bb[1]);
     7b8:	fa442503          	lw	a0,-92(s0)
     7bc:	00000097          	auipc	ra,0x0
     7c0:	6ac080e7          	jalr	1708(ra) # e68 <close>
      char buf[4] = { 0, 0, 0, 0 };
     7c4:	f8042823          	sw	zero,-112(s0)
      read(bb[0], buf+0, 1);
     7c8:	4605                	li	a2,1
     7ca:	f9040593          	addi	a1,s0,-112
     7ce:	fa042503          	lw	a0,-96(s0)
     7d2:	00000097          	auipc	ra,0x0
     7d6:	686080e7          	jalr	1670(ra) # e58 <read>
      read(bb[0], buf+1, 1);
     7da:	4605                	li	a2,1
     7dc:	f9140593          	addi	a1,s0,-111
     7e0:	fa042503          	lw	a0,-96(s0)
     7e4:	00000097          	auipc	ra,0x0
     7e8:	674080e7          	jalr	1652(ra) # e58 <read>
      read(bb[0], buf+2, 1);
     7ec:	4605                	li	a2,1
     7ee:	f9240593          	addi	a1,s0,-110
     7f2:	fa042503          	lw	a0,-96(s0)
     7f6:	00000097          	auipc	ra,0x0
     7fa:	662080e7          	jalr	1634(ra) # e58 <read>
      close(bb[0]);
     7fe:	fa042503          	lw	a0,-96(s0)
     802:	00000097          	auipc	ra,0x0
     806:	666080e7          	jalr	1638(ra) # e68 <close>
      int st1, st2;
      wait(&st1);
     80a:	f9440513          	addi	a0,s0,-108
     80e:	00000097          	auipc	ra,0x0
     812:	63a080e7          	jalr	1594(ra) # e48 <wait>
      wait(&st2);
     816:	fa840513          	addi	a0,s0,-88
     81a:	00000097          	auipc	ra,0x0
     81e:	62e080e7          	jalr	1582(ra) # e48 <wait>
      if(st1 != 0 || st2 != 0 || strcmp(buf, "hi\n") != 0){
     822:	f9442783          	lw	a5,-108(s0)
     826:	fa842703          	lw	a4,-88(s0)
     82a:	8fd9                	or	a5,a5,a4
     82c:	ef89                	bnez	a5,846 <go+0x7ce>
     82e:	00001597          	auipc	a1,0x1
     832:	0ca58593          	addi	a1,a1,202 # 18f8 <ithread_join+0x324>
     836:	f9040513          	addi	a0,s0,-112
     83a:	00000097          	auipc	ra,0x0
     83e:	3b6080e7          	jalr	950(ra) # bf0 <strcmp>
     842:	8e0504e3          	beqz	a0,12a <go+0xb2>
        printf("grind: exec pipeline failed %d %d \"%s\"\n", st1, st2, buf);
     846:	f9040693          	addi	a3,s0,-112
     84a:	fa842603          	lw	a2,-88(s0)
     84e:	f9442583          	lw	a1,-108(s0)
     852:	00001517          	auipc	a0,0x1
     856:	0ae50513          	addi	a0,a0,174 # 1900 <ithread_join+0x32c>
     85a:	00001097          	auipc	ra,0x1
     85e:	9bc080e7          	jalr	-1604(ra) # 1216 <printf>
        exit(1);
     862:	4505                	li	a0,1
     864:	00000097          	auipc	ra,0x0
     868:	5dc080e7          	jalr	1500(ra) # e40 <exit>
        fprintf(2, "grind: pipe failed\n");
     86c:	00001597          	auipc	a1,0x1
     870:	f0c58593          	addi	a1,a1,-244 # 1778 <ithread_join+0x1a4>
     874:	4509                	li	a0,2
     876:	00001097          	auipc	ra,0x1
     87a:	972080e7          	jalr	-1678(ra) # 11e8 <fprintf>
        exit(1);
     87e:	4505                	li	a0,1
     880:	00000097          	auipc	ra,0x0
     884:	5c0080e7          	jalr	1472(ra) # e40 <exit>
        fprintf(2, "grind: pipe failed\n");
     888:	00001597          	auipc	a1,0x1
     88c:	ef058593          	addi	a1,a1,-272 # 1778 <ithread_join+0x1a4>
     890:	4509                	li	a0,2
     892:	00001097          	auipc	ra,0x1
     896:	956080e7          	jalr	-1706(ra) # 11e8 <fprintf>
        exit(1);
     89a:	4505                	li	a0,1
     89c:	00000097          	auipc	ra,0x0
     8a0:	5a4080e7          	jalr	1444(ra) # e40 <exit>
        close(bb[0]);
     8a4:	fa042503          	lw	a0,-96(s0)
     8a8:	00000097          	auipc	ra,0x0
     8ac:	5c0080e7          	jalr	1472(ra) # e68 <close>
        close(bb[1]);
     8b0:	fa442503          	lw	a0,-92(s0)
     8b4:	00000097          	auipc	ra,0x0
     8b8:	5b4080e7          	jalr	1460(ra) # e68 <close>
        close(aa[0]);
     8bc:	f9842503          	lw	a0,-104(s0)
     8c0:	00000097          	auipc	ra,0x0
     8c4:	5a8080e7          	jalr	1448(ra) # e68 <close>
        close(1);
     8c8:	4505                	li	a0,1
     8ca:	00000097          	auipc	ra,0x0
     8ce:	59e080e7          	jalr	1438(ra) # e68 <close>
        if(dup(aa[1]) != 1){
     8d2:	f9c42503          	lw	a0,-100(s0)
     8d6:	00000097          	auipc	ra,0x0
     8da:	5e2080e7          	jalr	1506(ra) # eb8 <dup>
     8de:	4785                	li	a5,1
     8e0:	02f50063          	beq	a0,a5,900 <go+0x888>
          fprintf(2, "grind: dup failed\n");
     8e4:	00001597          	auipc	a1,0x1
     8e8:	f9c58593          	addi	a1,a1,-100 # 1880 <ithread_join+0x2ac>
     8ec:	4509                	li	a0,2
     8ee:	00001097          	auipc	ra,0x1
     8f2:	8fa080e7          	jalr	-1798(ra) # 11e8 <fprintf>
          exit(1);
     8f6:	4505                	li	a0,1
     8f8:	00000097          	auipc	ra,0x0
     8fc:	548080e7          	jalr	1352(ra) # e40 <exit>
        close(aa[1]);
     900:	f9c42503          	lw	a0,-100(s0)
     904:	00000097          	auipc	ra,0x0
     908:	564080e7          	jalr	1380(ra) # e68 <close>
        char *args[3] = { "echo", "hi", 0 };
     90c:	00001797          	auipc	a5,0x1
     910:	f8c78793          	addi	a5,a5,-116 # 1898 <ithread_join+0x2c4>
     914:	faf43423          	sd	a5,-88(s0)
     918:	00001797          	auipc	a5,0x1
     91c:	f8878793          	addi	a5,a5,-120 # 18a0 <ithread_join+0x2cc>
     920:	faf43823          	sd	a5,-80(s0)
     924:	fa043c23          	sd	zero,-72(s0)
        exec("grindir/../echo", args);
     928:	fa840593          	addi	a1,s0,-88
     92c:	00001517          	auipc	a0,0x1
     930:	f7c50513          	addi	a0,a0,-132 # 18a8 <ithread_join+0x2d4>
     934:	00000097          	auipc	ra,0x0
     938:	544080e7          	jalr	1348(ra) # e78 <exec>
        fprintf(2, "grind: echo: not found\n");
     93c:	00001597          	auipc	a1,0x1
     940:	f7c58593          	addi	a1,a1,-132 # 18b8 <ithread_join+0x2e4>
     944:	4509                	li	a0,2
     946:	00001097          	auipc	ra,0x1
     94a:	8a2080e7          	jalr	-1886(ra) # 11e8 <fprintf>
        exit(2);
     94e:	4509                	li	a0,2
     950:	00000097          	auipc	ra,0x0
     954:	4f0080e7          	jalr	1264(ra) # e40 <exit>
        fprintf(2, "grind: fork failed\n");
     958:	00001597          	auipc	a1,0x1
     95c:	dd858593          	addi	a1,a1,-552 # 1730 <ithread_join+0x15c>
     960:	4509                	li	a0,2
     962:	00001097          	auipc	ra,0x1
     966:	886080e7          	jalr	-1914(ra) # 11e8 <fprintf>
        exit(3);
     96a:	450d                	li	a0,3
     96c:	00000097          	auipc	ra,0x0
     970:	4d4080e7          	jalr	1236(ra) # e40 <exit>
        close(aa[1]);
     974:	f9c42503          	lw	a0,-100(s0)
     978:	00000097          	auipc	ra,0x0
     97c:	4f0080e7          	jalr	1264(ra) # e68 <close>
        close(bb[0]);
     980:	fa042503          	lw	a0,-96(s0)
     984:	00000097          	auipc	ra,0x0
     988:	4e4080e7          	jalr	1252(ra) # e68 <close>
        close(0);
     98c:	4501                	li	a0,0
     98e:	00000097          	auipc	ra,0x0
     992:	4da080e7          	jalr	1242(ra) # e68 <close>
        if(dup(aa[0]) != 0){
     996:	f9842503          	lw	a0,-104(s0)
     99a:	00000097          	auipc	ra,0x0
     99e:	51e080e7          	jalr	1310(ra) # eb8 <dup>
     9a2:	cd19                	beqz	a0,9c0 <go+0x948>
          fprintf(2, "grind: dup failed\n");
     9a4:	00001597          	auipc	a1,0x1
     9a8:	edc58593          	addi	a1,a1,-292 # 1880 <ithread_join+0x2ac>
     9ac:	4509                	li	a0,2
     9ae:	00001097          	auipc	ra,0x1
     9b2:	83a080e7          	jalr	-1990(ra) # 11e8 <fprintf>
          exit(4);
     9b6:	4511                	li	a0,4
     9b8:	00000097          	auipc	ra,0x0
     9bc:	488080e7          	jalr	1160(ra) # e40 <exit>
        close(aa[0]);
     9c0:	f9842503          	lw	a0,-104(s0)
     9c4:	00000097          	auipc	ra,0x0
     9c8:	4a4080e7          	jalr	1188(ra) # e68 <close>
        close(1);
     9cc:	4505                	li	a0,1
     9ce:	00000097          	auipc	ra,0x0
     9d2:	49a080e7          	jalr	1178(ra) # e68 <close>
        if(dup(bb[1]) != 1){
     9d6:	fa442503          	lw	a0,-92(s0)
     9da:	00000097          	auipc	ra,0x0
     9de:	4de080e7          	jalr	1246(ra) # eb8 <dup>
     9e2:	4785                	li	a5,1
     9e4:	02f50063          	beq	a0,a5,a04 <go+0x98c>
          fprintf(2, "grind: dup failed\n");
     9e8:	00001597          	auipc	a1,0x1
     9ec:	e9858593          	addi	a1,a1,-360 # 1880 <ithread_join+0x2ac>
     9f0:	4509                	li	a0,2
     9f2:	00000097          	auipc	ra,0x0
     9f6:	7f6080e7          	jalr	2038(ra) # 11e8 <fprintf>
          exit(5);
     9fa:	4515                	li	a0,5
     9fc:	00000097          	auipc	ra,0x0
     a00:	444080e7          	jalr	1092(ra) # e40 <exit>
        close(bb[1]);
     a04:	fa442503          	lw	a0,-92(s0)
     a08:	00000097          	auipc	ra,0x0
     a0c:	460080e7          	jalr	1120(ra) # e68 <close>
        char *args[2] = { "cat", 0 };
     a10:	00001797          	auipc	a5,0x1
     a14:	ec078793          	addi	a5,a5,-320 # 18d0 <ithread_join+0x2fc>
     a18:	faf43423          	sd	a5,-88(s0)
     a1c:	fa043823          	sd	zero,-80(s0)
        exec("/cat", args);
     a20:	fa840593          	addi	a1,s0,-88
     a24:	00001517          	auipc	a0,0x1
     a28:	eb450513          	addi	a0,a0,-332 # 18d8 <ithread_join+0x304>
     a2c:	00000097          	auipc	ra,0x0
     a30:	44c080e7          	jalr	1100(ra) # e78 <exec>
        fprintf(2, "grind: cat: not found\n");
     a34:	00001597          	auipc	a1,0x1
     a38:	eac58593          	addi	a1,a1,-340 # 18e0 <ithread_join+0x30c>
     a3c:	4509                	li	a0,2
     a3e:	00000097          	auipc	ra,0x0
     a42:	7aa080e7          	jalr	1962(ra) # 11e8 <fprintf>
        exit(6);
     a46:	4519                	li	a0,6
     a48:	00000097          	auipc	ra,0x0
     a4c:	3f8080e7          	jalr	1016(ra) # e40 <exit>
        fprintf(2, "grind: fork failed\n");
     a50:	00001597          	auipc	a1,0x1
     a54:	ce058593          	addi	a1,a1,-800 # 1730 <ithread_join+0x15c>
     a58:	4509                	li	a0,2
     a5a:	00000097          	auipc	ra,0x0
     a5e:	78e080e7          	jalr	1934(ra) # 11e8 <fprintf>
        exit(7);
     a62:	451d                	li	a0,7
     a64:	00000097          	auipc	ra,0x0
     a68:	3dc080e7          	jalr	988(ra) # e40 <exit>

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
     a78:	cd450513          	addi	a0,a0,-812 # 1748 <ithread_join+0x174>
     a7c:	00000097          	auipc	ra,0x0
     a80:	414080e7          	jalr	1044(ra) # e90 <unlink>
  unlink("b");
     a84:	00001517          	auipc	a0,0x1
     a88:	c7450513          	addi	a0,a0,-908 # 16f8 <ithread_join+0x124>
     a8c:	00000097          	auipc	ra,0x0
     a90:	404080e7          	jalr	1028(ra) # e90 <unlink>
  
  int pid1 = fork();
     a94:	00000097          	auipc	ra,0x0
     a98:	3a4080e7          	jalr	932(ra) # e38 <fork>
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
     aca:	c6a50513          	addi	a0,a0,-918 # 1730 <ithread_join+0x15c>
     ace:	00000097          	auipc	ra,0x0
     ad2:	748080e7          	jalr	1864(ra) # 1216 <printf>
    exit(1);
     ad6:	4505                	li	a0,1
     ad8:	00000097          	auipc	ra,0x0
     adc:	368080e7          	jalr	872(ra) # e40 <exit>
     ae0:	e84a                	sd	s2,16(sp)
    exit(0);
  }

  int pid2 = fork();
     ae2:	00000097          	auipc	ra,0x0
     ae6:	356080e7          	jalr	854(ra) # e38 <fork>
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
     afe:	c0970713          	addi	a4,a4,-1015 # 1c09 <digits+0x1f9>
     b02:	8fb9                	xor	a5,a5,a4
     b04:	e29c                	sd	a5,0(a3)
    go(1);
     b06:	4505                	li	a0,1
     b08:	fffff097          	auipc	ra,0xfffff
     b0c:	570080e7          	jalr	1392(ra) # 78 <go>
    printf("grind: fork failed\n");
     b10:	00001517          	auipc	a0,0x1
     b14:	c2050513          	addi	a0,a0,-992 # 1730 <ithread_join+0x15c>
     b18:	00000097          	auipc	ra,0x0
     b1c:	6fe080e7          	jalr	1790(ra) # 1216 <printf>
    exit(1);
     b20:	4505                	li	a0,1
     b22:	00000097          	auipc	ra,0x0
     b26:	31e080e7          	jalr	798(ra) # e40 <exit>
    exit(0);
  }

  int st1 = -1;
     b2a:	57fd                	li	a5,-1
     b2c:	fcf42e23          	sw	a5,-36(s0)
  wait(&st1);
     b30:	fdc40513          	addi	a0,s0,-36
     b34:	00000097          	auipc	ra,0x0
     b38:	314080e7          	jalr	788(ra) # e48 <wait>
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
     b50:	2fc080e7          	jalr	764(ra) # e48 <wait>

  exit(0);
     b54:	4501                	li	a0,0
     b56:	00000097          	auipc	ra,0x0
     b5a:	2ea080e7          	jalr	746(ra) # e40 <exit>
    kill(pid1);
     b5e:	8526                	mv	a0,s1
     b60:	00000097          	auipc	ra,0x0
     b64:	310080e7          	jalr	784(ra) # e70 <kill>
    kill(pid2);
     b68:	854a                	mv	a0,s2
     b6a:	00000097          	auipc	ra,0x0
     b6e:	306080e7          	jalr	774(ra) # e70 <kill>
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
     b96:	33e080e7          	jalr	830(ra) # ed0 <sleep>
    rand_next += 1;
     b9a:	609c                	ld	a5,0(s1)
     b9c:	0785                	addi	a5,a5,1
     b9e:	e09c                	sd	a5,0(s1)
    int pid = fork();
     ba0:	00000097          	auipc	ra,0x0
     ba4:	298080e7          	jalr	664(ra) # e38 <fork>
    if(pid == 0){
     ba8:	d165                	beqz	a0,b88 <main+0x14>
    if(pid > 0){
     baa:	fea053e3          	blez	a0,b90 <main+0x1c>
      wait(0);
     bae:	4501                	li	a0,0
     bb0:	00000097          	auipc	ra,0x0
     bb4:	298080e7          	jalr	664(ra) # e48 <wait>
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
     bd0:	274080e7          	jalr	628(ra) # e40 <exit>

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
     cc2:	19a080e7          	jalr	410(ra) # e58 <read>
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

0000000000000d00 <stat>:

int
stat(const char *n, struct stat *st)
{
     d00:	1101                	addi	sp,sp,-32
     d02:	ec06                	sd	ra,24(sp)
     d04:	e822                	sd	s0,16(sp)
     d06:	e04a                	sd	s2,0(sp)
     d08:	1000                	addi	s0,sp,32
     d0a:	892e                	mv	s2,a1
  int fd;
  int r;

  fd = open(n, O_RDONLY);
     d0c:	4581                	li	a1,0
     d0e:	00000097          	auipc	ra,0x0
     d12:	172080e7          	jalr	370(ra) # e80 <open>
  if(fd < 0)
     d16:	02054663          	bltz	a0,d42 <stat+0x42>
     d1a:	e426                	sd	s1,8(sp)
     d1c:	84aa                	mv	s1,a0
    return -1;
  r = fstat(fd, st);
     d1e:	85ca                	mv	a1,s2
     d20:	00000097          	auipc	ra,0x0
     d24:	178080e7          	jalr	376(ra) # e98 <fstat>
     d28:	892a                	mv	s2,a0
  close(fd);
     d2a:	8526                	mv	a0,s1
     d2c:	00000097          	auipc	ra,0x0
     d30:	13c080e7          	jalr	316(ra) # e68 <close>
  return r;
     d34:	64a2                	ld	s1,8(sp)
}
     d36:	854a                	mv	a0,s2
     d38:	60e2                	ld	ra,24(sp)
     d3a:	6442                	ld	s0,16(sp)
     d3c:	6902                	ld	s2,0(sp)
     d3e:	6105                	addi	sp,sp,32
     d40:	8082                	ret
    return -1;
     d42:	597d                	li	s2,-1
     d44:	bfcd                	j	d36 <stat+0x36>

0000000000000d46 <atoi>:

int
atoi(const char *s)
{
     d46:	1141                	addi	sp,sp,-16
     d48:	e422                	sd	s0,8(sp)
     d4a:	0800                	addi	s0,sp,16
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
     d4c:	00054683          	lbu	a3,0(a0)
     d50:	fd06879b          	addiw	a5,a3,-48
     d54:	0ff7f793          	zext.b	a5,a5
     d58:	4625                	li	a2,9
     d5a:	02f66863          	bltu	a2,a5,d8a <atoi+0x44>
     d5e:	872a                	mv	a4,a0
  n = 0;
     d60:	4501                	li	a0,0
    n = n*10 + *s++ - '0';
     d62:	0705                	addi	a4,a4,1
     d64:	0025179b          	slliw	a5,a0,0x2
     d68:	9fa9                	addw	a5,a5,a0
     d6a:	0017979b          	slliw	a5,a5,0x1
     d6e:	9fb5                	addw	a5,a5,a3
     d70:	fd07851b          	addiw	a0,a5,-48
  while('0' <= *s && *s <= '9')
     d74:	00074683          	lbu	a3,0(a4)
     d78:	fd06879b          	addiw	a5,a3,-48
     d7c:	0ff7f793          	zext.b	a5,a5
     d80:	fef671e3          	bgeu	a2,a5,d62 <atoi+0x1c>
  return n;
}
     d84:	6422                	ld	s0,8(sp)
     d86:	0141                	addi	sp,sp,16
     d88:	8082                	ret
  n = 0;
     d8a:	4501                	li	a0,0
     d8c:	bfe5                	j	d84 <atoi+0x3e>

0000000000000d8e <memmove>:

void*
memmove(void *vdst, const void *vsrc, int n)
{
     d8e:	1141                	addi	sp,sp,-16
     d90:	e422                	sd	s0,8(sp)
     d92:	0800                	addi	s0,sp,16
  char *dst;
  const char *src;

  dst = vdst;
  src = vsrc;
  if (src > dst) {
     d94:	02b57463          	bgeu	a0,a1,dbc <memmove+0x2e>
    while(n-- > 0)
     d98:	00c05f63          	blez	a2,db6 <memmove+0x28>
     d9c:	1602                	slli	a2,a2,0x20
     d9e:	9201                	srli	a2,a2,0x20
     da0:	00c507b3          	add	a5,a0,a2
  dst = vdst;
     da4:	872a                	mv	a4,a0
      *dst++ = *src++;
     da6:	0585                	addi	a1,a1,1
     da8:	0705                	addi	a4,a4,1
     daa:	fff5c683          	lbu	a3,-1(a1)
     dae:	fed70fa3          	sb	a3,-1(a4)
    while(n-- > 0)
     db2:	fef71ae3          	bne	a4,a5,da6 <memmove+0x18>
    src += n;
    while(n-- > 0)
      *--dst = *--src;
  }
  return vdst;
}
     db6:	6422                	ld	s0,8(sp)
     db8:	0141                	addi	sp,sp,16
     dba:	8082                	ret
    dst += n;
     dbc:	00c50733          	add	a4,a0,a2
    src += n;
     dc0:	95b2                	add	a1,a1,a2
    while(n-- > 0)
     dc2:	fec05ae3          	blez	a2,db6 <memmove+0x28>
     dc6:	fff6079b          	addiw	a5,a2,-1
     dca:	1782                	slli	a5,a5,0x20
     dcc:	9381                	srli	a5,a5,0x20
     dce:	fff7c793          	not	a5,a5
     dd2:	97ba                	add	a5,a5,a4
      *--dst = *--src;
     dd4:	15fd                	addi	a1,a1,-1
     dd6:	177d                	addi	a4,a4,-1
     dd8:	0005c683          	lbu	a3,0(a1)
     ddc:	00d70023          	sb	a3,0(a4)
    while(n-- > 0)
     de0:	fee79ae3          	bne	a5,a4,dd4 <memmove+0x46>
     de4:	bfc9                	j	db6 <memmove+0x28>

0000000000000de6 <memcmp>:

int
memcmp(const void *s1, const void *s2, uint n)
{
     de6:	1141                	addi	sp,sp,-16
     de8:	e422                	sd	s0,8(sp)
     dea:	0800                	addi	s0,sp,16
  const char *p1 = s1, *p2 = s2;
  while (n-- > 0) {
     dec:	ca05                	beqz	a2,e1c <memcmp+0x36>
     dee:	fff6069b          	addiw	a3,a2,-1
     df2:	1682                	slli	a3,a3,0x20
     df4:	9281                	srli	a3,a3,0x20
     df6:	0685                	addi	a3,a3,1
     df8:	96aa                	add	a3,a3,a0
    if (*p1 != *p2) {
     dfa:	00054783          	lbu	a5,0(a0)
     dfe:	0005c703          	lbu	a4,0(a1)
     e02:	00e79863          	bne	a5,a4,e12 <memcmp+0x2c>
      return *p1 - *p2;
    }
    p1++;
     e06:	0505                	addi	a0,a0,1
    p2++;
     e08:	0585                	addi	a1,a1,1
  while (n-- > 0) {
     e0a:	fed518e3          	bne	a0,a3,dfa <memcmp+0x14>
  }
  return 0;
     e0e:	4501                	li	a0,0
     e10:	a019                	j	e16 <memcmp+0x30>
      return *p1 - *p2;
     e12:	40e7853b          	subw	a0,a5,a4
}
     e16:	6422                	ld	s0,8(sp)
     e18:	0141                	addi	sp,sp,16
     e1a:	8082                	ret
  return 0;
     e1c:	4501                	li	a0,0
     e1e:	bfe5                	j	e16 <memcmp+0x30>

0000000000000e20 <memcpy>:

void *
memcpy(void *dst, const void *src, uint n)
{
     e20:	1141                	addi	sp,sp,-16
     e22:	e406                	sd	ra,8(sp)
     e24:	e022                	sd	s0,0(sp)
     e26:	0800                	addi	s0,sp,16
  return memmove(dst, src, n);
     e28:	00000097          	auipc	ra,0x0
     e2c:	f66080e7          	jalr	-154(ra) # d8e <memmove>
}
     e30:	60a2                	ld	ra,8(sp)
     e32:	6402                	ld	s0,0(sp)
     e34:	0141                	addi	sp,sp,16
     e36:	8082                	ret

0000000000000e38 <fork>:
# generated by usys.pl - do not edit
#include "kernel/syscall.h"
.global fork
fork:
 li a7, SYS_fork
     e38:	4885                	li	a7,1
 ecall
     e3a:	00000073          	ecall
 ret
     e3e:	8082                	ret

0000000000000e40 <exit>:
.global exit
exit:
 li a7, SYS_exit
     e40:	4889                	li	a7,2
 ecall
     e42:	00000073          	ecall
 ret
     e46:	8082                	ret

0000000000000e48 <wait>:
.global wait
wait:
 li a7, SYS_wait
     e48:	488d                	li	a7,3
 ecall
     e4a:	00000073          	ecall
 ret
     e4e:	8082                	ret

0000000000000e50 <pipe>:
.global pipe
pipe:
 li a7, SYS_pipe
     e50:	4891                	li	a7,4
 ecall
     e52:	00000073          	ecall
 ret
     e56:	8082                	ret

0000000000000e58 <read>:
.global read
read:
 li a7, SYS_read
     e58:	4895                	li	a7,5
 ecall
     e5a:	00000073          	ecall
 ret
     e5e:	8082                	ret

0000000000000e60 <write>:
.global write
write:
 li a7, SYS_write
     e60:	48c1                	li	a7,16
 ecall
     e62:	00000073          	ecall
 ret
     e66:	8082                	ret

0000000000000e68 <close>:
.global close
close:
 li a7, SYS_close
     e68:	48d5                	li	a7,21
 ecall
     e6a:	00000073          	ecall
 ret
     e6e:	8082                	ret

0000000000000e70 <kill>:
.global kill
kill:
 li a7, SYS_kill
     e70:	4899                	li	a7,6
 ecall
     e72:	00000073          	ecall
 ret
     e76:	8082                	ret

0000000000000e78 <exec>:
.global exec
exec:
 li a7, SYS_exec
     e78:	489d                	li	a7,7
 ecall
     e7a:	00000073          	ecall
 ret
     e7e:	8082                	ret

0000000000000e80 <open>:
.global open
open:
 li a7, SYS_open
     e80:	48bd                	li	a7,15
 ecall
     e82:	00000073          	ecall
 ret
     e86:	8082                	ret

0000000000000e88 <mknod>:
.global mknod
mknod:
 li a7, SYS_mknod
     e88:	48c5                	li	a7,17
 ecall
     e8a:	00000073          	ecall
 ret
     e8e:	8082                	ret

0000000000000e90 <unlink>:
.global unlink
unlink:
 li a7, SYS_unlink
     e90:	48c9                	li	a7,18
 ecall
     e92:	00000073          	ecall
 ret
     e96:	8082                	ret

0000000000000e98 <fstat>:
.global fstat
fstat:
 li a7, SYS_fstat
     e98:	48a1                	li	a7,8
 ecall
     e9a:	00000073          	ecall
 ret
     e9e:	8082                	ret

0000000000000ea0 <link>:
.global link
link:
 li a7, SYS_link
     ea0:	48cd                	li	a7,19
 ecall
     ea2:	00000073          	ecall
 ret
     ea6:	8082                	ret

0000000000000ea8 <mkdir>:
.global mkdir
mkdir:
 li a7, SYS_mkdir
     ea8:	48d1                	li	a7,20
 ecall
     eaa:	00000073          	ecall
 ret
     eae:	8082                	ret

0000000000000eb0 <chdir>:
.global chdir
chdir:
 li a7, SYS_chdir
     eb0:	48a5                	li	a7,9
 ecall
     eb2:	00000073          	ecall
 ret
     eb6:	8082                	ret

0000000000000eb8 <dup>:
.global dup
dup:
 li a7, SYS_dup
     eb8:	48a9                	li	a7,10
 ecall
     eba:	00000073          	ecall
 ret
     ebe:	8082                	ret

0000000000000ec0 <getpid>:
.global getpid
getpid:
 li a7, SYS_getpid
     ec0:	48ad                	li	a7,11
 ecall
     ec2:	00000073          	ecall
 ret
     ec6:	8082                	ret

0000000000000ec8 <sbrk>:
.global sbrk
sbrk:
 li a7, SYS_sbrk
     ec8:	48b1                	li	a7,12
 ecall
     eca:	00000073          	ecall
 ret
     ece:	8082                	ret

0000000000000ed0 <sleep>:
.global sleep
sleep:
 li a7, SYS_sleep
     ed0:	48b5                	li	a7,13
 ecall
     ed2:	00000073          	ecall
 ret
     ed6:	8082                	ret

0000000000000ed8 <uptime>:
.global uptime
uptime:
 li a7, SYS_uptime
     ed8:	48b9                	li	a7,14
 ecall
     eda:	00000073          	ecall
 ret
     ede:	8082                	ret

0000000000000ee0 <spoon>:
.global spoon
spoon:
 li a7, SYS_spoon
     ee0:	48d9                	li	a7,22
 ecall
     ee2:	00000073          	ecall
 ret
     ee6:	8082                	ret

0000000000000ee8 <create_thread>:
.global create_thread
create_thread:
 li a7, SYS_create_thread
     ee8:	48dd                	li	a7,23
 ecall
     eea:	00000073          	ecall
 ret
     eee:	8082                	ret

0000000000000ef0 <join_thread>:
.global join_thread
join_thread:
 li a7, SYS_join_thread
     ef0:	48e1                	li	a7,24
 ecall
     ef2:	00000073          	ecall
 ret
     ef6:	8082                	ret

0000000000000ef8 <thread_exit>:
.global thread_exit
thread_exit:
 li a7, SYS_thread_exit
     ef8:	48e5                	li	a7,25
 ecall
     efa:	00000073          	ecall
 ret
     efe:	8082                	ret

0000000000000f00 <socket>:
.global socket
socket:
 li a7, SYS_socket
     f00:	48e9                	li	a7,26
 ecall
     f02:	00000073          	ecall
 ret
     f06:	8082                	ret

0000000000000f08 <bind>:
.global bind
bind:
 li a7, SYS_bind
     f08:	48ed                	li	a7,27
 ecall
     f0a:	00000073          	ecall
 ret
     f0e:	8082                	ret

0000000000000f10 <accept>:
.global accept
accept:
 li a7, SYS_accept
     f10:	48f5                	li	a7,29
 ecall
     f12:	00000073          	ecall
 ret
     f16:	8082                	ret

0000000000000f18 <listen>:
.global listen
listen:
 li a7, SYS_listen
     f18:	48f1                	li	a7,28
 ecall
     f1a:	00000073          	ecall
 ret
     f1e:	8082                	ret

0000000000000f20 <connect>:
.global connect
connect:
 li a7, SYS_connect
     f20:	48f9                	li	a7,30
 ecall
     f22:	00000073          	ecall
 ret
     f26:	8082                	ret

0000000000000f28 <send>:
.global send
send:
 li a7, SYS_send
     f28:	48fd                	li	a7,31
 ecall
     f2a:	00000073          	ecall
 ret
     f2e:	8082                	ret

0000000000000f30 <recv>:
.global recv
recv:
 li a7, SYS_recv
     f30:	02000893          	li	a7,32
 ecall
     f34:	00000073          	ecall
 ret
     f38:	8082                	ret

0000000000000f3a <sendto>:
.global sendto
sendto:
 li a7, SYS_sendto
     f3a:	02100893          	li	a7,33
 ecall
     f3e:	00000073          	ecall
 ret
     f42:	8082                	ret

0000000000000f44 <recvfrom>:
.global recvfrom
recvfrom:
 li a7, SYS_recvfrom
     f44:	02200893          	li	a7,34
 ecall
     f48:	00000073          	ecall
 ret
     f4c:	8082                	ret

0000000000000f4e <putc>:

static char digits[] = "0123456789ABCDEF";

static void
putc(int fd, char c)
{
     f4e:	1101                	addi	sp,sp,-32
     f50:	ec06                	sd	ra,24(sp)
     f52:	e822                	sd	s0,16(sp)
     f54:	1000                	addi	s0,sp,32
     f56:	feb407a3          	sb	a1,-17(s0)
  write(fd, &c, 1);
     f5a:	4605                	li	a2,1
     f5c:	fef40593          	addi	a1,s0,-17
     f60:	00000097          	auipc	ra,0x0
     f64:	f00080e7          	jalr	-256(ra) # e60 <write>
}
     f68:	60e2                	ld	ra,24(sp)
     f6a:	6442                	ld	s0,16(sp)
     f6c:	6105                	addi	sp,sp,32
     f6e:	8082                	ret

0000000000000f70 <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
     f70:	7139                	addi	sp,sp,-64
     f72:	fc06                	sd	ra,56(sp)
     f74:	f822                	sd	s0,48(sp)
     f76:	f426                	sd	s1,40(sp)
     f78:	0080                	addi	s0,sp,64
     f7a:	84aa                	mv	s1,a0
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
  if(sgn && xx < 0){
     f7c:	c299                	beqz	a3,f82 <printint+0x12>
     f7e:	0805cb63          	bltz	a1,1014 <printint+0xa4>
    neg = 1;
    x = -xx;
  } else {
    x = xx;
     f82:	2581                	sext.w	a1,a1
  neg = 0;
     f84:	4881                	li	a7,0
     f86:	fc040693          	addi	a3,s0,-64
  }

  i = 0;
     f8a:	4701                	li	a4,0
  do{
    buf[i++] = digits[x % base];
     f8c:	2601                	sext.w	a2,a2
     f8e:	00001517          	auipc	a0,0x1
     f92:	a8250513          	addi	a0,a0,-1406 # 1a10 <digits>
     f96:	883a                	mv	a6,a4
     f98:	2705                	addiw	a4,a4,1
     f9a:	02c5f7bb          	remuw	a5,a1,a2
     f9e:	1782                	slli	a5,a5,0x20
     fa0:	9381                	srli	a5,a5,0x20
     fa2:	97aa                	add	a5,a5,a0
     fa4:	0007c783          	lbu	a5,0(a5)
     fa8:	00f68023          	sb	a5,0(a3)
  }while((x /= base) != 0);
     fac:	0005879b          	sext.w	a5,a1
     fb0:	02c5d5bb          	divuw	a1,a1,a2
     fb4:	0685                	addi	a3,a3,1
     fb6:	fec7f0e3          	bgeu	a5,a2,f96 <printint+0x26>
  if(neg)
     fba:	00088c63          	beqz	a7,fd2 <printint+0x62>
    buf[i++] = '-';
     fbe:	fd070793          	addi	a5,a4,-48
     fc2:	00878733          	add	a4,a5,s0
     fc6:	02d00793          	li	a5,45
     fca:	fef70823          	sb	a5,-16(a4)
     fce:	0028071b          	addiw	a4,a6,2

  while(--i >= 0)
     fd2:	02e05c63          	blez	a4,100a <printint+0x9a>
     fd6:	f04a                	sd	s2,32(sp)
     fd8:	ec4e                	sd	s3,24(sp)
     fda:	fc040793          	addi	a5,s0,-64
     fde:	00e78933          	add	s2,a5,a4
     fe2:	fff78993          	addi	s3,a5,-1
     fe6:	99ba                	add	s3,s3,a4
     fe8:	377d                	addiw	a4,a4,-1
     fea:	1702                	slli	a4,a4,0x20
     fec:	9301                	srli	a4,a4,0x20
     fee:	40e989b3          	sub	s3,s3,a4
    putc(fd, buf[i]);
     ff2:	fff94583          	lbu	a1,-1(s2)
     ff6:	8526                	mv	a0,s1
     ff8:	00000097          	auipc	ra,0x0
     ffc:	f56080e7          	jalr	-170(ra) # f4e <putc>
  while(--i >= 0)
    1000:	197d                	addi	s2,s2,-1
    1002:	ff3918e3          	bne	s2,s3,ff2 <printint+0x82>
    1006:	7902                	ld	s2,32(sp)
    1008:	69e2                	ld	s3,24(sp)
}
    100a:	70e2                	ld	ra,56(sp)
    100c:	7442                	ld	s0,48(sp)
    100e:	74a2                	ld	s1,40(sp)
    1010:	6121                	addi	sp,sp,64
    1012:	8082                	ret
    x = -xx;
    1014:	40b005bb          	negw	a1,a1
    neg = 1;
    1018:	4885                	li	a7,1
    x = -xx;
    101a:	b7b5                	j	f86 <printint+0x16>

000000000000101c <vprintf>:
}

// Print to the given fd. Only understands %d, %x, %p, %s.
void
vprintf(int fd, const char *fmt, va_list ap)
{
    101c:	715d                	addi	sp,sp,-80
    101e:	e486                	sd	ra,72(sp)
    1020:	e0a2                	sd	s0,64(sp)
    1022:	f84a                	sd	s2,48(sp)
    1024:	0880                	addi	s0,sp,80
  char *s;
  int c, i, state;

  state = 0;
  for(i = 0; fmt[i]; i++){
    1026:	0005c903          	lbu	s2,0(a1)
    102a:	1a090a63          	beqz	s2,11de <vprintf+0x1c2>
    102e:	fc26                	sd	s1,56(sp)
    1030:	f44e                	sd	s3,40(sp)
    1032:	f052                	sd	s4,32(sp)
    1034:	ec56                	sd	s5,24(sp)
    1036:	e85a                	sd	s6,16(sp)
    1038:	e45e                	sd	s7,8(sp)
    103a:	8aaa                	mv	s5,a0
    103c:	8bb2                	mv	s7,a2
    103e:	00158493          	addi	s1,a1,1
  state = 0;
    1042:	4981                	li	s3,0
      if(c == '%'){
        state = '%';
      } else {
        putc(fd, c);
      }
    } else if(state == '%'){
    1044:	02500a13          	li	s4,37
    1048:	4b55                	li	s6,21
    104a:	a839                	j	1068 <vprintf+0x4c>
        putc(fd, c);
    104c:	85ca                	mv	a1,s2
    104e:	8556                	mv	a0,s5
    1050:	00000097          	auipc	ra,0x0
    1054:	efe080e7          	jalr	-258(ra) # f4e <putc>
    1058:	a019                	j	105e <vprintf+0x42>
    } else if(state == '%'){
    105a:	01498d63          	beq	s3,s4,1074 <vprintf+0x58>
  for(i = 0; fmt[i]; i++){
    105e:	0485                	addi	s1,s1,1
    1060:	fff4c903          	lbu	s2,-1(s1)
    1064:	16090763          	beqz	s2,11d2 <vprintf+0x1b6>
    if(state == 0){
    1068:	fe0999e3          	bnez	s3,105a <vprintf+0x3e>
      if(c == '%'){
    106c:	ff4910e3          	bne	s2,s4,104c <vprintf+0x30>
        state = '%';
    1070:	89d2                	mv	s3,s4
    1072:	b7f5                	j	105e <vprintf+0x42>
      if(c == 'd'){
    1074:	13490463          	beq	s2,s4,119c <vprintf+0x180>
    1078:	f9d9079b          	addiw	a5,s2,-99
    107c:	0ff7f793          	zext.b	a5,a5
    1080:	12fb6763          	bltu	s6,a5,11ae <vprintf+0x192>
    1084:	f9d9079b          	addiw	a5,s2,-99
    1088:	0ff7f713          	zext.b	a4,a5
    108c:	12eb6163          	bltu	s6,a4,11ae <vprintf+0x192>
    1090:	00271793          	slli	a5,a4,0x2
    1094:	00001717          	auipc	a4,0x1
    1098:	92470713          	addi	a4,a4,-1756 # 19b8 <ithread_join+0x3e4>
    109c:	97ba                	add	a5,a5,a4
    109e:	439c                	lw	a5,0(a5)
    10a0:	97ba                	add	a5,a5,a4
    10a2:	8782                	jr	a5
        printint(fd, va_arg(ap, int), 10, 1);
    10a4:	008b8913          	addi	s2,s7,8
    10a8:	4685                	li	a3,1
    10aa:	4629                	li	a2,10
    10ac:	000ba583          	lw	a1,0(s7)
    10b0:	8556                	mv	a0,s5
    10b2:	00000097          	auipc	ra,0x0
    10b6:	ebe080e7          	jalr	-322(ra) # f70 <printint>
    10ba:	8bca                	mv	s7,s2
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
        putc(fd, c);
      }
      state = 0;
    10bc:	4981                	li	s3,0
    10be:	b745                	j	105e <vprintf+0x42>
        printint(fd, va_arg(ap, uint64), 10, 0);
    10c0:	008b8913          	addi	s2,s7,8
    10c4:	4681                	li	a3,0
    10c6:	4629                	li	a2,10
    10c8:	000ba583          	lw	a1,0(s7)
    10cc:	8556                	mv	a0,s5
    10ce:	00000097          	auipc	ra,0x0
    10d2:	ea2080e7          	jalr	-350(ra) # f70 <printint>
    10d6:	8bca                	mv	s7,s2
      state = 0;
    10d8:	4981                	li	s3,0
    10da:	b751                	j	105e <vprintf+0x42>
        printint(fd, va_arg(ap, int), 16, 0);
    10dc:	008b8913          	addi	s2,s7,8
    10e0:	4681                	li	a3,0
    10e2:	4641                	li	a2,16
    10e4:	000ba583          	lw	a1,0(s7)
    10e8:	8556                	mv	a0,s5
    10ea:	00000097          	auipc	ra,0x0
    10ee:	e86080e7          	jalr	-378(ra) # f70 <printint>
    10f2:	8bca                	mv	s7,s2
      state = 0;
    10f4:	4981                	li	s3,0
    10f6:	b7a5                	j	105e <vprintf+0x42>
    10f8:	e062                	sd	s8,0(sp)
        printptr(fd, va_arg(ap, uint64));
    10fa:	008b8c13          	addi	s8,s7,8
    10fe:	000bb983          	ld	s3,0(s7)
  putc(fd, '0');
    1102:	03000593          	li	a1,48
    1106:	8556                	mv	a0,s5
    1108:	00000097          	auipc	ra,0x0
    110c:	e46080e7          	jalr	-442(ra) # f4e <putc>
  putc(fd, 'x');
    1110:	07800593          	li	a1,120
    1114:	8556                	mv	a0,s5
    1116:	00000097          	auipc	ra,0x0
    111a:	e38080e7          	jalr	-456(ra) # f4e <putc>
    111e:	4941                	li	s2,16
    putc(fd, digits[x >> (sizeof(uint64) * 8 - 4)]);
    1120:	00001b97          	auipc	s7,0x1
    1124:	8f0b8b93          	addi	s7,s7,-1808 # 1a10 <digits>
    1128:	03c9d793          	srli	a5,s3,0x3c
    112c:	97de                	add	a5,a5,s7
    112e:	0007c583          	lbu	a1,0(a5)
    1132:	8556                	mv	a0,s5
    1134:	00000097          	auipc	ra,0x0
    1138:	e1a080e7          	jalr	-486(ra) # f4e <putc>
  for (i = 0; i < (sizeof(uint64) * 2); i++, x <<= 4)
    113c:	0992                	slli	s3,s3,0x4
    113e:	397d                	addiw	s2,s2,-1
    1140:	fe0914e3          	bnez	s2,1128 <vprintf+0x10c>
        printptr(fd, va_arg(ap, uint64));
    1144:	8be2                	mv	s7,s8
      state = 0;
    1146:	4981                	li	s3,0
    1148:	6c02                	ld	s8,0(sp)
    114a:	bf11                	j	105e <vprintf+0x42>
        s = va_arg(ap, char*);
    114c:	008b8993          	addi	s3,s7,8
    1150:	000bb903          	ld	s2,0(s7)
        if(s == 0)
    1154:	02090163          	beqz	s2,1176 <vprintf+0x15a>
        while(*s != 0){
    1158:	00094583          	lbu	a1,0(s2)
    115c:	c9a5                	beqz	a1,11cc <vprintf+0x1b0>
          putc(fd, *s);
    115e:	8556                	mv	a0,s5
    1160:	00000097          	auipc	ra,0x0
    1164:	dee080e7          	jalr	-530(ra) # f4e <putc>
          s++;
    1168:	0905                	addi	s2,s2,1
        while(*s != 0){
    116a:	00094583          	lbu	a1,0(s2)
    116e:	f9e5                	bnez	a1,115e <vprintf+0x142>
        s = va_arg(ap, char*);
    1170:	8bce                	mv	s7,s3
      state = 0;
    1172:	4981                	li	s3,0
    1174:	b5ed                	j	105e <vprintf+0x42>
          s = "(null)";
    1176:	00000917          	auipc	s2,0x0
    117a:	7b290913          	addi	s2,s2,1970 # 1928 <ithread_join+0x354>
        while(*s != 0){
    117e:	02800593          	li	a1,40
    1182:	bff1                	j	115e <vprintf+0x142>
        putc(fd, va_arg(ap, uint));
    1184:	008b8913          	addi	s2,s7,8
    1188:	000bc583          	lbu	a1,0(s7)
    118c:	8556                	mv	a0,s5
    118e:	00000097          	auipc	ra,0x0
    1192:	dc0080e7          	jalr	-576(ra) # f4e <putc>
    1196:	8bca                	mv	s7,s2
      state = 0;
    1198:	4981                	li	s3,0
    119a:	b5d1                	j	105e <vprintf+0x42>
        putc(fd, c);
    119c:	02500593          	li	a1,37
    11a0:	8556                	mv	a0,s5
    11a2:	00000097          	auipc	ra,0x0
    11a6:	dac080e7          	jalr	-596(ra) # f4e <putc>
      state = 0;
    11aa:	4981                	li	s3,0
    11ac:	bd4d                	j	105e <vprintf+0x42>
        putc(fd, '%');
    11ae:	02500593          	li	a1,37
    11b2:	8556                	mv	a0,s5
    11b4:	00000097          	auipc	ra,0x0
    11b8:	d9a080e7          	jalr	-614(ra) # f4e <putc>
        putc(fd, c);
    11bc:	85ca                	mv	a1,s2
    11be:	8556                	mv	a0,s5
    11c0:	00000097          	auipc	ra,0x0
    11c4:	d8e080e7          	jalr	-626(ra) # f4e <putc>
      state = 0;
    11c8:	4981                	li	s3,0
    11ca:	bd51                	j	105e <vprintf+0x42>
        s = va_arg(ap, char*);
    11cc:	8bce                	mv	s7,s3
      state = 0;
    11ce:	4981                	li	s3,0
    11d0:	b579                	j	105e <vprintf+0x42>
    11d2:	74e2                	ld	s1,56(sp)
    11d4:	79a2                	ld	s3,40(sp)
    11d6:	7a02                	ld	s4,32(sp)
    11d8:	6ae2                	ld	s5,24(sp)
    11da:	6b42                	ld	s6,16(sp)
    11dc:	6ba2                	ld	s7,8(sp)
    }
  }
}
    11de:	60a6                	ld	ra,72(sp)
    11e0:	6406                	ld	s0,64(sp)
    11e2:	7942                	ld	s2,48(sp)
    11e4:	6161                	addi	sp,sp,80
    11e6:	8082                	ret

00000000000011e8 <fprintf>:

void
fprintf(int fd, const char *fmt, ...)
{
    11e8:	715d                	addi	sp,sp,-80
    11ea:	ec06                	sd	ra,24(sp)
    11ec:	e822                	sd	s0,16(sp)
    11ee:	1000                	addi	s0,sp,32
    11f0:	e010                	sd	a2,0(s0)
    11f2:	e414                	sd	a3,8(s0)
    11f4:	e818                	sd	a4,16(s0)
    11f6:	ec1c                	sd	a5,24(s0)
    11f8:	03043023          	sd	a6,32(s0)
    11fc:	03143423          	sd	a7,40(s0)
  va_list ap;

  va_start(ap, fmt);
    1200:	fe843423          	sd	s0,-24(s0)
  vprintf(fd, fmt, ap);
    1204:	8622                	mv	a2,s0
    1206:	00000097          	auipc	ra,0x0
    120a:	e16080e7          	jalr	-490(ra) # 101c <vprintf>
}
    120e:	60e2                	ld	ra,24(sp)
    1210:	6442                	ld	s0,16(sp)
    1212:	6161                	addi	sp,sp,80
    1214:	8082                	ret

0000000000001216 <printf>:

void
printf(const char *fmt, ...)
{
    1216:	711d                	addi	sp,sp,-96
    1218:	ec06                	sd	ra,24(sp)
    121a:	e822                	sd	s0,16(sp)
    121c:	1000                	addi	s0,sp,32
    121e:	e40c                	sd	a1,8(s0)
    1220:	e810                	sd	a2,16(s0)
    1222:	ec14                	sd	a3,24(s0)
    1224:	f018                	sd	a4,32(s0)
    1226:	f41c                	sd	a5,40(s0)
    1228:	03043823          	sd	a6,48(s0)
    122c:	03143c23          	sd	a7,56(s0)
  va_list ap;

  va_start(ap, fmt);
    1230:	00840613          	addi	a2,s0,8
    1234:	fec43423          	sd	a2,-24(s0)
  vprintf(1, fmt, ap);
    1238:	85aa                	mv	a1,a0
    123a:	4505                	li	a0,1
    123c:	00000097          	auipc	ra,0x0
    1240:	de0080e7          	jalr	-544(ra) # 101c <vprintf>
}
    1244:	60e2                	ld	ra,24(sp)
    1246:	6442                	ld	s0,16(sp)
    1248:	6125                	addi	sp,sp,96
    124a:	8082                	ret

000000000000124c <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
    124c:	1141                	addi	sp,sp,-16
    124e:	e422                	sd	s0,8(sp)
    1250:	0800                	addi	s0,sp,16
  Header *bp, *p;

  bp = (Header*)ap - 1;
    1252:	ff050693          	addi	a3,a0,-16
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
    1256:	00001797          	auipc	a5,0x1
    125a:	dba7b783          	ld	a5,-582(a5) # 2010 <freep>
    125e:	a02d                	j	1288 <free+0x3c>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
      break;
  if(bp + bp->s.size == p->s.ptr){
    bp->s.size += p->s.ptr->s.size;
    1260:	4618                	lw	a4,8(a2)
    1262:	9f2d                	addw	a4,a4,a1
    1264:	fee52c23          	sw	a4,-8(a0)
    bp->s.ptr = p->s.ptr->s.ptr;
    1268:	6398                	ld	a4,0(a5)
    126a:	6310                	ld	a2,0(a4)
    126c:	a83d                	j	12aa <free+0x5e>
  } else
    bp->s.ptr = p->s.ptr;
  if(p + p->s.size == bp){
    p->s.size += bp->s.size;
    126e:	ff852703          	lw	a4,-8(a0)
    1272:	9f31                	addw	a4,a4,a2
    1274:	c798                	sw	a4,8(a5)
    p->s.ptr = bp->s.ptr;
    1276:	ff053683          	ld	a3,-16(a0)
    127a:	a091                	j	12be <free+0x72>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
    127c:	6398                	ld	a4,0(a5)
    127e:	00e7e463          	bltu	a5,a4,1286 <free+0x3a>
    1282:	00e6ea63          	bltu	a3,a4,1296 <free+0x4a>
{
    1286:	87ba                	mv	a5,a4
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
    1288:	fed7fae3          	bgeu	a5,a3,127c <free+0x30>
    128c:	6398                	ld	a4,0(a5)
    128e:	00e6e463          	bltu	a3,a4,1296 <free+0x4a>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
    1292:	fee7eae3          	bltu	a5,a4,1286 <free+0x3a>
  if(bp + bp->s.size == p->s.ptr){
    1296:	ff852583          	lw	a1,-8(a0)
    129a:	6390                	ld	a2,0(a5)
    129c:	02059813          	slli	a6,a1,0x20
    12a0:	01c85713          	srli	a4,a6,0x1c
    12a4:	9736                	add	a4,a4,a3
    12a6:	fae60de3          	beq	a2,a4,1260 <free+0x14>
    bp->s.ptr = p->s.ptr->s.ptr;
    12aa:	fec53823          	sd	a2,-16(a0)
  if(p + p->s.size == bp){
    12ae:	4790                	lw	a2,8(a5)
    12b0:	02061593          	slli	a1,a2,0x20
    12b4:	01c5d713          	srli	a4,a1,0x1c
    12b8:	973e                	add	a4,a4,a5
    12ba:	fae68ae3          	beq	a3,a4,126e <free+0x22>
    p->s.ptr = bp->s.ptr;
    12be:	e394                	sd	a3,0(a5)
  } else
    p->s.ptr = bp;
  freep = p;
    12c0:	00001717          	auipc	a4,0x1
    12c4:	d4f73823          	sd	a5,-688(a4) # 2010 <freep>
}
    12c8:	6422                	ld	s0,8(sp)
    12ca:	0141                	addi	sp,sp,16
    12cc:	8082                	ret

00000000000012ce <malloc>:
  return freep;
}

void*
malloc(uint nbytes)
{
    12ce:	7139                	addi	sp,sp,-64
    12d0:	fc06                	sd	ra,56(sp)
    12d2:	f822                	sd	s0,48(sp)
    12d4:	f426                	sd	s1,40(sp)
    12d6:	ec4e                	sd	s3,24(sp)
    12d8:	0080                	addi	s0,sp,64
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
    12da:	02051493          	slli	s1,a0,0x20
    12de:	9081                	srli	s1,s1,0x20
    12e0:	04bd                	addi	s1,s1,15
    12e2:	8091                	srli	s1,s1,0x4
    12e4:	0014899b          	addiw	s3,s1,1
    12e8:	0485                	addi	s1,s1,1
  if((prevp = freep) == 0){
    12ea:	00001517          	auipc	a0,0x1
    12ee:	d2653503          	ld	a0,-730(a0) # 2010 <freep>
    12f2:	c915                	beqz	a0,1326 <malloc+0x58>
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
    12f4:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
    12f6:	4798                	lw	a4,8(a5)
    12f8:	08977e63          	bgeu	a4,s1,1394 <malloc+0xc6>
    12fc:	f04a                	sd	s2,32(sp)
    12fe:	e852                	sd	s4,16(sp)
    1300:	e456                	sd	s5,8(sp)
    1302:	e05a                	sd	s6,0(sp)
  if(nu < 4096)
    1304:	8a4e                	mv	s4,s3
    1306:	0009871b          	sext.w	a4,s3
    130a:	6685                	lui	a3,0x1
    130c:	00d77363          	bgeu	a4,a3,1312 <malloc+0x44>
    1310:	6a05                	lui	s4,0x1
    1312:	000a0b1b          	sext.w	s6,s4
  p = sbrk(nu * sizeof(Header));
    1316:	004a1a1b          	slliw	s4,s4,0x4
        p->s.size = nunits;
      }
      freep = prevp;
      return (void*)(p + 1);
    }
    if(p == freep)
    131a:	00001917          	auipc	s2,0x1
    131e:	cf690913          	addi	s2,s2,-778 # 2010 <freep>
  if(p == (char*)-1)
    1322:	5afd                	li	s5,-1
    1324:	a091                	j	1368 <malloc+0x9a>
    1326:	f04a                	sd	s2,32(sp)
    1328:	e852                	sd	s4,16(sp)
    132a:	e456                	sd	s5,8(sp)
    132c:	e05a                	sd	s6,0(sp)
    base.s.ptr = freep = prevp = &base;
    132e:	00001797          	auipc	a5,0x1
    1332:	0ea78793          	addi	a5,a5,234 # 2418 <base>
    1336:	00001717          	auipc	a4,0x1
    133a:	ccf73d23          	sd	a5,-806(a4) # 2010 <freep>
    133e:	e39c                	sd	a5,0(a5)
    base.s.size = 0;
    1340:	0007a423          	sw	zero,8(a5)
    if(p->s.size >= nunits){
    1344:	b7c1                	j	1304 <malloc+0x36>
        prevp->s.ptr = p->s.ptr;
    1346:	6398                	ld	a4,0(a5)
    1348:	e118                	sd	a4,0(a0)
    134a:	a08d                	j	13ac <malloc+0xde>
  hp->s.size = nu;
    134c:	01652423          	sw	s6,8(a0)
  free((void*)(hp + 1));
    1350:	0541                	addi	a0,a0,16
    1352:	00000097          	auipc	ra,0x0
    1356:	efa080e7          	jalr	-262(ra) # 124c <free>
  return freep;
    135a:	00093503          	ld	a0,0(s2)
      if((p = morecore(nunits)) == 0)
    135e:	c13d                	beqz	a0,13c4 <malloc+0xf6>
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
    1360:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
    1362:	4798                	lw	a4,8(a5)
    1364:	02977463          	bgeu	a4,s1,138c <malloc+0xbe>
    if(p == freep)
    1368:	00093703          	ld	a4,0(s2)
    136c:	853e                	mv	a0,a5
    136e:	fef719e3          	bne	a4,a5,1360 <malloc+0x92>
  p = sbrk(nu * sizeof(Header));
    1372:	8552                	mv	a0,s4
    1374:	00000097          	auipc	ra,0x0
    1378:	b54080e7          	jalr	-1196(ra) # ec8 <sbrk>
  if(p == (char*)-1)
    137c:	fd5518e3          	bne	a0,s5,134c <malloc+0x7e>
        return 0;
    1380:	4501                	li	a0,0
    1382:	7902                	ld	s2,32(sp)
    1384:	6a42                	ld	s4,16(sp)
    1386:	6aa2                	ld	s5,8(sp)
    1388:	6b02                	ld	s6,0(sp)
    138a:	a03d                	j	13b8 <malloc+0xea>
    138c:	7902                	ld	s2,32(sp)
    138e:	6a42                	ld	s4,16(sp)
    1390:	6aa2                	ld	s5,8(sp)
    1392:	6b02                	ld	s6,0(sp)
      if(p->s.size == nunits)
    1394:	fae489e3          	beq	s1,a4,1346 <malloc+0x78>
        p->s.size -= nunits;
    1398:	4137073b          	subw	a4,a4,s3
    139c:	c798                	sw	a4,8(a5)
        p += p->s.size;
    139e:	02071693          	slli	a3,a4,0x20
    13a2:	01c6d713          	srli	a4,a3,0x1c
    13a6:	97ba                	add	a5,a5,a4
        p->s.size = nunits;
    13a8:	0137a423          	sw	s3,8(a5)
      freep = prevp;
    13ac:	00001717          	auipc	a4,0x1
    13b0:	c6a73223          	sd	a0,-924(a4) # 2010 <freep>
      return (void*)(p + 1);
    13b4:	01078513          	addi	a0,a5,16
  }
}
    13b8:	70e2                	ld	ra,56(sp)
    13ba:	7442                	ld	s0,48(sp)
    13bc:	74a2                	ld	s1,40(sp)
    13be:	69e2                	ld	s3,24(sp)
    13c0:	6121                	addi	sp,sp,64
    13c2:	8082                	ret
    13c4:	7902                	ld	s2,32(sp)
    13c6:	6a42                	ld	s4,16(sp)
    13c8:	6aa2                	ld	s5,8(sp)
    13ca:	6b02                	ld	s6,0(sp)
    13cc:	b7f5                	j	13b8 <malloc+0xea>

00000000000013ce <ithread_exit>:
  free(stacks);
  stacks = new_stacks;
  return 0;
}

void ithread_exit(uint64 status) {
    13ce:	1141                	addi	sp,sp,-16
    13d0:	e406                	sd	ra,8(sp)
    13d2:	e022                	sd	s0,0(sp)
    13d4:	0800                	addi	s0,sp,16
  thread_exit(status);
    13d6:	2501                	sext.w	a0,a0
    13d8:	00000097          	auipc	ra,0x0
    13dc:	b20080e7          	jalr	-1248(ra) # ef8 <thread_exit>
}
    13e0:	60a2                	ld	ra,8(sp)
    13e2:	6402                	ld	s0,0(sp)
    13e4:	0141                	addi	sp,sp,16
    13e6:	8082                	ret

00000000000013e8 <free_stacks>:
int free_stacks() {
    13e8:	7179                	addi	sp,sp,-48
    13ea:	f406                	sd	ra,40(sp)
    13ec:	f022                	sd	s0,32(sp)
    13ee:	ec26                	sd	s1,24(sp)
    13f0:	1800                	addi	s0,sp,48
  for (int i = 0; i < num_threads; i++) {
    13f2:	00001797          	auipc	a5,0x1
    13f6:	c2e7a783          	lw	a5,-978(a5) # 2020 <num_threads>
    13fa:	04f05063          	blez	a5,143a <free_stacks+0x52>
    13fe:	e84a                	sd	s2,16(sp)
    1400:	e44e                	sd	s3,8(sp)
    1402:	4481                	li	s1,0
    free(stacks[i]);
    1404:	00001997          	auipc	s3,0x1
    1408:	c1498993          	addi	s3,s3,-1004 # 2018 <stacks>
  for (int i = 0; i < num_threads; i++) {
    140c:	00001917          	auipc	s2,0x1
    1410:	c1490913          	addi	s2,s2,-1004 # 2020 <num_threads>
    free(stacks[i]);
    1414:	0009b783          	ld	a5,0(s3)
    1418:	00349713          	slli	a4,s1,0x3
    141c:	97ba                	add	a5,a5,a4
    141e:	6388                	ld	a0,0(a5)
    1420:	00000097          	auipc	ra,0x0
    1424:	e2c080e7          	jalr	-468(ra) # 124c <free>
  for (int i = 0; i < num_threads; i++) {
    1428:	0485                	addi	s1,s1,1
    142a:	00092703          	lw	a4,0(s2)
    142e:	0004879b          	sext.w	a5,s1
    1432:	fee7c1e3          	blt	a5,a4,1414 <free_stacks+0x2c>
    1436:	6942                	ld	s2,16(sp)
    1438:	69a2                	ld	s3,8(sp)
  free(stacks);
    143a:	00001497          	auipc	s1,0x1
    143e:	bde48493          	addi	s1,s1,-1058 # 2018 <stacks>
    1442:	6088                	ld	a0,0(s1)
    1444:	00000097          	auipc	ra,0x0
    1448:	e08080e7          	jalr	-504(ra) # 124c <free>
  stacks = 0;
    144c:	0004b023          	sd	zero,0(s1)
  num_threads = 0;
    1450:	00001797          	auipc	a5,0x1
    1454:	bc07a823          	sw	zero,-1072(a5) # 2020 <num_threads>
  max_stacks = INIT_MAX_STACKS;
    1458:	47a1                	li	a5,8
    145a:	00001717          	auipc	a4,0x1
    145e:	baf72723          	sw	a5,-1106(a4) # 2008 <max_stacks>
  threads_done = 0;
    1462:	00001797          	auipc	a5,0x1
    1466:	bc07a123          	sw	zero,-1086(a5) # 2024 <threads_done>
}
    146a:	4501                	li	a0,0
    146c:	70a2                	ld	ra,40(sp)
    146e:	7402                	ld	s0,32(sp)
    1470:	64e2                	ld	s1,24(sp)
    1472:	6145                	addi	sp,sp,48
    1474:	8082                	ret

0000000000001476 <expand_num_threads>:
int expand_num_threads() {
    1476:	1101                	addi	sp,sp,-32
    1478:	ec06                	sd	ra,24(sp)
    147a:	e822                	sd	s0,16(sp)
    147c:	e426                	sd	s1,8(sp)
    147e:	e04a                	sd	s2,0(sp)
    1480:	1000                	addi	s0,sp,32
  max_stacks *= 2;
    1482:	00001797          	auipc	a5,0x1
    1486:	b8678793          	addi	a5,a5,-1146 # 2008 <max_stacks>
    148a:	4388                	lw	a0,0(a5)
    148c:	0015151b          	slliw	a0,a0,0x1
    1490:	c388                	sw	a0,0(a5)
  void **new_stacks = malloc(max_stacks*sizeof(char*));
    1492:	0035151b          	slliw	a0,a0,0x3
    1496:	00000097          	auipc	ra,0x0
    149a:	e38080e7          	jalr	-456(ra) # 12ce <malloc>
    149e:	892a                	mv	s2,a0
  memmove(new_stacks, stacks, num_threads*sizeof(char*));
    14a0:	00001617          	auipc	a2,0x1
    14a4:	b8062603          	lw	a2,-1152(a2) # 2020 <num_threads>
    14a8:	00001497          	auipc	s1,0x1
    14ac:	b7048493          	addi	s1,s1,-1168 # 2018 <stacks>
    14b0:	0036161b          	slliw	a2,a2,0x3
    14b4:	608c                	ld	a1,0(s1)
    14b6:	00000097          	auipc	ra,0x0
    14ba:	8d8080e7          	jalr	-1832(ra) # d8e <memmove>
  free(stacks);
    14be:	6088                	ld	a0,0(s1)
    14c0:	00000097          	auipc	ra,0x0
    14c4:	d8c080e7          	jalr	-628(ra) # 124c <free>
  stacks = new_stacks;
    14c8:	0124b023          	sd	s2,0(s1)
}
    14cc:	4501                	li	a0,0
    14ce:	60e2                	ld	ra,24(sp)
    14d0:	6442                	ld	s0,16(sp)
    14d2:	64a2                	ld	s1,8(sp)
    14d4:	6902                	ld	s2,0(sp)
    14d6:	6105                	addi	sp,sp,32
    14d8:	8082                	ret

00000000000014da <ithread_create>:

int ithread_create(void* (*fn_ptr)(void *), void *args) {
    14da:	7179                	addi	sp,sp,-48
    14dc:	f406                	sd	ra,40(sp)
    14de:	f022                	sd	s0,32(sp)
    14e0:	e84a                	sd	s2,16(sp)
    14e2:	e44e                	sd	s3,8(sp)
    14e4:	1800                	addi	s0,sp,48
    14e6:	892a                	mv	s2,a0
    14e8:	89ae                	mv	s3,a1
  if (stacks == 0) {
    14ea:	00001797          	auipc	a5,0x1
    14ee:	b2e7b783          	ld	a5,-1234(a5) # 2018 <stacks>
    14f2:	c3d9                	beqz	a5,1578 <ithread_create+0x9e>
    stacks = malloc(max_stacks*sizeof(char*));
  }
  if (num_threads == max_stacks) {
    14f4:	00001797          	auipc	a5,0x1
    14f8:	b147a783          	lw	a5,-1260(a5) # 2008 <max_stacks>
    14fc:	00001717          	auipc	a4,0x1
    1500:	b2472703          	lw	a4,-1244(a4) # 2020 <num_threads>
    1504:	0af71363          	bne	a4,a5,15aa <ithread_create+0xd0>
    if (max_stacks == MAX_THREADS) {
    1508:	04000713          	li	a4,64
    150c:	08e78563          	beq	a5,a4,1596 <ithread_create+0xbc>
    1510:	ec26                	sd	s1,24(sp)
      printf("ERROR: Thread capacity has been reached\n");
      return -1;
    }
    expand_num_threads();
    1512:	00000097          	auipc	ra,0x0
    1516:	f64080e7          	jalr	-156(ra) # 1476 <expand_num_threads>
  }

  void *stack_ptr = malloc(PGSIZE);
    151a:	6505                	lui	a0,0x1
    151c:	00000097          	auipc	ra,0x0
    1520:	db2080e7          	jalr	-590(ra) # 12ce <malloc>
    1524:	84aa                	mv	s1,a0
  stacks[num_threads] = stack_ptr;
    1526:	00001717          	auipc	a4,0x1
    152a:	afa72703          	lw	a4,-1286(a4) # 2020 <num_threads>
    152e:	070e                	slli	a4,a4,0x3
    1530:	00001797          	auipc	a5,0x1
    1534:	ae87b783          	ld	a5,-1304(a5) # 2018 <stacks>
    1538:	97ba                	add	a5,a5,a4
    153a:	e388                	sd	a0,0(a5)
  int res = create_thread(fn_ptr, args, stack_ptr, &ithread_exit);
    153c:	00000697          	auipc	a3,0x0
    1540:	e9268693          	addi	a3,a3,-366 # 13ce <ithread_exit>
    1544:	862a                	mv	a2,a0
    1546:	85ce                	mv	a1,s3
    1548:	854a                	mv	a0,s2
    154a:	00000097          	auipc	ra,0x0
    154e:	99e080e7          	jalr	-1634(ra) # ee8 <create_thread>
    1552:	892a                	mv	s2,a0
  if (res != -1) {
    1554:	57fd                	li	a5,-1
    1556:	04f50c63          	beq	a0,a5,15ae <ithread_create+0xd4>
    num_threads++;
    155a:	00001717          	auipc	a4,0x1
    155e:	ac670713          	addi	a4,a4,-1338 # 2020 <num_threads>
    1562:	431c                	lw	a5,0(a4)
    1564:	2785                	addiw	a5,a5,1
    1566:	c31c                	sw	a5,0(a4)
    1568:	64e2                	ld	s1,24(sp)
  } else {
    free(stack_ptr);
    stacks[num_threads] = 0;
  }
  return res;
}
    156a:	854a                	mv	a0,s2
    156c:	70a2                	ld	ra,40(sp)
    156e:	7402                	ld	s0,32(sp)
    1570:	6942                	ld	s2,16(sp)
    1572:	69a2                	ld	s3,8(sp)
    1574:	6145                	addi	sp,sp,48
    1576:	8082                	ret
    stacks = malloc(max_stacks*sizeof(char*));
    1578:	00001517          	auipc	a0,0x1
    157c:	a9052503          	lw	a0,-1392(a0) # 2008 <max_stacks>
    1580:	0035151b          	slliw	a0,a0,0x3
    1584:	00000097          	auipc	ra,0x0
    1588:	d4a080e7          	jalr	-694(ra) # 12ce <malloc>
    158c:	00001797          	auipc	a5,0x1
    1590:	a8a7b623          	sd	a0,-1396(a5) # 2018 <stacks>
    1594:	b785                	j	14f4 <ithread_create+0x1a>
      printf("ERROR: Thread capacity has been reached\n");
    1596:	00000517          	auipc	a0,0x0
    159a:	39a50513          	addi	a0,a0,922 # 1930 <ithread_join+0x35c>
    159e:	00000097          	auipc	ra,0x0
    15a2:	c78080e7          	jalr	-904(ra) # 1216 <printf>
      return -1;
    15a6:	597d                	li	s2,-1
    15a8:	b7c9                	j	156a <ithread_create+0x90>
    15aa:	ec26                	sd	s1,24(sp)
    15ac:	b7bd                	j	151a <ithread_create+0x40>
    free(stack_ptr);
    15ae:	8526                	mv	a0,s1
    15b0:	00000097          	auipc	ra,0x0
    15b4:	c9c080e7          	jalr	-868(ra) # 124c <free>
    stacks[num_threads] = 0;
    15b8:	00001717          	auipc	a4,0x1
    15bc:	a6872703          	lw	a4,-1432(a4) # 2020 <num_threads>
    15c0:	070e                	slli	a4,a4,0x3
    15c2:	00001797          	auipc	a5,0x1
    15c6:	a567b783          	ld	a5,-1450(a5) # 2018 <stacks>
    15ca:	97ba                	add	a5,a5,a4
    15cc:	0007b023          	sd	zero,0(a5)
    15d0:	64e2                	ld	s1,24(sp)
    15d2:	bf61                	j	156a <ithread_create+0x90>

00000000000015d4 <ithread_join>:

int ithread_join(int thread_id) {
    15d4:	1101                	addi	sp,sp,-32
    15d6:	ec06                	sd	ra,24(sp)
    15d8:	e822                	sd	s0,16(sp)
    15da:	1000                	addi	s0,sp,32
  int status;
  join_thread(thread_id, (uint64)&status);
    15dc:	ff040793          	addi	a5,s0,-16
    15e0:	ffc7859b          	addiw	a1,a5,-4
    15e4:	00000097          	auipc	ra,0x0
    15e8:	90c080e7          	jalr	-1780(ra) # ef0 <join_thread>
  threads_done++;
    15ec:	00001717          	auipc	a4,0x1
    15f0:	a3870713          	addi	a4,a4,-1480 # 2024 <threads_done>
    15f4:	431c                	lw	a5,0(a4)
    15f6:	2785                	addiw	a5,a5,1
    15f8:	0007869b          	sext.w	a3,a5
    15fc:	c31c                	sw	a5,0(a4)
  if (threads_done == num_threads) {
    15fe:	00001797          	auipc	a5,0x1
    1602:	a227a783          	lw	a5,-1502(a5) # 2020 <num_threads>
    1606:	00d78863          	beq	a5,a3,1616 <ithread_join+0x42>
    free_stacks();
  }
  return status;
}
    160a:	fec42503          	lw	a0,-20(s0)
    160e:	60e2                	ld	ra,24(sp)
    1610:	6442                	ld	s0,16(sp)
    1612:	6105                	addi	sp,sp,32
    1614:	8082                	ret
    free_stacks();
    1616:	00000097          	auipc	ra,0x0
    161a:	dd2080e7          	jalr	-558(ra) # 13e8 <free_stacks>
    161e:	b7f5                	j	160a <ithread_join+0x36>
