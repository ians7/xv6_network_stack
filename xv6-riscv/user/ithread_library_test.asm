
user/_ithread_library_test:     file format elf64-littleriscv


Disassembly of section .text:

0000000000000000 <do_nothing>:
#include "kernel/types.h"
#include "kernel/stat.h"
#include "user/user.h"
#include "ithreads.h"

void *do_nothing(void *args) {
   0:	1101                	addi	sp,sp,-32
   2:	ec06                	sd	ra,24(sp)
   4:	e822                	sd	s0,16(sp)
   6:	e426                	sd	s1,8(sp)
   8:	1000                	addi	s0,sp,32
   a:	84aa                	mv	s1,a0
  int *tidx = (int *)args;
  if (*tidx == 1) {
   c:	4118                	lw	a4,0(a0)
   e:	4785                	li	a5,1
  10:	02f70663          	beq	a4,a5,3c <do_nothing+0x3c>
    sleep(20);
  }
  printf("Thread %d is doing nothing! tid = %d\n", *tidx, getpid());
  14:	4084                	lw	s1,0(s1)
  16:	00000097          	auipc	ra,0x0
  1a:	3d0080e7          	jalr	976(ra) # 3e6 <getpid>
  1e:	862a                	mv	a2,a0
  20:	85a6                	mv	a1,s1
  22:	00001517          	auipc	a0,0x1
  26:	ace50513          	addi	a0,a0,-1330 # af0 <ithread_join+0x54>
  2a:	00000097          	auipc	ra,0x0
  2e:	6d6080e7          	jalr	1750(ra) # 700 <printf>
  exit(0);
  32:	4501                	li	a0,0
  34:	00000097          	auipc	ra,0x0
  38:	332080e7          	jalr	818(ra) # 366 <exit>
    sleep(20);
  3c:	4551                	li	a0,20
  3e:	00000097          	auipc	ra,0x0
  42:	3b8080e7          	jalr	952(ra) # 3f6 <sleep>
  46:	b7f9                	j	14 <do_nothing+0x14>

0000000000000048 <do_nothing2>:
  return 0;
}

void *do_nothing2(void *args) {
  48:	1101                	addi	sp,sp,-32
  4a:	ec06                	sd	ra,24(sp)
  4c:	e822                	sd	s0,16(sp)
  4e:	e426                	sd	s1,8(sp)
  50:	1000                	addi	s0,sp,32
  int *tidx = (int *)args;
  printf("Thread %d is doing nothing! tid = %d\n", *tidx, getpid());
  52:	4104                	lw	s1,0(a0)
  54:	00000097          	auipc	ra,0x0
  58:	392080e7          	jalr	914(ra) # 3e6 <getpid>
  5c:	862a                	mv	a2,a0
  5e:	85a6                	mv	a1,s1
  60:	00001517          	auipc	a0,0x1
  64:	a9050513          	addi	a0,a0,-1392 # af0 <ithread_join+0x54>
  68:	00000097          	auipc	ra,0x0
  6c:	698080e7          	jalr	1688(ra) # 700 <printf>
  exit(0);
  70:	4501                	li	a0,0
  72:	00000097          	auipc	ra,0x0
  76:	2f4080e7          	jalr	756(ra) # 366 <exit>

000000000000007a <main>:
  return 0;
}

int main(int argc, char** argv) {
  7a:	1101                	addi	sp,sp,-32
  7c:	ec06                	sd	ra,24(sp)
  7e:	e822                	sd	s0,16(sp)
  80:	e426                	sd	s1,8(sp)
  82:	e04a                	sd	s2,0(sp)
  84:	1000                	addi	s0,sp,32
  int *num = malloc(sizeof(int));
  86:	4511                	li	a0,4
  88:	00000097          	auipc	ra,0x0
  8c:	730080e7          	jalr	1840(ra) # 7b8 <malloc>
  90:	84aa                	mv	s1,a0
  *num = 10;
  92:	47a9                	li	a5,10
  94:	c11c                	sw	a5,0(a0)
  int tid = ithread_create(do_nothing, num);
  96:	85aa                	mv	a1,a0
  98:	00000517          	auipc	a0,0x0
  9c:	f6850513          	addi	a0,a0,-152 # 0 <do_nothing>
  a0:	00001097          	auipc	ra,0x1
  a4:	908080e7          	jalr	-1784(ra) # 9a8 <ithread_create>
  a8:	892a                	mv	s2,a0
  int tid2 = ithread_create(do_nothing2, num);
  aa:	85a6                	mv	a1,s1
  ac:	00000517          	auipc	a0,0x0
  b0:	f9c50513          	addi	a0,a0,-100 # 48 <do_nothing2>
  b4:	00001097          	auipc	ra,0x1
  b8:	8f4080e7          	jalr	-1804(ra) # 9a8 <ithread_create>
  bc:	84aa                	mv	s1,a0
  ithread_join(tid);
  be:	854a                	mv	a0,s2
  c0:	00001097          	auipc	ra,0x1
  c4:	9dc080e7          	jalr	-1572(ra) # a9c <ithread_join>
  ithread_join(tid2);
  c8:	8526                	mv	a0,s1
  ca:	00001097          	auipc	ra,0x1
  ce:	9d2080e7          	jalr	-1582(ra) # a9c <ithread_join>
  return 0;
}
  d2:	4501                	li	a0,0
  d4:	60e2                	ld	ra,24(sp)
  d6:	6442                	ld	s0,16(sp)
  d8:	64a2                	ld	s1,8(sp)
  da:	6902                	ld	s2,0(sp)
  dc:	6105                	addi	sp,sp,32
  de:	8082                	ret

00000000000000e0 <_main>:
//
// wrapper so that it's OK if main() does not call exit().
//
void
_main()
{
  e0:	1141                	addi	sp,sp,-16
  e2:	e406                	sd	ra,8(sp)
  e4:	e022                	sd	s0,0(sp)
  e6:	0800                	addi	s0,sp,16
  extern int main();
  main();
  e8:	00000097          	auipc	ra,0x0
  ec:	f92080e7          	jalr	-110(ra) # 7a <main>
  exit(0);
  f0:	4501                	li	a0,0
  f2:	00000097          	auipc	ra,0x0
  f6:	274080e7          	jalr	628(ra) # 366 <exit>

00000000000000fa <strcpy>:
}

char*
strcpy(char *s, const char *t)
{
  fa:	1141                	addi	sp,sp,-16
  fc:	e422                	sd	s0,8(sp)
  fe:	0800                	addi	s0,sp,16
  char *os;

  os = s;
  while((*s++ = *t++) != 0)
 100:	87aa                	mv	a5,a0
 102:	0585                	addi	a1,a1,1
 104:	0785                	addi	a5,a5,1
 106:	fff5c703          	lbu	a4,-1(a1)
 10a:	fee78fa3          	sb	a4,-1(a5)
 10e:	fb75                	bnez	a4,102 <strcpy+0x8>
    ;
  return os;
}
 110:	6422                	ld	s0,8(sp)
 112:	0141                	addi	sp,sp,16
 114:	8082                	ret

0000000000000116 <strcmp>:

int
strcmp(const char *p, const char *q)
{
 116:	1141                	addi	sp,sp,-16
 118:	e422                	sd	s0,8(sp)
 11a:	0800                	addi	s0,sp,16
  while(*p && *p == *q)
 11c:	00054783          	lbu	a5,0(a0)
 120:	cb91                	beqz	a5,134 <strcmp+0x1e>
 122:	0005c703          	lbu	a4,0(a1)
 126:	00f71763          	bne	a4,a5,134 <strcmp+0x1e>
    p++, q++;
 12a:	0505                	addi	a0,a0,1
 12c:	0585                	addi	a1,a1,1
  while(*p && *p == *q)
 12e:	00054783          	lbu	a5,0(a0)
 132:	fbe5                	bnez	a5,122 <strcmp+0xc>
  return (uchar)*p - (uchar)*q;
 134:	0005c503          	lbu	a0,0(a1)
}
 138:	40a7853b          	subw	a0,a5,a0
 13c:	6422                	ld	s0,8(sp)
 13e:	0141                	addi	sp,sp,16
 140:	8082                	ret

0000000000000142 <strlen>:

uint
strlen(const char *s)
{
 142:	1141                	addi	sp,sp,-16
 144:	e422                	sd	s0,8(sp)
 146:	0800                	addi	s0,sp,16
  int n;

  for(n = 0; s[n]; n++)
 148:	00054783          	lbu	a5,0(a0)
 14c:	cf91                	beqz	a5,168 <strlen+0x26>
 14e:	0505                	addi	a0,a0,1
 150:	87aa                	mv	a5,a0
 152:	4685                	li	a3,1
 154:	9e89                	subw	a3,a3,a0
 156:	00f6853b          	addw	a0,a3,a5
 15a:	0785                	addi	a5,a5,1
 15c:	fff7c703          	lbu	a4,-1(a5)
 160:	fb7d                	bnez	a4,156 <strlen+0x14>
    ;
  return n;
}
 162:	6422                	ld	s0,8(sp)
 164:	0141                	addi	sp,sp,16
 166:	8082                	ret
  for(n = 0; s[n]; n++)
 168:	4501                	li	a0,0
 16a:	bfe5                	j	162 <strlen+0x20>

000000000000016c <memset>:

void*
memset(void *dst, int c, uint n)
{
 16c:	1141                	addi	sp,sp,-16
 16e:	e422                	sd	s0,8(sp)
 170:	0800                	addi	s0,sp,16
  char *cdst = (char *) dst;
  int i;
  for(i = 0; i < n; i++){
 172:	ca19                	beqz	a2,188 <memset+0x1c>
 174:	87aa                	mv	a5,a0
 176:	1602                	slli	a2,a2,0x20
 178:	9201                	srli	a2,a2,0x20
 17a:	00a60733          	add	a4,a2,a0
    cdst[i] = c;
 17e:	00b78023          	sb	a1,0(a5)
  for(i = 0; i < n; i++){
 182:	0785                	addi	a5,a5,1
 184:	fee79de3          	bne	a5,a4,17e <memset+0x12>
  }
  return dst;
}
 188:	6422                	ld	s0,8(sp)
 18a:	0141                	addi	sp,sp,16
 18c:	8082                	ret

000000000000018e <strchr>:

char*
strchr(const char *s, char c)
{
 18e:	1141                	addi	sp,sp,-16
 190:	e422                	sd	s0,8(sp)
 192:	0800                	addi	s0,sp,16
  for(; *s; s++)
 194:	00054783          	lbu	a5,0(a0)
 198:	cb99                	beqz	a5,1ae <strchr+0x20>
    if(*s == c)
 19a:	00f58763          	beq	a1,a5,1a8 <strchr+0x1a>
  for(; *s; s++)
 19e:	0505                	addi	a0,a0,1
 1a0:	00054783          	lbu	a5,0(a0)
 1a4:	fbfd                	bnez	a5,19a <strchr+0xc>
      return (char*)s;
  return 0;
 1a6:	4501                	li	a0,0
}
 1a8:	6422                	ld	s0,8(sp)
 1aa:	0141                	addi	sp,sp,16
 1ac:	8082                	ret
  return 0;
 1ae:	4501                	li	a0,0
 1b0:	bfe5                	j	1a8 <strchr+0x1a>

00000000000001b2 <gets>:

char*
gets(char *buf, int max)
{
 1b2:	711d                	addi	sp,sp,-96
 1b4:	ec86                	sd	ra,88(sp)
 1b6:	e8a2                	sd	s0,80(sp)
 1b8:	e4a6                	sd	s1,72(sp)
 1ba:	e0ca                	sd	s2,64(sp)
 1bc:	fc4e                	sd	s3,56(sp)
 1be:	f852                	sd	s4,48(sp)
 1c0:	f456                	sd	s5,40(sp)
 1c2:	f05a                	sd	s6,32(sp)
 1c4:	ec5e                	sd	s7,24(sp)
 1c6:	1080                	addi	s0,sp,96
 1c8:	8baa                	mv	s7,a0
 1ca:	8a2e                	mv	s4,a1
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 1cc:	892a                	mv	s2,a0
 1ce:	4481                	li	s1,0
    cc = read(0, &c, 1);
    if(cc < 1)
      break;
    buf[i++] = c;
    if(c == '\n' || c == '\r')
 1d0:	4aa9                	li	s5,10
 1d2:	4b35                	li	s6,13
  for(i=0; i+1 < max; ){
 1d4:	89a6                	mv	s3,s1
 1d6:	2485                	addiw	s1,s1,1
 1d8:	0344d863          	bge	s1,s4,208 <gets+0x56>
    cc = read(0, &c, 1);
 1dc:	4605                	li	a2,1
 1de:	faf40593          	addi	a1,s0,-81
 1e2:	4501                	li	a0,0
 1e4:	00000097          	auipc	ra,0x0
 1e8:	19a080e7          	jalr	410(ra) # 37e <read>
    if(cc < 1)
 1ec:	00a05e63          	blez	a0,208 <gets+0x56>
    buf[i++] = c;
 1f0:	faf44783          	lbu	a5,-81(s0)
 1f4:	00f90023          	sb	a5,0(s2)
    if(c == '\n' || c == '\r')
 1f8:	01578763          	beq	a5,s5,206 <gets+0x54>
 1fc:	0905                	addi	s2,s2,1
 1fe:	fd679be3          	bne	a5,s6,1d4 <gets+0x22>
  for(i=0; i+1 < max; ){
 202:	89a6                	mv	s3,s1
 204:	a011                	j	208 <gets+0x56>
 206:	89a6                	mv	s3,s1
      break;
  }
  buf[i] = '\0';
 208:	99de                	add	s3,s3,s7
 20a:	00098023          	sb	zero,0(s3)
  return buf;
}
 20e:	855e                	mv	a0,s7
 210:	60e6                	ld	ra,88(sp)
 212:	6446                	ld	s0,80(sp)
 214:	64a6                	ld	s1,72(sp)
 216:	6906                	ld	s2,64(sp)
 218:	79e2                	ld	s3,56(sp)
 21a:	7a42                	ld	s4,48(sp)
 21c:	7aa2                	ld	s5,40(sp)
 21e:	7b02                	ld	s6,32(sp)
 220:	6be2                	ld	s7,24(sp)
 222:	6125                	addi	sp,sp,96
 224:	8082                	ret

0000000000000226 <stat>:

int
stat(const char *n, struct stat *st)
{
 226:	1101                	addi	sp,sp,-32
 228:	ec06                	sd	ra,24(sp)
 22a:	e822                	sd	s0,16(sp)
 22c:	e426                	sd	s1,8(sp)
 22e:	e04a                	sd	s2,0(sp)
 230:	1000                	addi	s0,sp,32
 232:	892e                	mv	s2,a1
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 234:	4581                	li	a1,0
 236:	00000097          	auipc	ra,0x0
 23a:	170080e7          	jalr	368(ra) # 3a6 <open>
  if(fd < 0)
 23e:	02054563          	bltz	a0,268 <stat+0x42>
 242:	84aa                	mv	s1,a0
    return -1;
  r = fstat(fd, st);
 244:	85ca                	mv	a1,s2
 246:	00000097          	auipc	ra,0x0
 24a:	178080e7          	jalr	376(ra) # 3be <fstat>
 24e:	892a                	mv	s2,a0
  close(fd);
 250:	8526                	mv	a0,s1
 252:	00000097          	auipc	ra,0x0
 256:	13c080e7          	jalr	316(ra) # 38e <close>
  return r;
}
 25a:	854a                	mv	a0,s2
 25c:	60e2                	ld	ra,24(sp)
 25e:	6442                	ld	s0,16(sp)
 260:	64a2                	ld	s1,8(sp)
 262:	6902                	ld	s2,0(sp)
 264:	6105                	addi	sp,sp,32
 266:	8082                	ret
    return -1;
 268:	597d                	li	s2,-1
 26a:	bfc5                	j	25a <stat+0x34>

000000000000026c <atoi>:

int
atoi(const char *s)
{
 26c:	1141                	addi	sp,sp,-16
 26e:	e422                	sd	s0,8(sp)
 270:	0800                	addi	s0,sp,16
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
 272:	00054683          	lbu	a3,0(a0)
 276:	fd06879b          	addiw	a5,a3,-48
 27a:	0ff7f793          	zext.b	a5,a5
 27e:	4625                	li	a2,9
 280:	02f66863          	bltu	a2,a5,2b0 <atoi+0x44>
 284:	872a                	mv	a4,a0
  n = 0;
 286:	4501                	li	a0,0
    n = n*10 + *s++ - '0';
 288:	0705                	addi	a4,a4,1
 28a:	0025179b          	slliw	a5,a0,0x2
 28e:	9fa9                	addw	a5,a5,a0
 290:	0017979b          	slliw	a5,a5,0x1
 294:	9fb5                	addw	a5,a5,a3
 296:	fd07851b          	addiw	a0,a5,-48
  while('0' <= *s && *s <= '9')
 29a:	00074683          	lbu	a3,0(a4)
 29e:	fd06879b          	addiw	a5,a3,-48
 2a2:	0ff7f793          	zext.b	a5,a5
 2a6:	fef671e3          	bgeu	a2,a5,288 <atoi+0x1c>
  return n;
}
 2aa:	6422                	ld	s0,8(sp)
 2ac:	0141                	addi	sp,sp,16
 2ae:	8082                	ret
  n = 0;
 2b0:	4501                	li	a0,0
 2b2:	bfe5                	j	2aa <atoi+0x3e>

00000000000002b4 <memmove>:

void*
memmove(void *vdst, const void *vsrc, int n)
{
 2b4:	1141                	addi	sp,sp,-16
 2b6:	e422                	sd	s0,8(sp)
 2b8:	0800                	addi	s0,sp,16
  char *dst;
  const char *src;

  dst = vdst;
  src = vsrc;
  if (src > dst) {
 2ba:	02b57463          	bgeu	a0,a1,2e2 <memmove+0x2e>
    while(n-- > 0)
 2be:	00c05f63          	blez	a2,2dc <memmove+0x28>
 2c2:	1602                	slli	a2,a2,0x20
 2c4:	9201                	srli	a2,a2,0x20
 2c6:	00c507b3          	add	a5,a0,a2
  dst = vdst;
 2ca:	872a                	mv	a4,a0
      *dst++ = *src++;
 2cc:	0585                	addi	a1,a1,1
 2ce:	0705                	addi	a4,a4,1
 2d0:	fff5c683          	lbu	a3,-1(a1)
 2d4:	fed70fa3          	sb	a3,-1(a4)
    while(n-- > 0)
 2d8:	fee79ae3          	bne	a5,a4,2cc <memmove+0x18>
    src += n;
    while(n-- > 0)
      *--dst = *--src;
  }
  return vdst;
}
 2dc:	6422                	ld	s0,8(sp)
 2de:	0141                	addi	sp,sp,16
 2e0:	8082                	ret
    dst += n;
 2e2:	00c50733          	add	a4,a0,a2
    src += n;
 2e6:	95b2                	add	a1,a1,a2
    while(n-- > 0)
 2e8:	fec05ae3          	blez	a2,2dc <memmove+0x28>
 2ec:	fff6079b          	addiw	a5,a2,-1
 2f0:	1782                	slli	a5,a5,0x20
 2f2:	9381                	srli	a5,a5,0x20
 2f4:	fff7c793          	not	a5,a5
 2f8:	97ba                	add	a5,a5,a4
      *--dst = *--src;
 2fa:	15fd                	addi	a1,a1,-1
 2fc:	177d                	addi	a4,a4,-1
 2fe:	0005c683          	lbu	a3,0(a1)
 302:	00d70023          	sb	a3,0(a4)
    while(n-- > 0)
 306:	fee79ae3          	bne	a5,a4,2fa <memmove+0x46>
 30a:	bfc9                	j	2dc <memmove+0x28>

000000000000030c <memcmp>:

int
memcmp(const void *s1, const void *s2, uint n)
{
 30c:	1141                	addi	sp,sp,-16
 30e:	e422                	sd	s0,8(sp)
 310:	0800                	addi	s0,sp,16
  const char *p1 = s1, *p2 = s2;
  while (n-- > 0) {
 312:	ca05                	beqz	a2,342 <memcmp+0x36>
 314:	fff6069b          	addiw	a3,a2,-1
 318:	1682                	slli	a3,a3,0x20
 31a:	9281                	srli	a3,a3,0x20
 31c:	0685                	addi	a3,a3,1
 31e:	96aa                	add	a3,a3,a0
    if (*p1 != *p2) {
 320:	00054783          	lbu	a5,0(a0)
 324:	0005c703          	lbu	a4,0(a1)
 328:	00e79863          	bne	a5,a4,338 <memcmp+0x2c>
      return *p1 - *p2;
    }
    p1++;
 32c:	0505                	addi	a0,a0,1
    p2++;
 32e:	0585                	addi	a1,a1,1
  while (n-- > 0) {
 330:	fed518e3          	bne	a0,a3,320 <memcmp+0x14>
  }
  return 0;
 334:	4501                	li	a0,0
 336:	a019                	j	33c <memcmp+0x30>
      return *p1 - *p2;
 338:	40e7853b          	subw	a0,a5,a4
}
 33c:	6422                	ld	s0,8(sp)
 33e:	0141                	addi	sp,sp,16
 340:	8082                	ret
  return 0;
 342:	4501                	li	a0,0
 344:	bfe5                	j	33c <memcmp+0x30>

0000000000000346 <memcpy>:

void *
memcpy(void *dst, const void *src, uint n)
{
 346:	1141                	addi	sp,sp,-16
 348:	e406                	sd	ra,8(sp)
 34a:	e022                	sd	s0,0(sp)
 34c:	0800                	addi	s0,sp,16
  return memmove(dst, src, n);
 34e:	00000097          	auipc	ra,0x0
 352:	f66080e7          	jalr	-154(ra) # 2b4 <memmove>
}
 356:	60a2                	ld	ra,8(sp)
 358:	6402                	ld	s0,0(sp)
 35a:	0141                	addi	sp,sp,16
 35c:	8082                	ret

000000000000035e <fork>:
# generated by usys.pl - do not edit
#include "kernel/syscall.h"
.global fork
fork:
 li a7, SYS_fork
 35e:	4885                	li	a7,1
 ecall
 360:	00000073          	ecall
 ret
 364:	8082                	ret

0000000000000366 <exit>:
.global exit
exit:
 li a7, SYS_exit
 366:	4889                	li	a7,2
 ecall
 368:	00000073          	ecall
 ret
 36c:	8082                	ret

000000000000036e <wait>:
.global wait
wait:
 li a7, SYS_wait
 36e:	488d                	li	a7,3
 ecall
 370:	00000073          	ecall
 ret
 374:	8082                	ret

0000000000000376 <pipe>:
.global pipe
pipe:
 li a7, SYS_pipe
 376:	4891                	li	a7,4
 ecall
 378:	00000073          	ecall
 ret
 37c:	8082                	ret

000000000000037e <read>:
.global read
read:
 li a7, SYS_read
 37e:	4895                	li	a7,5
 ecall
 380:	00000073          	ecall
 ret
 384:	8082                	ret

0000000000000386 <write>:
.global write
write:
 li a7, SYS_write
 386:	48c1                	li	a7,16
 ecall
 388:	00000073          	ecall
 ret
 38c:	8082                	ret

000000000000038e <close>:
.global close
close:
 li a7, SYS_close
 38e:	48d5                	li	a7,21
 ecall
 390:	00000073          	ecall
 ret
 394:	8082                	ret

0000000000000396 <kill>:
.global kill
kill:
 li a7, SYS_kill
 396:	4899                	li	a7,6
 ecall
 398:	00000073          	ecall
 ret
 39c:	8082                	ret

000000000000039e <exec>:
.global exec
exec:
 li a7, SYS_exec
 39e:	489d                	li	a7,7
 ecall
 3a0:	00000073          	ecall
 ret
 3a4:	8082                	ret

00000000000003a6 <open>:
.global open
open:
 li a7, SYS_open
 3a6:	48bd                	li	a7,15
 ecall
 3a8:	00000073          	ecall
 ret
 3ac:	8082                	ret

00000000000003ae <mknod>:
.global mknod
mknod:
 li a7, SYS_mknod
 3ae:	48c5                	li	a7,17
 ecall
 3b0:	00000073          	ecall
 ret
 3b4:	8082                	ret

00000000000003b6 <unlink>:
.global unlink
unlink:
 li a7, SYS_unlink
 3b6:	48c9                	li	a7,18
 ecall
 3b8:	00000073          	ecall
 ret
 3bc:	8082                	ret

00000000000003be <fstat>:
.global fstat
fstat:
 li a7, SYS_fstat
 3be:	48a1                	li	a7,8
 ecall
 3c0:	00000073          	ecall
 ret
 3c4:	8082                	ret

00000000000003c6 <link>:
.global link
link:
 li a7, SYS_link
 3c6:	48cd                	li	a7,19
 ecall
 3c8:	00000073          	ecall
 ret
 3cc:	8082                	ret

00000000000003ce <mkdir>:
.global mkdir
mkdir:
 li a7, SYS_mkdir
 3ce:	48d1                	li	a7,20
 ecall
 3d0:	00000073          	ecall
 ret
 3d4:	8082                	ret

00000000000003d6 <chdir>:
.global chdir
chdir:
 li a7, SYS_chdir
 3d6:	48a5                	li	a7,9
 ecall
 3d8:	00000073          	ecall
 ret
 3dc:	8082                	ret

00000000000003de <dup>:
.global dup
dup:
 li a7, SYS_dup
 3de:	48a9                	li	a7,10
 ecall
 3e0:	00000073          	ecall
 ret
 3e4:	8082                	ret

00000000000003e6 <getpid>:
.global getpid
getpid:
 li a7, SYS_getpid
 3e6:	48ad                	li	a7,11
 ecall
 3e8:	00000073          	ecall
 ret
 3ec:	8082                	ret

00000000000003ee <sbrk>:
.global sbrk
sbrk:
 li a7, SYS_sbrk
 3ee:	48b1                	li	a7,12
 ecall
 3f0:	00000073          	ecall
 ret
 3f4:	8082                	ret

00000000000003f6 <sleep>:
.global sleep
sleep:
 li a7, SYS_sleep
 3f6:	48b5                	li	a7,13
 ecall
 3f8:	00000073          	ecall
 ret
 3fc:	8082                	ret

00000000000003fe <uptime>:
.global uptime
uptime:
 li a7, SYS_uptime
 3fe:	48b9                	li	a7,14
 ecall
 400:	00000073          	ecall
 ret
 404:	8082                	ret

0000000000000406 <spoon>:
.global spoon
spoon:
 li a7, SYS_spoon
 406:	48d9                	li	a7,22
 ecall
 408:	00000073          	ecall
 ret
 40c:	8082                	ret

000000000000040e <create_thread>:
.global create_thread
create_thread:
 li a7, SYS_create_thread
 40e:	48dd                	li	a7,23
 ecall
 410:	00000073          	ecall
 ret
 414:	8082                	ret

0000000000000416 <join_thread>:
.global join_thread
join_thread:
 li a7, SYS_join_thread
 416:	48e1                	li	a7,24
 ecall
 418:	00000073          	ecall
 ret
 41c:	8082                	ret

000000000000041e <thread_exit>:
.global thread_exit
thread_exit:
 li a7, SYS_thread_exit
 41e:	48e5                	li	a7,25
 ecall
 420:	00000073          	ecall
 ret
 424:	8082                	ret

0000000000000426 <putc>:

static char digits[] = "0123456789ABCDEF";

static void
putc(int fd, char c)
{
 426:	1101                	addi	sp,sp,-32
 428:	ec06                	sd	ra,24(sp)
 42a:	e822                	sd	s0,16(sp)
 42c:	1000                	addi	s0,sp,32
 42e:	feb407a3          	sb	a1,-17(s0)
  write(fd, &c, 1);
 432:	4605                	li	a2,1
 434:	fef40593          	addi	a1,s0,-17
 438:	00000097          	auipc	ra,0x0
 43c:	f4e080e7          	jalr	-178(ra) # 386 <write>
}
 440:	60e2                	ld	ra,24(sp)
 442:	6442                	ld	s0,16(sp)
 444:	6105                	addi	sp,sp,32
 446:	8082                	ret

0000000000000448 <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
 448:	7139                	addi	sp,sp,-64
 44a:	fc06                	sd	ra,56(sp)
 44c:	f822                	sd	s0,48(sp)
 44e:	f426                	sd	s1,40(sp)
 450:	f04a                	sd	s2,32(sp)
 452:	ec4e                	sd	s3,24(sp)
 454:	0080                	addi	s0,sp,64
 456:	84aa                	mv	s1,a0
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
  if(sgn && xx < 0){
 458:	c299                	beqz	a3,45e <printint+0x16>
 45a:	0805c963          	bltz	a1,4ec <printint+0xa4>
    neg = 1;
    x = -xx;
  } else {
    x = xx;
 45e:	2581                	sext.w	a1,a1
  neg = 0;
 460:	4881                	li	a7,0
 462:	fc040693          	addi	a3,s0,-64
  }

  i = 0;
 466:	4701                	li	a4,0
  do{
    buf[i++] = digits[x % base];
 468:	2601                	sext.w	a2,a2
 46a:	00000517          	auipc	a0,0x0
 46e:	70e50513          	addi	a0,a0,1806 # b78 <digits>
 472:	883a                	mv	a6,a4
 474:	2705                	addiw	a4,a4,1
 476:	02c5f7bb          	remuw	a5,a1,a2
 47a:	1782                	slli	a5,a5,0x20
 47c:	9381                	srli	a5,a5,0x20
 47e:	97aa                	add	a5,a5,a0
 480:	0007c783          	lbu	a5,0(a5)
 484:	00f68023          	sb	a5,0(a3)
  }while((x /= base) != 0);
 488:	0005879b          	sext.w	a5,a1
 48c:	02c5d5bb          	divuw	a1,a1,a2
 490:	0685                	addi	a3,a3,1
 492:	fec7f0e3          	bgeu	a5,a2,472 <printint+0x2a>
  if(neg)
 496:	00088c63          	beqz	a7,4ae <printint+0x66>
    buf[i++] = '-';
 49a:	fd070793          	addi	a5,a4,-48
 49e:	00878733          	add	a4,a5,s0
 4a2:	02d00793          	li	a5,45
 4a6:	fef70823          	sb	a5,-16(a4)
 4aa:	0028071b          	addiw	a4,a6,2

  while(--i >= 0)
 4ae:	02e05863          	blez	a4,4de <printint+0x96>
 4b2:	fc040793          	addi	a5,s0,-64
 4b6:	00e78933          	add	s2,a5,a4
 4ba:	fff78993          	addi	s3,a5,-1
 4be:	99ba                	add	s3,s3,a4
 4c0:	377d                	addiw	a4,a4,-1
 4c2:	1702                	slli	a4,a4,0x20
 4c4:	9301                	srli	a4,a4,0x20
 4c6:	40e989b3          	sub	s3,s3,a4
    putc(fd, buf[i]);
 4ca:	fff94583          	lbu	a1,-1(s2)
 4ce:	8526                	mv	a0,s1
 4d0:	00000097          	auipc	ra,0x0
 4d4:	f56080e7          	jalr	-170(ra) # 426 <putc>
  while(--i >= 0)
 4d8:	197d                	addi	s2,s2,-1
 4da:	ff3918e3          	bne	s2,s3,4ca <printint+0x82>
}
 4de:	70e2                	ld	ra,56(sp)
 4e0:	7442                	ld	s0,48(sp)
 4e2:	74a2                	ld	s1,40(sp)
 4e4:	7902                	ld	s2,32(sp)
 4e6:	69e2                	ld	s3,24(sp)
 4e8:	6121                	addi	sp,sp,64
 4ea:	8082                	ret
    x = -xx;
 4ec:	40b005bb          	negw	a1,a1
    neg = 1;
 4f0:	4885                	li	a7,1
    x = -xx;
 4f2:	bf85                	j	462 <printint+0x1a>

00000000000004f4 <vprintf>:
}

// Print to the given fd. Only understands %d, %x, %p, %s.
void
vprintf(int fd, const char *fmt, va_list ap)
{
 4f4:	7119                	addi	sp,sp,-128
 4f6:	fc86                	sd	ra,120(sp)
 4f8:	f8a2                	sd	s0,112(sp)
 4fa:	f4a6                	sd	s1,104(sp)
 4fc:	f0ca                	sd	s2,96(sp)
 4fe:	ecce                	sd	s3,88(sp)
 500:	e8d2                	sd	s4,80(sp)
 502:	e4d6                	sd	s5,72(sp)
 504:	e0da                	sd	s6,64(sp)
 506:	fc5e                	sd	s7,56(sp)
 508:	f862                	sd	s8,48(sp)
 50a:	f466                	sd	s9,40(sp)
 50c:	f06a                	sd	s10,32(sp)
 50e:	ec6e                	sd	s11,24(sp)
 510:	0100                	addi	s0,sp,128
  char *s;
  int c, i, state;

  state = 0;
  for(i = 0; fmt[i]; i++){
 512:	0005c903          	lbu	s2,0(a1)
 516:	18090f63          	beqz	s2,6b4 <vprintf+0x1c0>
 51a:	8aaa                	mv	s5,a0
 51c:	8b32                	mv	s6,a2
 51e:	00158493          	addi	s1,a1,1
  state = 0;
 522:	4981                	li	s3,0
      if(c == '%'){
        state = '%';
      } else {
        putc(fd, c);
      }
    } else if(state == '%'){
 524:	02500a13          	li	s4,37
 528:	4c55                	li	s8,21
 52a:	00000c97          	auipc	s9,0x0
 52e:	5f6c8c93          	addi	s9,s9,1526 # b20 <ithread_join+0x84>
        printptr(fd, va_arg(ap, uint64));
      } else if(c == 's'){
        s = va_arg(ap, char*);
        if(s == 0)
          s = "(null)";
        while(*s != 0){
 532:	02800d93          	li	s11,40
  putc(fd, 'x');
 536:	4d41                	li	s10,16
    putc(fd, digits[x >> (sizeof(uint64) * 8 - 4)]);
 538:	00000b97          	auipc	s7,0x0
 53c:	640b8b93          	addi	s7,s7,1600 # b78 <digits>
 540:	a839                	j	55e <vprintf+0x6a>
        putc(fd, c);
 542:	85ca                	mv	a1,s2
 544:	8556                	mv	a0,s5
 546:	00000097          	auipc	ra,0x0
 54a:	ee0080e7          	jalr	-288(ra) # 426 <putc>
 54e:	a019                	j	554 <vprintf+0x60>
    } else if(state == '%'){
 550:	01498d63          	beq	s3,s4,56a <vprintf+0x76>
  for(i = 0; fmt[i]; i++){
 554:	0485                	addi	s1,s1,1
 556:	fff4c903          	lbu	s2,-1(s1)
 55a:	14090d63          	beqz	s2,6b4 <vprintf+0x1c0>
    if(state == 0){
 55e:	fe0999e3          	bnez	s3,550 <vprintf+0x5c>
      if(c == '%'){
 562:	ff4910e3          	bne	s2,s4,542 <vprintf+0x4e>
        state = '%';
 566:	89d2                	mv	s3,s4
 568:	b7f5                	j	554 <vprintf+0x60>
      if(c == 'd'){
 56a:	11490c63          	beq	s2,s4,682 <vprintf+0x18e>
 56e:	f9d9079b          	addiw	a5,s2,-99
 572:	0ff7f793          	zext.b	a5,a5
 576:	10fc6e63          	bltu	s8,a5,692 <vprintf+0x19e>
 57a:	f9d9079b          	addiw	a5,s2,-99
 57e:	0ff7f713          	zext.b	a4,a5
 582:	10ec6863          	bltu	s8,a4,692 <vprintf+0x19e>
 586:	00271793          	slli	a5,a4,0x2
 58a:	97e6                	add	a5,a5,s9
 58c:	439c                	lw	a5,0(a5)
 58e:	97e6                	add	a5,a5,s9
 590:	8782                	jr	a5
        printint(fd, va_arg(ap, int), 10, 1);
 592:	008b0913          	addi	s2,s6,8
 596:	4685                	li	a3,1
 598:	4629                	li	a2,10
 59a:	000b2583          	lw	a1,0(s6)
 59e:	8556                	mv	a0,s5
 5a0:	00000097          	auipc	ra,0x0
 5a4:	ea8080e7          	jalr	-344(ra) # 448 <printint>
 5a8:	8b4a                	mv	s6,s2
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
        putc(fd, c);
      }
      state = 0;
 5aa:	4981                	li	s3,0
 5ac:	b765                	j	554 <vprintf+0x60>
        printint(fd, va_arg(ap, uint64), 10, 0);
 5ae:	008b0913          	addi	s2,s6,8
 5b2:	4681                	li	a3,0
 5b4:	4629                	li	a2,10
 5b6:	000b2583          	lw	a1,0(s6)
 5ba:	8556                	mv	a0,s5
 5bc:	00000097          	auipc	ra,0x0
 5c0:	e8c080e7          	jalr	-372(ra) # 448 <printint>
 5c4:	8b4a                	mv	s6,s2
      state = 0;
 5c6:	4981                	li	s3,0
 5c8:	b771                	j	554 <vprintf+0x60>
        printint(fd, va_arg(ap, int), 16, 0);
 5ca:	008b0913          	addi	s2,s6,8
 5ce:	4681                	li	a3,0
 5d0:	866a                	mv	a2,s10
 5d2:	000b2583          	lw	a1,0(s6)
 5d6:	8556                	mv	a0,s5
 5d8:	00000097          	auipc	ra,0x0
 5dc:	e70080e7          	jalr	-400(ra) # 448 <printint>
 5e0:	8b4a                	mv	s6,s2
      state = 0;
 5e2:	4981                	li	s3,0
 5e4:	bf85                	j	554 <vprintf+0x60>
        printptr(fd, va_arg(ap, uint64));
 5e6:	008b0793          	addi	a5,s6,8
 5ea:	f8f43423          	sd	a5,-120(s0)
 5ee:	000b3983          	ld	s3,0(s6)
  putc(fd, '0');
 5f2:	03000593          	li	a1,48
 5f6:	8556                	mv	a0,s5
 5f8:	00000097          	auipc	ra,0x0
 5fc:	e2e080e7          	jalr	-466(ra) # 426 <putc>
  putc(fd, 'x');
 600:	07800593          	li	a1,120
 604:	8556                	mv	a0,s5
 606:	00000097          	auipc	ra,0x0
 60a:	e20080e7          	jalr	-480(ra) # 426 <putc>
 60e:	896a                	mv	s2,s10
    putc(fd, digits[x >> (sizeof(uint64) * 8 - 4)]);
 610:	03c9d793          	srli	a5,s3,0x3c
 614:	97de                	add	a5,a5,s7
 616:	0007c583          	lbu	a1,0(a5)
 61a:	8556                	mv	a0,s5
 61c:	00000097          	auipc	ra,0x0
 620:	e0a080e7          	jalr	-502(ra) # 426 <putc>
  for (i = 0; i < (sizeof(uint64) * 2); i++, x <<= 4)
 624:	0992                	slli	s3,s3,0x4
 626:	397d                	addiw	s2,s2,-1
 628:	fe0914e3          	bnez	s2,610 <vprintf+0x11c>
        printptr(fd, va_arg(ap, uint64));
 62c:	f8843b03          	ld	s6,-120(s0)
      state = 0;
 630:	4981                	li	s3,0
 632:	b70d                	j	554 <vprintf+0x60>
        s = va_arg(ap, char*);
 634:	008b0913          	addi	s2,s6,8
 638:	000b3983          	ld	s3,0(s6)
        if(s == 0)
 63c:	02098163          	beqz	s3,65e <vprintf+0x16a>
        while(*s != 0){
 640:	0009c583          	lbu	a1,0(s3)
 644:	c5ad                	beqz	a1,6ae <vprintf+0x1ba>
          putc(fd, *s);
 646:	8556                	mv	a0,s5
 648:	00000097          	auipc	ra,0x0
 64c:	dde080e7          	jalr	-546(ra) # 426 <putc>
          s++;
 650:	0985                	addi	s3,s3,1
        while(*s != 0){
 652:	0009c583          	lbu	a1,0(s3)
 656:	f9e5                	bnez	a1,646 <vprintf+0x152>
        s = va_arg(ap, char*);
 658:	8b4a                	mv	s6,s2
      state = 0;
 65a:	4981                	li	s3,0
 65c:	bde5                	j	554 <vprintf+0x60>
          s = "(null)";
 65e:	00000997          	auipc	s3,0x0
 662:	4ba98993          	addi	s3,s3,1210 # b18 <ithread_join+0x7c>
        while(*s != 0){
 666:	85ee                	mv	a1,s11
 668:	bff9                	j	646 <vprintf+0x152>
        putc(fd, va_arg(ap, uint));
 66a:	008b0913          	addi	s2,s6,8
 66e:	000b4583          	lbu	a1,0(s6)
 672:	8556                	mv	a0,s5
 674:	00000097          	auipc	ra,0x0
 678:	db2080e7          	jalr	-590(ra) # 426 <putc>
 67c:	8b4a                	mv	s6,s2
      state = 0;
 67e:	4981                	li	s3,0
 680:	bdd1                	j	554 <vprintf+0x60>
        putc(fd, c);
 682:	85d2                	mv	a1,s4
 684:	8556                	mv	a0,s5
 686:	00000097          	auipc	ra,0x0
 68a:	da0080e7          	jalr	-608(ra) # 426 <putc>
      state = 0;
 68e:	4981                	li	s3,0
 690:	b5d1                	j	554 <vprintf+0x60>
        putc(fd, '%');
 692:	85d2                	mv	a1,s4
 694:	8556                	mv	a0,s5
 696:	00000097          	auipc	ra,0x0
 69a:	d90080e7          	jalr	-624(ra) # 426 <putc>
        putc(fd, c);
 69e:	85ca                	mv	a1,s2
 6a0:	8556                	mv	a0,s5
 6a2:	00000097          	auipc	ra,0x0
 6a6:	d84080e7          	jalr	-636(ra) # 426 <putc>
      state = 0;
 6aa:	4981                	li	s3,0
 6ac:	b565                	j	554 <vprintf+0x60>
        s = va_arg(ap, char*);
 6ae:	8b4a                	mv	s6,s2
      state = 0;
 6b0:	4981                	li	s3,0
 6b2:	b54d                	j	554 <vprintf+0x60>
    }
  }
}
 6b4:	70e6                	ld	ra,120(sp)
 6b6:	7446                	ld	s0,112(sp)
 6b8:	74a6                	ld	s1,104(sp)
 6ba:	7906                	ld	s2,96(sp)
 6bc:	69e6                	ld	s3,88(sp)
 6be:	6a46                	ld	s4,80(sp)
 6c0:	6aa6                	ld	s5,72(sp)
 6c2:	6b06                	ld	s6,64(sp)
 6c4:	7be2                	ld	s7,56(sp)
 6c6:	7c42                	ld	s8,48(sp)
 6c8:	7ca2                	ld	s9,40(sp)
 6ca:	7d02                	ld	s10,32(sp)
 6cc:	6de2                	ld	s11,24(sp)
 6ce:	6109                	addi	sp,sp,128
 6d0:	8082                	ret

00000000000006d2 <fprintf>:

void
fprintf(int fd, const char *fmt, ...)
{
 6d2:	715d                	addi	sp,sp,-80
 6d4:	ec06                	sd	ra,24(sp)
 6d6:	e822                	sd	s0,16(sp)
 6d8:	1000                	addi	s0,sp,32
 6da:	e010                	sd	a2,0(s0)
 6dc:	e414                	sd	a3,8(s0)
 6de:	e818                	sd	a4,16(s0)
 6e0:	ec1c                	sd	a5,24(s0)
 6e2:	03043023          	sd	a6,32(s0)
 6e6:	03143423          	sd	a7,40(s0)
  va_list ap;

  va_start(ap, fmt);
 6ea:	fe843423          	sd	s0,-24(s0)
  vprintf(fd, fmt, ap);
 6ee:	8622                	mv	a2,s0
 6f0:	00000097          	auipc	ra,0x0
 6f4:	e04080e7          	jalr	-508(ra) # 4f4 <vprintf>
}
 6f8:	60e2                	ld	ra,24(sp)
 6fa:	6442                	ld	s0,16(sp)
 6fc:	6161                	addi	sp,sp,80
 6fe:	8082                	ret

0000000000000700 <printf>:

void
printf(const char *fmt, ...)
{
 700:	711d                	addi	sp,sp,-96
 702:	ec06                	sd	ra,24(sp)
 704:	e822                	sd	s0,16(sp)
 706:	1000                	addi	s0,sp,32
 708:	e40c                	sd	a1,8(s0)
 70a:	e810                	sd	a2,16(s0)
 70c:	ec14                	sd	a3,24(s0)
 70e:	f018                	sd	a4,32(s0)
 710:	f41c                	sd	a5,40(s0)
 712:	03043823          	sd	a6,48(s0)
 716:	03143c23          	sd	a7,56(s0)
  va_list ap;

  va_start(ap, fmt);
 71a:	00840613          	addi	a2,s0,8
 71e:	fec43423          	sd	a2,-24(s0)
  vprintf(1, fmt, ap);
 722:	85aa                	mv	a1,a0
 724:	4505                	li	a0,1
 726:	00000097          	auipc	ra,0x0
 72a:	dce080e7          	jalr	-562(ra) # 4f4 <vprintf>
}
 72e:	60e2                	ld	ra,24(sp)
 730:	6442                	ld	s0,16(sp)
 732:	6125                	addi	sp,sp,96
 734:	8082                	ret

0000000000000736 <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 736:	1141                	addi	sp,sp,-16
 738:	e422                	sd	s0,8(sp)
 73a:	0800                	addi	s0,sp,16
  Header *bp, *p;

  bp = (Header*)ap - 1;
 73c:	ff050693          	addi	a3,a0,-16
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 740:	00001797          	auipc	a5,0x1
 744:	8d07b783          	ld	a5,-1840(a5) # 1010 <freep>
 748:	a02d                	j	772 <free+0x3c>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
      break;
  if(bp + bp->s.size == p->s.ptr){
    bp->s.size += p->s.ptr->s.size;
 74a:	4618                	lw	a4,8(a2)
 74c:	9f2d                	addw	a4,a4,a1
 74e:	fee52c23          	sw	a4,-8(a0)
    bp->s.ptr = p->s.ptr->s.ptr;
 752:	6398                	ld	a4,0(a5)
 754:	6310                	ld	a2,0(a4)
 756:	a83d                	j	794 <free+0x5e>
  } else
    bp->s.ptr = p->s.ptr;
  if(p + p->s.size == bp){
    p->s.size += bp->s.size;
 758:	ff852703          	lw	a4,-8(a0)
 75c:	9f31                	addw	a4,a4,a2
 75e:	c798                	sw	a4,8(a5)
    p->s.ptr = bp->s.ptr;
 760:	ff053683          	ld	a3,-16(a0)
 764:	a091                	j	7a8 <free+0x72>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 766:	6398                	ld	a4,0(a5)
 768:	00e7e463          	bltu	a5,a4,770 <free+0x3a>
 76c:	00e6ea63          	bltu	a3,a4,780 <free+0x4a>
{
 770:	87ba                	mv	a5,a4
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 772:	fed7fae3          	bgeu	a5,a3,766 <free+0x30>
 776:	6398                	ld	a4,0(a5)
 778:	00e6e463          	bltu	a3,a4,780 <free+0x4a>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 77c:	fee7eae3          	bltu	a5,a4,770 <free+0x3a>
  if(bp + bp->s.size == p->s.ptr){
 780:	ff852583          	lw	a1,-8(a0)
 784:	6390                	ld	a2,0(a5)
 786:	02059813          	slli	a6,a1,0x20
 78a:	01c85713          	srli	a4,a6,0x1c
 78e:	9736                	add	a4,a4,a3
 790:	fae60de3          	beq	a2,a4,74a <free+0x14>
    bp->s.ptr = p->s.ptr->s.ptr;
 794:	fec53823          	sd	a2,-16(a0)
  if(p + p->s.size == bp){
 798:	4790                	lw	a2,8(a5)
 79a:	02061593          	slli	a1,a2,0x20
 79e:	01c5d713          	srli	a4,a1,0x1c
 7a2:	973e                	add	a4,a4,a5
 7a4:	fae68ae3          	beq	a3,a4,758 <free+0x22>
    p->s.ptr = bp->s.ptr;
 7a8:	e394                	sd	a3,0(a5)
  } else
    p->s.ptr = bp;
  freep = p;
 7aa:	00001717          	auipc	a4,0x1
 7ae:	86f73323          	sd	a5,-1946(a4) # 1010 <freep>
}
 7b2:	6422                	ld	s0,8(sp)
 7b4:	0141                	addi	sp,sp,16
 7b6:	8082                	ret

00000000000007b8 <malloc>:
  return freep;
}

void*
malloc(uint nbytes)
{
 7b8:	7139                	addi	sp,sp,-64
 7ba:	fc06                	sd	ra,56(sp)
 7bc:	f822                	sd	s0,48(sp)
 7be:	f426                	sd	s1,40(sp)
 7c0:	f04a                	sd	s2,32(sp)
 7c2:	ec4e                	sd	s3,24(sp)
 7c4:	e852                	sd	s4,16(sp)
 7c6:	e456                	sd	s5,8(sp)
 7c8:	e05a                	sd	s6,0(sp)
 7ca:	0080                	addi	s0,sp,64
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 7cc:	02051493          	slli	s1,a0,0x20
 7d0:	9081                	srli	s1,s1,0x20
 7d2:	04bd                	addi	s1,s1,15
 7d4:	8091                	srli	s1,s1,0x4
 7d6:	0014899b          	addiw	s3,s1,1
 7da:	0485                	addi	s1,s1,1
  if((prevp = freep) == 0){
 7dc:	00001517          	auipc	a0,0x1
 7e0:	83453503          	ld	a0,-1996(a0) # 1010 <freep>
 7e4:	c515                	beqz	a0,810 <malloc+0x58>
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 7e6:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
 7e8:	4798                	lw	a4,8(a5)
 7ea:	02977f63          	bgeu	a4,s1,828 <malloc+0x70>
 7ee:	8a4e                	mv	s4,s3
 7f0:	0009871b          	sext.w	a4,s3
 7f4:	6685                	lui	a3,0x1
 7f6:	00d77363          	bgeu	a4,a3,7fc <malloc+0x44>
 7fa:	6a05                	lui	s4,0x1
 7fc:	000a0b1b          	sext.w	s6,s4
  p = sbrk(nu * sizeof(Header));
 800:	004a1a1b          	slliw	s4,s4,0x4
        p->s.size = nunits;
      }
      freep = prevp;
      return (void*)(p + 1);
    }
    if(p == freep)
 804:	00001917          	auipc	s2,0x1
 808:	80c90913          	addi	s2,s2,-2036 # 1010 <freep>
  if(p == (char*)-1)
 80c:	5afd                	li	s5,-1
 80e:	a895                	j	882 <malloc+0xca>
    base.s.ptr = freep = prevp = &base;
 810:	00001797          	auipc	a5,0x1
 814:	82078793          	addi	a5,a5,-2016 # 1030 <base>
 818:	00000717          	auipc	a4,0x0
 81c:	7ef73c23          	sd	a5,2040(a4) # 1010 <freep>
 820:	e39c                	sd	a5,0(a5)
    base.s.size = 0;
 822:	0007a423          	sw	zero,8(a5)
    if(p->s.size >= nunits){
 826:	b7e1                	j	7ee <malloc+0x36>
      if(p->s.size == nunits)
 828:	02e48c63          	beq	s1,a4,860 <malloc+0xa8>
        p->s.size -= nunits;
 82c:	4137073b          	subw	a4,a4,s3
 830:	c798                	sw	a4,8(a5)
        p += p->s.size;
 832:	02071693          	slli	a3,a4,0x20
 836:	01c6d713          	srli	a4,a3,0x1c
 83a:	97ba                	add	a5,a5,a4
        p->s.size = nunits;
 83c:	0137a423          	sw	s3,8(a5)
      freep = prevp;
 840:	00000717          	auipc	a4,0x0
 844:	7ca73823          	sd	a0,2000(a4) # 1010 <freep>
      return (void*)(p + 1);
 848:	01078513          	addi	a0,a5,16
      if((p = morecore(nunits)) == 0)
        return 0;
  }
}
 84c:	70e2                	ld	ra,56(sp)
 84e:	7442                	ld	s0,48(sp)
 850:	74a2                	ld	s1,40(sp)
 852:	7902                	ld	s2,32(sp)
 854:	69e2                	ld	s3,24(sp)
 856:	6a42                	ld	s4,16(sp)
 858:	6aa2                	ld	s5,8(sp)
 85a:	6b02                	ld	s6,0(sp)
 85c:	6121                	addi	sp,sp,64
 85e:	8082                	ret
        prevp->s.ptr = p->s.ptr;
 860:	6398                	ld	a4,0(a5)
 862:	e118                	sd	a4,0(a0)
 864:	bff1                	j	840 <malloc+0x88>
  hp->s.size = nu;
 866:	01652423          	sw	s6,8(a0)
  free((void*)(hp + 1));
 86a:	0541                	addi	a0,a0,16
 86c:	00000097          	auipc	ra,0x0
 870:	eca080e7          	jalr	-310(ra) # 736 <free>
  return freep;
 874:	00093503          	ld	a0,0(s2)
      if((p = morecore(nunits)) == 0)
 878:	d971                	beqz	a0,84c <malloc+0x94>
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 87a:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
 87c:	4798                	lw	a4,8(a5)
 87e:	fa9775e3          	bgeu	a4,s1,828 <malloc+0x70>
    if(p == freep)
 882:	00093703          	ld	a4,0(s2)
 886:	853e                	mv	a0,a5
 888:	fef719e3          	bne	a4,a5,87a <malloc+0xc2>
  p = sbrk(nu * sizeof(Header));
 88c:	8552                	mv	a0,s4
 88e:	00000097          	auipc	ra,0x0
 892:	b60080e7          	jalr	-1184(ra) # 3ee <sbrk>
  if(p == (char*)-1)
 896:	fd5518e3          	bne	a0,s5,866 <malloc+0xae>
        return 0;
 89a:	4501                	li	a0,0
 89c:	bf45                	j	84c <malloc+0x94>

000000000000089e <ithread_exit>:
  free(stacks);
  stacks = new_stacks;
  return 0;
}

void ithread_exit(uint64 status) {
 89e:	1141                	addi	sp,sp,-16
 8a0:	e406                	sd	ra,8(sp)
 8a2:	e022                	sd	s0,0(sp)
 8a4:	0800                	addi	s0,sp,16
  thread_exit(status);
 8a6:	00000097          	auipc	ra,0x0
 8aa:	b78080e7          	jalr	-1160(ra) # 41e <thread_exit>
}
 8ae:	60a2                	ld	ra,8(sp)
 8b0:	6402                	ld	s0,0(sp)
 8b2:	0141                	addi	sp,sp,16
 8b4:	8082                	ret

00000000000008b6 <free_stacks>:
int free_stacks() {
 8b6:	7179                	addi	sp,sp,-48
 8b8:	f406                	sd	ra,40(sp)
 8ba:	f022                	sd	s0,32(sp)
 8bc:	ec26                	sd	s1,24(sp)
 8be:	e84a                	sd	s2,16(sp)
 8c0:	e44e                	sd	s3,8(sp)
 8c2:	1800                	addi	s0,sp,48
  for (int i = 0; i < num_threads; i++) {
 8c4:	00000797          	auipc	a5,0x0
 8c8:	75c7a783          	lw	a5,1884(a5) # 1020 <num_threads>
 8cc:	02f05c63          	blez	a5,904 <free_stacks+0x4e>
 8d0:	4481                	li	s1,0
    free(stacks[i]);
 8d2:	00000997          	auipc	s3,0x0
 8d6:	74698993          	addi	s3,s3,1862 # 1018 <stacks>
  for (int i = 0; i < num_threads; i++) {
 8da:	00000917          	auipc	s2,0x0
 8de:	74690913          	addi	s2,s2,1862 # 1020 <num_threads>
    free(stacks[i]);
 8e2:	0009b783          	ld	a5,0(s3)
 8e6:	00349713          	slli	a4,s1,0x3
 8ea:	97ba                	add	a5,a5,a4
 8ec:	6388                	ld	a0,0(a5)
 8ee:	00000097          	auipc	ra,0x0
 8f2:	e48080e7          	jalr	-440(ra) # 736 <free>
  for (int i = 0; i < num_threads; i++) {
 8f6:	0485                	addi	s1,s1,1
 8f8:	00092703          	lw	a4,0(s2)
 8fc:	0004879b          	sext.w	a5,s1
 900:	fee7c1e3          	blt	a5,a4,8e2 <free_stacks+0x2c>
  free(stacks);
 904:	00000497          	auipc	s1,0x0
 908:	71448493          	addi	s1,s1,1812 # 1018 <stacks>
 90c:	6088                	ld	a0,0(s1)
 90e:	00000097          	auipc	ra,0x0
 912:	e28080e7          	jalr	-472(ra) # 736 <free>
  stacks = 0;
 916:	0004b023          	sd	zero,0(s1)
  num_threads = 0;
 91a:	00000797          	auipc	a5,0x0
 91e:	7007a323          	sw	zero,1798(a5) # 1020 <num_threads>
  max_stacks = INIT_MAX_STACKS;
 922:	47a1                	li	a5,8
 924:	00000717          	auipc	a4,0x0
 928:	6cf72e23          	sw	a5,1756(a4) # 1000 <max_stacks>
  threads_done = 0;
 92c:	00000797          	auipc	a5,0x0
 930:	6e07ac23          	sw	zero,1784(a5) # 1024 <threads_done>
}
 934:	4501                	li	a0,0
 936:	70a2                	ld	ra,40(sp)
 938:	7402                	ld	s0,32(sp)
 93a:	64e2                	ld	s1,24(sp)
 93c:	6942                	ld	s2,16(sp)
 93e:	69a2                	ld	s3,8(sp)
 940:	6145                	addi	sp,sp,48
 942:	8082                	ret

0000000000000944 <expand_num_threads>:
int expand_num_threads() {
 944:	1101                	addi	sp,sp,-32
 946:	ec06                	sd	ra,24(sp)
 948:	e822                	sd	s0,16(sp)
 94a:	e426                	sd	s1,8(sp)
 94c:	e04a                	sd	s2,0(sp)
 94e:	1000                	addi	s0,sp,32
  max_stacks *= 2;
 950:	00000797          	auipc	a5,0x0
 954:	6b078793          	addi	a5,a5,1712 # 1000 <max_stacks>
 958:	4388                	lw	a0,0(a5)
 95a:	0015151b          	slliw	a0,a0,0x1
 95e:	c388                	sw	a0,0(a5)
  void **new_stacks = malloc(max_stacks*sizeof(char*));
 960:	0035151b          	slliw	a0,a0,0x3
 964:	00000097          	auipc	ra,0x0
 968:	e54080e7          	jalr	-428(ra) # 7b8 <malloc>
 96c:	892a                	mv	s2,a0
  memmove(new_stacks, stacks, num_threads*sizeof(char*));
 96e:	00000617          	auipc	a2,0x0
 972:	6b262603          	lw	a2,1714(a2) # 1020 <num_threads>
 976:	00000497          	auipc	s1,0x0
 97a:	6a248493          	addi	s1,s1,1698 # 1018 <stacks>
 97e:	0036161b          	slliw	a2,a2,0x3
 982:	608c                	ld	a1,0(s1)
 984:	00000097          	auipc	ra,0x0
 988:	930080e7          	jalr	-1744(ra) # 2b4 <memmove>
  free(stacks);
 98c:	6088                	ld	a0,0(s1)
 98e:	00000097          	auipc	ra,0x0
 992:	da8080e7          	jalr	-600(ra) # 736 <free>
  stacks = new_stacks;
 996:	0124b023          	sd	s2,0(s1)
}
 99a:	4501                	li	a0,0
 99c:	60e2                	ld	ra,24(sp)
 99e:	6442                	ld	s0,16(sp)
 9a0:	64a2                	ld	s1,8(sp)
 9a2:	6902                	ld	s2,0(sp)
 9a4:	6105                	addi	sp,sp,32
 9a6:	8082                	ret

00000000000009a8 <ithread_create>:

int ithread_create(void* (*fn_ptr)(void *), void *args) {
 9a8:	7179                	addi	sp,sp,-48
 9aa:	f406                	sd	ra,40(sp)
 9ac:	f022                	sd	s0,32(sp)
 9ae:	ec26                	sd	s1,24(sp)
 9b0:	e84a                	sd	s2,16(sp)
 9b2:	e44e                	sd	s3,8(sp)
 9b4:	1800                	addi	s0,sp,48
 9b6:	892a                	mv	s2,a0
 9b8:	89ae                	mv	s3,a1
  if (stacks == 0) {
 9ba:	00000797          	auipc	a5,0x0
 9be:	65e7b783          	ld	a5,1630(a5) # 1018 <stacks>
 9c2:	c3d1                	beqz	a5,a46 <ithread_create+0x9e>
    stacks = malloc(max_stacks*sizeof(char*));
  }
  if (num_threads == max_stacks) {
 9c4:	00000797          	auipc	a5,0x0
 9c8:	63c7a783          	lw	a5,1596(a5) # 1000 <max_stacks>
 9cc:	00000717          	auipc	a4,0x0
 9d0:	65472703          	lw	a4,1620(a4) # 1020 <num_threads>
 9d4:	00f71a63          	bne	a4,a5,9e8 <ithread_create+0x40>
    if (max_stacks == MAX_THREADS) {
 9d8:	04000713          	li	a4,64
 9dc:	08e78463          	beq	a5,a4,a64 <ithread_create+0xbc>
      printf("ERROR: Thread capacity has been reached\n");
      return -1;
    }
    expand_num_threads();
 9e0:	00000097          	auipc	ra,0x0
 9e4:	f64080e7          	jalr	-156(ra) # 944 <expand_num_threads>
  }

  void *stack_ptr = malloc(PGSIZE);
 9e8:	6505                	lui	a0,0x1
 9ea:	00000097          	auipc	ra,0x0
 9ee:	dce080e7          	jalr	-562(ra) # 7b8 <malloc>
 9f2:	84aa                	mv	s1,a0
  stacks[num_threads] = stack_ptr;
 9f4:	00000717          	auipc	a4,0x0
 9f8:	62c72703          	lw	a4,1580(a4) # 1020 <num_threads>
 9fc:	070e                	slli	a4,a4,0x3
 9fe:	00000797          	auipc	a5,0x0
 a02:	61a7b783          	ld	a5,1562(a5) # 1018 <stacks>
 a06:	97ba                	add	a5,a5,a4
 a08:	e388                	sd	a0,0(a5)
  int res = create_thread(fn_ptr, args, stack_ptr, &ithread_exit);
 a0a:	00000697          	auipc	a3,0x0
 a0e:	e9468693          	addi	a3,a3,-364 # 89e <ithread_exit>
 a12:	862a                	mv	a2,a0
 a14:	85ce                	mv	a1,s3
 a16:	854a                	mv	a0,s2
 a18:	00000097          	auipc	ra,0x0
 a1c:	9f6080e7          	jalr	-1546(ra) # 40e <create_thread>
 a20:	892a                	mv	s2,a0
  if (res != -1) {
 a22:	57fd                	li	a5,-1
 a24:	04f50a63          	beq	a0,a5,a78 <ithread_create+0xd0>
    num_threads++;
 a28:	00000717          	auipc	a4,0x0
 a2c:	5f870713          	addi	a4,a4,1528 # 1020 <num_threads>
 a30:	431c                	lw	a5,0(a4)
 a32:	2785                	addiw	a5,a5,1
 a34:	c31c                	sw	a5,0(a4)
  } else {
    free(stack_ptr);
    stacks[num_threads] = 0;
  }
  return res;
}
 a36:	854a                	mv	a0,s2
 a38:	70a2                	ld	ra,40(sp)
 a3a:	7402                	ld	s0,32(sp)
 a3c:	64e2                	ld	s1,24(sp)
 a3e:	6942                	ld	s2,16(sp)
 a40:	69a2                	ld	s3,8(sp)
 a42:	6145                	addi	sp,sp,48
 a44:	8082                	ret
    stacks = malloc(max_stacks*sizeof(char*));
 a46:	00000517          	auipc	a0,0x0
 a4a:	5ba52503          	lw	a0,1466(a0) # 1000 <max_stacks>
 a4e:	0035151b          	slliw	a0,a0,0x3
 a52:	00000097          	auipc	ra,0x0
 a56:	d66080e7          	jalr	-666(ra) # 7b8 <malloc>
 a5a:	00000797          	auipc	a5,0x0
 a5e:	5aa7bf23          	sd	a0,1470(a5) # 1018 <stacks>
 a62:	b78d                	j	9c4 <ithread_create+0x1c>
      printf("ERROR: Thread capacity has been reached\n");
 a64:	00000517          	auipc	a0,0x0
 a68:	12c50513          	addi	a0,a0,300 # b90 <digits+0x18>
 a6c:	00000097          	auipc	ra,0x0
 a70:	c94080e7          	jalr	-876(ra) # 700 <printf>
      return -1;
 a74:	597d                	li	s2,-1
 a76:	b7c1                	j	a36 <ithread_create+0x8e>
    free(stack_ptr);
 a78:	8526                	mv	a0,s1
 a7a:	00000097          	auipc	ra,0x0
 a7e:	cbc080e7          	jalr	-836(ra) # 736 <free>
    stacks[num_threads] = 0;
 a82:	00000717          	auipc	a4,0x0
 a86:	59e72703          	lw	a4,1438(a4) # 1020 <num_threads>
 a8a:	070e                	slli	a4,a4,0x3
 a8c:	00000797          	auipc	a5,0x0
 a90:	58c7b783          	ld	a5,1420(a5) # 1018 <stacks>
 a94:	97ba                	add	a5,a5,a4
 a96:	0007b023          	sd	zero,0(a5)
 a9a:	bf71                	j	a36 <ithread_create+0x8e>

0000000000000a9c <ithread_join>:

int ithread_join(int thread_id) {
 a9c:	1101                	addi	sp,sp,-32
 a9e:	ec06                	sd	ra,24(sp)
 aa0:	e822                	sd	s0,16(sp)
 aa2:	1000                	addi	s0,sp,32
  int status;
  join_thread(thread_id, (uint64)&status);
 aa4:	fec40593          	addi	a1,s0,-20
 aa8:	00000097          	auipc	ra,0x0
 aac:	96e080e7          	jalr	-1682(ra) # 416 <join_thread>
  threads_done++;
 ab0:	00000717          	auipc	a4,0x0
 ab4:	57470713          	addi	a4,a4,1396 # 1024 <threads_done>
 ab8:	431c                	lw	a5,0(a4)
 aba:	2785                	addiw	a5,a5,1
 abc:	0007869b          	sext.w	a3,a5
 ac0:	c31c                	sw	a5,0(a4)
  if (threads_done == num_threads) {
 ac2:	00000797          	auipc	a5,0x0
 ac6:	55e7a783          	lw	a5,1374(a5) # 1020 <num_threads>
 aca:	00d78863          	beq	a5,a3,ada <ithread_join+0x3e>
    free_stacks();
  }
  return status;
}
 ace:	fec42503          	lw	a0,-20(s0)
 ad2:	60e2                	ld	ra,24(sp)
 ad4:	6442                	ld	s0,16(sp)
 ad6:	6105                	addi	sp,sp,32
 ad8:	8082                	ret
    free_stacks();
 ada:	00000097          	auipc	ra,0x0
 ade:	ddc080e7          	jalr	-548(ra) # 8b6 <free_stacks>
 ae2:	b7f5                	j	ace <ithread_join+0x32>
