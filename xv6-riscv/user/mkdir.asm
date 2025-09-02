
user/_mkdir:     file format elf64-littleriscv


Disassembly of section .text:

0000000000000000 <main>:
#include "kernel/stat.h"
#include "user/user.h"

int
main(int argc, char *argv[])
{
   0:	1101                	addi	sp,sp,-32
   2:	ec06                	sd	ra,24(sp)
   4:	e822                	sd	s0,16(sp)
   6:	1000                	addi	s0,sp,32
  int i;

  if(argc < 2){
   8:	4785                	li	a5,1
   a:	02a7dd63          	bge	a5,a0,44 <main+0x44>
   e:	e426                	sd	s1,8(sp)
  10:	e04a                	sd	s2,0(sp)
  12:	00858493          	addi	s1,a1,8
  16:	ffe5091b          	addiw	s2,a0,-2
  1a:	02091793          	slli	a5,s2,0x20
  1e:	01d7d913          	srli	s2,a5,0x1d
  22:	05c1                	addi	a1,a1,16
  24:	992e                	add	s2,s2,a1
    fprintf(2, "Usage: mkdir files...\n");
    exit(1);
  }

  for(i = 1; i < argc; i++){
    if(mkdir(argv[i]) < 0){
  26:	6088                	ld	a0,0(s1)
  28:	00000097          	auipc	ra,0x0
  2c:	374080e7          	jalr	884(ra) # 39c <mkdir>
  30:	02054a63          	bltz	a0,64 <main+0x64>
  for(i = 1; i < argc; i++){
  34:	04a1                	addi	s1,s1,8
  36:	ff2498e3          	bne	s1,s2,26 <main+0x26>
      fprintf(2, "mkdir: %s failed to create\n", argv[i]);
      break;
    }
  }

  exit(0);
  3a:	4501                	li	a0,0
  3c:	00000097          	auipc	ra,0x0
  40:	2f8080e7          	jalr	760(ra) # 334 <exit>
  44:	e426                	sd	s1,8(sp)
  46:	e04a                	sd	s2,0(sp)
    fprintf(2, "Usage: mkdir files...\n");
  48:	00001597          	auipc	a1,0x1
  4c:	ab858593          	addi	a1,a1,-1352 # b00 <ithread_join+0x4c>
  50:	4509                	li	a0,2
  52:	00000097          	auipc	ra,0x0
  56:	678080e7          	jalr	1656(ra) # 6ca <fprintf>
    exit(1);
  5a:	4505                	li	a0,1
  5c:	00000097          	auipc	ra,0x0
  60:	2d8080e7          	jalr	728(ra) # 334 <exit>
      fprintf(2, "mkdir: %s failed to create\n", argv[i]);
  64:	6090                	ld	a2,0(s1)
  66:	00001597          	auipc	a1,0x1
  6a:	ab258593          	addi	a1,a1,-1358 # b18 <ithread_join+0x64>
  6e:	4509                	li	a0,2
  70:	00000097          	auipc	ra,0x0
  74:	65a080e7          	jalr	1626(ra) # 6ca <fprintf>
      break;
  78:	b7c9                	j	3a <main+0x3a>

000000000000007a <_main>:
//
// wrapper so that it's OK if main() does not call exit().
//
void
_main()
{
  7a:	1141                	addi	sp,sp,-16
  7c:	e406                	sd	ra,8(sp)
  7e:	e022                	sd	s0,0(sp)
  80:	0800                	addi	s0,sp,16
  extern int main();
  main();
  82:	00000097          	auipc	ra,0x0
  86:	f7e080e7          	jalr	-130(ra) # 0 <main>
  exit(0);
  8a:	4501                	li	a0,0
  8c:	00000097          	auipc	ra,0x0
  90:	2a8080e7          	jalr	680(ra) # 334 <exit>

0000000000000094 <strcpy>:
}

char*
strcpy(char *s, const char *t)
{
  94:	1141                	addi	sp,sp,-16
  96:	e406                	sd	ra,8(sp)
  98:	e022                	sd	s0,0(sp)
  9a:	0800                	addi	s0,sp,16
  char *os;

  os = s;
  while((*s++ = *t++) != 0)
  9c:	87aa                	mv	a5,a0
  9e:	0585                	addi	a1,a1,1
  a0:	0785                	addi	a5,a5,1
  a2:	fff5c703          	lbu	a4,-1(a1)
  a6:	fee78fa3          	sb	a4,-1(a5)
  aa:	fb75                	bnez	a4,9e <strcpy+0xa>
    ;
  return os;
}
  ac:	60a2                	ld	ra,8(sp)
  ae:	6402                	ld	s0,0(sp)
  b0:	0141                	addi	sp,sp,16
  b2:	8082                	ret

00000000000000b4 <strcmp>:

int
strcmp(const char *p, const char *q)
{
  b4:	1141                	addi	sp,sp,-16
  b6:	e406                	sd	ra,8(sp)
  b8:	e022                	sd	s0,0(sp)
  ba:	0800                	addi	s0,sp,16
  while(*p && *p == *q)
  bc:	00054783          	lbu	a5,0(a0)
  c0:	cb91                	beqz	a5,d4 <strcmp+0x20>
  c2:	0005c703          	lbu	a4,0(a1)
  c6:	00f71763          	bne	a4,a5,d4 <strcmp+0x20>
    p++, q++;
  ca:	0505                	addi	a0,a0,1
  cc:	0585                	addi	a1,a1,1
  while(*p && *p == *q)
  ce:	00054783          	lbu	a5,0(a0)
  d2:	fbe5                	bnez	a5,c2 <strcmp+0xe>
  return (uchar)*p - (uchar)*q;
  d4:	0005c503          	lbu	a0,0(a1)
}
  d8:	40a7853b          	subw	a0,a5,a0
  dc:	60a2                	ld	ra,8(sp)
  de:	6402                	ld	s0,0(sp)
  e0:	0141                	addi	sp,sp,16
  e2:	8082                	ret

00000000000000e4 <strlen>:

uint
strlen(const char *s)
{
  e4:	1141                	addi	sp,sp,-16
  e6:	e406                	sd	ra,8(sp)
  e8:	e022                	sd	s0,0(sp)
  ea:	0800                	addi	s0,sp,16
  int n;

  for(n = 0; s[n]; n++)
  ec:	00054783          	lbu	a5,0(a0)
  f0:	cf99                	beqz	a5,10e <strlen+0x2a>
  f2:	0505                	addi	a0,a0,1
  f4:	87aa                	mv	a5,a0
  f6:	86be                	mv	a3,a5
  f8:	0785                	addi	a5,a5,1
  fa:	fff7c703          	lbu	a4,-1(a5)
  fe:	ff65                	bnez	a4,f6 <strlen+0x12>
 100:	40a6853b          	subw	a0,a3,a0
 104:	2505                	addiw	a0,a0,1
    ;
  return n;
}
 106:	60a2                	ld	ra,8(sp)
 108:	6402                	ld	s0,0(sp)
 10a:	0141                	addi	sp,sp,16
 10c:	8082                	ret
  for(n = 0; s[n]; n++)
 10e:	4501                	li	a0,0
 110:	bfdd                	j	106 <strlen+0x22>

0000000000000112 <memset>:

void*
memset(void *dst, int c, uint n)
{
 112:	1141                	addi	sp,sp,-16
 114:	e406                	sd	ra,8(sp)
 116:	e022                	sd	s0,0(sp)
 118:	0800                	addi	s0,sp,16
  char *cdst = (char *) dst;
  int i;
  for(i = 0; i < n; i++){
 11a:	ca19                	beqz	a2,130 <memset+0x1e>
 11c:	87aa                	mv	a5,a0
 11e:	1602                	slli	a2,a2,0x20
 120:	9201                	srli	a2,a2,0x20
 122:	00a60733          	add	a4,a2,a0
    cdst[i] = c;
 126:	00b78023          	sb	a1,0(a5)
  for(i = 0; i < n; i++){
 12a:	0785                	addi	a5,a5,1
 12c:	fee79de3          	bne	a5,a4,126 <memset+0x14>
  }
  return dst;
}
 130:	60a2                	ld	ra,8(sp)
 132:	6402                	ld	s0,0(sp)
 134:	0141                	addi	sp,sp,16
 136:	8082                	ret

0000000000000138 <strchr>:

char*
strchr(const char *s, char c)
{
 138:	1141                	addi	sp,sp,-16
 13a:	e406                	sd	ra,8(sp)
 13c:	e022                	sd	s0,0(sp)
 13e:	0800                	addi	s0,sp,16
  for(; *s; s++)
 140:	00054783          	lbu	a5,0(a0)
 144:	cf81                	beqz	a5,15c <strchr+0x24>
    if(*s == c)
 146:	00f58763          	beq	a1,a5,154 <strchr+0x1c>
  for(; *s; s++)
 14a:	0505                	addi	a0,a0,1
 14c:	00054783          	lbu	a5,0(a0)
 150:	fbfd                	bnez	a5,146 <strchr+0xe>
      return (char*)s;
  return 0;
 152:	4501                	li	a0,0
}
 154:	60a2                	ld	ra,8(sp)
 156:	6402                	ld	s0,0(sp)
 158:	0141                	addi	sp,sp,16
 15a:	8082                	ret
  return 0;
 15c:	4501                	li	a0,0
 15e:	bfdd                	j	154 <strchr+0x1c>

0000000000000160 <gets>:

char*
gets(char *buf, int max)
{
 160:	7159                	addi	sp,sp,-112
 162:	f486                	sd	ra,104(sp)
 164:	f0a2                	sd	s0,96(sp)
 166:	eca6                	sd	s1,88(sp)
 168:	e8ca                	sd	s2,80(sp)
 16a:	e4ce                	sd	s3,72(sp)
 16c:	e0d2                	sd	s4,64(sp)
 16e:	fc56                	sd	s5,56(sp)
 170:	f85a                	sd	s6,48(sp)
 172:	f45e                	sd	s7,40(sp)
 174:	f062                	sd	s8,32(sp)
 176:	ec66                	sd	s9,24(sp)
 178:	e86a                	sd	s10,16(sp)
 17a:	1880                	addi	s0,sp,112
 17c:	8caa                	mv	s9,a0
 17e:	8a2e                	mv	s4,a1
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 180:	892a                	mv	s2,a0
 182:	4481                	li	s1,0
    cc = read(0, &c, 1);
 184:	f9f40b13          	addi	s6,s0,-97
 188:	4a85                	li	s5,1
    if(cc < 1)
      break;
    buf[i++] = c;
    if(c == '\n' || c == '\r')
 18a:	4ba9                	li	s7,10
 18c:	4c35                	li	s8,13
  for(i=0; i+1 < max; ){
 18e:	8d26                	mv	s10,s1
 190:	0014899b          	addiw	s3,s1,1
 194:	84ce                	mv	s1,s3
 196:	0349d763          	bge	s3,s4,1c4 <gets+0x64>
    cc = read(0, &c, 1);
 19a:	8656                	mv	a2,s5
 19c:	85da                	mv	a1,s6
 19e:	4501                	li	a0,0
 1a0:	00000097          	auipc	ra,0x0
 1a4:	1ac080e7          	jalr	428(ra) # 34c <read>
    if(cc < 1)
 1a8:	00a05e63          	blez	a0,1c4 <gets+0x64>
    buf[i++] = c;
 1ac:	f9f44783          	lbu	a5,-97(s0)
 1b0:	00f90023          	sb	a5,0(s2)
    if(c == '\n' || c == '\r')
 1b4:	01778763          	beq	a5,s7,1c2 <gets+0x62>
 1b8:	0905                	addi	s2,s2,1
 1ba:	fd879ae3          	bne	a5,s8,18e <gets+0x2e>
    buf[i++] = c;
 1be:	8d4e                	mv	s10,s3
 1c0:	a011                	j	1c4 <gets+0x64>
 1c2:	8d4e                	mv	s10,s3
      break;
  }
  buf[i] = '\0';
 1c4:	9d66                	add	s10,s10,s9
 1c6:	000d0023          	sb	zero,0(s10)
  return buf;
}
 1ca:	8566                	mv	a0,s9
 1cc:	70a6                	ld	ra,104(sp)
 1ce:	7406                	ld	s0,96(sp)
 1d0:	64e6                	ld	s1,88(sp)
 1d2:	6946                	ld	s2,80(sp)
 1d4:	69a6                	ld	s3,72(sp)
 1d6:	6a06                	ld	s4,64(sp)
 1d8:	7ae2                	ld	s5,56(sp)
 1da:	7b42                	ld	s6,48(sp)
 1dc:	7ba2                	ld	s7,40(sp)
 1de:	7c02                	ld	s8,32(sp)
 1e0:	6ce2                	ld	s9,24(sp)
 1e2:	6d42                	ld	s10,16(sp)
 1e4:	6165                	addi	sp,sp,112
 1e6:	8082                	ret

00000000000001e8 <stat>:

int
stat(const char *n, struct stat *st)
{
 1e8:	1101                	addi	sp,sp,-32
 1ea:	ec06                	sd	ra,24(sp)
 1ec:	e822                	sd	s0,16(sp)
 1ee:	e04a                	sd	s2,0(sp)
 1f0:	1000                	addi	s0,sp,32
 1f2:	892e                	mv	s2,a1
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 1f4:	4581                	li	a1,0
 1f6:	00000097          	auipc	ra,0x0
 1fa:	17e080e7          	jalr	382(ra) # 374 <open>
  if(fd < 0)
 1fe:	02054663          	bltz	a0,22a <stat+0x42>
 202:	e426                	sd	s1,8(sp)
 204:	84aa                	mv	s1,a0
    return -1;
  r = fstat(fd, st);
 206:	85ca                	mv	a1,s2
 208:	00000097          	auipc	ra,0x0
 20c:	184080e7          	jalr	388(ra) # 38c <fstat>
 210:	892a                	mv	s2,a0
  close(fd);
 212:	8526                	mv	a0,s1
 214:	00000097          	auipc	ra,0x0
 218:	148080e7          	jalr	328(ra) # 35c <close>
  return r;
 21c:	64a2                	ld	s1,8(sp)
}
 21e:	854a                	mv	a0,s2
 220:	60e2                	ld	ra,24(sp)
 222:	6442                	ld	s0,16(sp)
 224:	6902                	ld	s2,0(sp)
 226:	6105                	addi	sp,sp,32
 228:	8082                	ret
    return -1;
 22a:	597d                	li	s2,-1
 22c:	bfcd                	j	21e <stat+0x36>

000000000000022e <atoi>:

int
atoi(const char *s)
{
 22e:	1141                	addi	sp,sp,-16
 230:	e406                	sd	ra,8(sp)
 232:	e022                	sd	s0,0(sp)
 234:	0800                	addi	s0,sp,16
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
 236:	00054683          	lbu	a3,0(a0)
 23a:	fd06879b          	addiw	a5,a3,-48
 23e:	0ff7f793          	zext.b	a5,a5
 242:	4625                	li	a2,9
 244:	02f66963          	bltu	a2,a5,276 <atoi+0x48>
 248:	872a                	mv	a4,a0
  n = 0;
 24a:	4501                	li	a0,0
    n = n*10 + *s++ - '0';
 24c:	0705                	addi	a4,a4,1
 24e:	0025179b          	slliw	a5,a0,0x2
 252:	9fa9                	addw	a5,a5,a0
 254:	0017979b          	slliw	a5,a5,0x1
 258:	9fb5                	addw	a5,a5,a3
 25a:	fd07851b          	addiw	a0,a5,-48
  while('0' <= *s && *s <= '9')
 25e:	00074683          	lbu	a3,0(a4)
 262:	fd06879b          	addiw	a5,a3,-48
 266:	0ff7f793          	zext.b	a5,a5
 26a:	fef671e3          	bgeu	a2,a5,24c <atoi+0x1e>
  return n;
}
 26e:	60a2                	ld	ra,8(sp)
 270:	6402                	ld	s0,0(sp)
 272:	0141                	addi	sp,sp,16
 274:	8082                	ret
  n = 0;
 276:	4501                	li	a0,0
 278:	bfdd                	j	26e <atoi+0x40>

000000000000027a <memmove>:

void*
memmove(void *vdst, const void *vsrc, int n)
{
 27a:	1141                	addi	sp,sp,-16
 27c:	e406                	sd	ra,8(sp)
 27e:	e022                	sd	s0,0(sp)
 280:	0800                	addi	s0,sp,16
  char *dst;
  const char *src;

  dst = vdst;
  src = vsrc;
  if (src > dst) {
 282:	02b57563          	bgeu	a0,a1,2ac <memmove+0x32>
    while(n-- > 0)
 286:	00c05f63          	blez	a2,2a4 <memmove+0x2a>
 28a:	1602                	slli	a2,a2,0x20
 28c:	9201                	srli	a2,a2,0x20
 28e:	00c507b3          	add	a5,a0,a2
  dst = vdst;
 292:	872a                	mv	a4,a0
      *dst++ = *src++;
 294:	0585                	addi	a1,a1,1
 296:	0705                	addi	a4,a4,1
 298:	fff5c683          	lbu	a3,-1(a1)
 29c:	fed70fa3          	sb	a3,-1(a4)
    while(n-- > 0)
 2a0:	fee79ae3          	bne	a5,a4,294 <memmove+0x1a>
    src += n;
    while(n-- > 0)
      *--dst = *--src;
  }
  return vdst;
}
 2a4:	60a2                	ld	ra,8(sp)
 2a6:	6402                	ld	s0,0(sp)
 2a8:	0141                	addi	sp,sp,16
 2aa:	8082                	ret
    dst += n;
 2ac:	00c50733          	add	a4,a0,a2
    src += n;
 2b0:	95b2                	add	a1,a1,a2
    while(n-- > 0)
 2b2:	fec059e3          	blez	a2,2a4 <memmove+0x2a>
 2b6:	fff6079b          	addiw	a5,a2,-1
 2ba:	1782                	slli	a5,a5,0x20
 2bc:	9381                	srli	a5,a5,0x20
 2be:	fff7c793          	not	a5,a5
 2c2:	97ba                	add	a5,a5,a4
      *--dst = *--src;
 2c4:	15fd                	addi	a1,a1,-1
 2c6:	177d                	addi	a4,a4,-1
 2c8:	0005c683          	lbu	a3,0(a1)
 2cc:	00d70023          	sb	a3,0(a4)
    while(n-- > 0)
 2d0:	fef71ae3          	bne	a4,a5,2c4 <memmove+0x4a>
 2d4:	bfc1                	j	2a4 <memmove+0x2a>

00000000000002d6 <memcmp>:

int
memcmp(const void *s1, const void *s2, uint n)
{
 2d6:	1141                	addi	sp,sp,-16
 2d8:	e406                	sd	ra,8(sp)
 2da:	e022                	sd	s0,0(sp)
 2dc:	0800                	addi	s0,sp,16
  const char *p1 = s1, *p2 = s2;
  while (n-- > 0) {
 2de:	ca0d                	beqz	a2,310 <memcmp+0x3a>
 2e0:	fff6069b          	addiw	a3,a2,-1
 2e4:	1682                	slli	a3,a3,0x20
 2e6:	9281                	srli	a3,a3,0x20
 2e8:	0685                	addi	a3,a3,1
 2ea:	96aa                	add	a3,a3,a0
    if (*p1 != *p2) {
 2ec:	00054783          	lbu	a5,0(a0)
 2f0:	0005c703          	lbu	a4,0(a1)
 2f4:	00e79863          	bne	a5,a4,304 <memcmp+0x2e>
      return *p1 - *p2;
    }
    p1++;
 2f8:	0505                	addi	a0,a0,1
    p2++;
 2fa:	0585                	addi	a1,a1,1
  while (n-- > 0) {
 2fc:	fed518e3          	bne	a0,a3,2ec <memcmp+0x16>
  }
  return 0;
 300:	4501                	li	a0,0
 302:	a019                	j	308 <memcmp+0x32>
      return *p1 - *p2;
 304:	40e7853b          	subw	a0,a5,a4
}
 308:	60a2                	ld	ra,8(sp)
 30a:	6402                	ld	s0,0(sp)
 30c:	0141                	addi	sp,sp,16
 30e:	8082                	ret
  return 0;
 310:	4501                	li	a0,0
 312:	bfdd                	j	308 <memcmp+0x32>

0000000000000314 <memcpy>:

void *
memcpy(void *dst, const void *src, uint n)
{
 314:	1141                	addi	sp,sp,-16
 316:	e406                	sd	ra,8(sp)
 318:	e022                	sd	s0,0(sp)
 31a:	0800                	addi	s0,sp,16
  return memmove(dst, src, n);
 31c:	00000097          	auipc	ra,0x0
 320:	f5e080e7          	jalr	-162(ra) # 27a <memmove>
}
 324:	60a2                	ld	ra,8(sp)
 326:	6402                	ld	s0,0(sp)
 328:	0141                	addi	sp,sp,16
 32a:	8082                	ret

000000000000032c <fork>:
# generated by usys.pl - do not edit
#include "kernel/syscall.h"
.global fork
fork:
 li a7, SYS_fork
 32c:	4885                	li	a7,1
 ecall
 32e:	00000073          	ecall
 ret
 332:	8082                	ret

0000000000000334 <exit>:
.global exit
exit:
 li a7, SYS_exit
 334:	4889                	li	a7,2
 ecall
 336:	00000073          	ecall
 ret
 33a:	8082                	ret

000000000000033c <wait>:
.global wait
wait:
 li a7, SYS_wait
 33c:	488d                	li	a7,3
 ecall
 33e:	00000073          	ecall
 ret
 342:	8082                	ret

0000000000000344 <pipe>:
.global pipe
pipe:
 li a7, SYS_pipe
 344:	4891                	li	a7,4
 ecall
 346:	00000073          	ecall
 ret
 34a:	8082                	ret

000000000000034c <read>:
.global read
read:
 li a7, SYS_read
 34c:	4895                	li	a7,5
 ecall
 34e:	00000073          	ecall
 ret
 352:	8082                	ret

0000000000000354 <write>:
.global write
write:
 li a7, SYS_write
 354:	48c1                	li	a7,16
 ecall
 356:	00000073          	ecall
 ret
 35a:	8082                	ret

000000000000035c <close>:
.global close
close:
 li a7, SYS_close
 35c:	48d5                	li	a7,21
 ecall
 35e:	00000073          	ecall
 ret
 362:	8082                	ret

0000000000000364 <kill>:
.global kill
kill:
 li a7, SYS_kill
 364:	4899                	li	a7,6
 ecall
 366:	00000073          	ecall
 ret
 36a:	8082                	ret

000000000000036c <exec>:
.global exec
exec:
 li a7, SYS_exec
 36c:	489d                	li	a7,7
 ecall
 36e:	00000073          	ecall
 ret
 372:	8082                	ret

0000000000000374 <open>:
.global open
open:
 li a7, SYS_open
 374:	48bd                	li	a7,15
 ecall
 376:	00000073          	ecall
 ret
 37a:	8082                	ret

000000000000037c <mknod>:
.global mknod
mknod:
 li a7, SYS_mknod
 37c:	48c5                	li	a7,17
 ecall
 37e:	00000073          	ecall
 ret
 382:	8082                	ret

0000000000000384 <unlink>:
.global unlink
unlink:
 li a7, SYS_unlink
 384:	48c9                	li	a7,18
 ecall
 386:	00000073          	ecall
 ret
 38a:	8082                	ret

000000000000038c <fstat>:
.global fstat
fstat:
 li a7, SYS_fstat
 38c:	48a1                	li	a7,8
 ecall
 38e:	00000073          	ecall
 ret
 392:	8082                	ret

0000000000000394 <link>:
.global link
link:
 li a7, SYS_link
 394:	48cd                	li	a7,19
 ecall
 396:	00000073          	ecall
 ret
 39a:	8082                	ret

000000000000039c <mkdir>:
.global mkdir
mkdir:
 li a7, SYS_mkdir
 39c:	48d1                	li	a7,20
 ecall
 39e:	00000073          	ecall
 ret
 3a2:	8082                	ret

00000000000003a4 <chdir>:
.global chdir
chdir:
 li a7, SYS_chdir
 3a4:	48a5                	li	a7,9
 ecall
 3a6:	00000073          	ecall
 ret
 3aa:	8082                	ret

00000000000003ac <dup>:
.global dup
dup:
 li a7, SYS_dup
 3ac:	48a9                	li	a7,10
 ecall
 3ae:	00000073          	ecall
 ret
 3b2:	8082                	ret

00000000000003b4 <getpid>:
.global getpid
getpid:
 li a7, SYS_getpid
 3b4:	48ad                	li	a7,11
 ecall
 3b6:	00000073          	ecall
 ret
 3ba:	8082                	ret

00000000000003bc <sbrk>:
.global sbrk
sbrk:
 li a7, SYS_sbrk
 3bc:	48b1                	li	a7,12
 ecall
 3be:	00000073          	ecall
 ret
 3c2:	8082                	ret

00000000000003c4 <sleep>:
.global sleep
sleep:
 li a7, SYS_sleep
 3c4:	48b5                	li	a7,13
 ecall
 3c6:	00000073          	ecall
 ret
 3ca:	8082                	ret

00000000000003cc <uptime>:
.global uptime
uptime:
 li a7, SYS_uptime
 3cc:	48b9                	li	a7,14
 ecall
 3ce:	00000073          	ecall
 ret
 3d2:	8082                	ret

00000000000003d4 <spoon>:
.global spoon
spoon:
 li a7, SYS_spoon
 3d4:	48d9                	li	a7,22
 ecall
 3d6:	00000073          	ecall
 ret
 3da:	8082                	ret

00000000000003dc <create_thread>:
.global create_thread
create_thread:
 li a7, SYS_create_thread
 3dc:	48dd                	li	a7,23
 ecall
 3de:	00000073          	ecall
 ret
 3e2:	8082                	ret

00000000000003e4 <join_thread>:
.global join_thread
join_thread:
 li a7, SYS_join_thread
 3e4:	48e1                	li	a7,24
 ecall
 3e6:	00000073          	ecall
 ret
 3ea:	8082                	ret

00000000000003ec <thread_exit>:
.global thread_exit
thread_exit:
 li a7, SYS_thread_exit
 3ec:	48e5                	li	a7,25
 ecall
 3ee:	00000073          	ecall
 ret
 3f2:	8082                	ret

00000000000003f4 <socket>:
.global socket
socket:
 li a7, SYS_socket
 3f4:	48e9                	li	a7,26
 ecall
 3f6:	00000073          	ecall
 ret
 3fa:	8082                	ret

00000000000003fc <bind>:
.global bind
bind:
 li a7, SYS_bind
 3fc:	48ed                	li	a7,27
 ecall
 3fe:	00000073          	ecall
 ret
 402:	8082                	ret

0000000000000404 <accept>:
.global accept
accept:
 li a7, SYS_accept
 404:	48f5                	li	a7,29
 ecall
 406:	00000073          	ecall
 ret
 40a:	8082                	ret

000000000000040c <listen>:
.global listen
listen:
 li a7, SYS_listen
 40c:	48f1                	li	a7,28
 ecall
 40e:	00000073          	ecall
 ret
 412:	8082                	ret

0000000000000414 <connect>:
.global connect
connect:
 li a7, SYS_connect
 414:	48f9                	li	a7,30
 ecall
 416:	00000073          	ecall
 ret
 41a:	8082                	ret

000000000000041c <send>:
.global send
send:
 li a7, SYS_send
 41c:	48fd                	li	a7,31
 ecall
 41e:	00000073          	ecall
 ret
 422:	8082                	ret

0000000000000424 <recv>:
.global recv
recv:
 li a7, SYS_recv
 424:	02000893          	li	a7,32
 ecall
 428:	00000073          	ecall
 ret
 42c:	8082                	ret

000000000000042e <sendto>:
.global sendto
sendto:
 li a7, SYS_sendto
 42e:	02100893          	li	a7,33
 ecall
 432:	00000073          	ecall
 ret
 436:	8082                	ret

0000000000000438 <recvfrom>:
.global recvfrom
recvfrom:
 li a7, SYS_recvfrom
 438:	02200893          	li	a7,34
 ecall
 43c:	00000073          	ecall
 ret
 440:	8082                	ret

0000000000000442 <putc>:

static char digits[] = "0123456789ABCDEF";

static void
putc(int fd, char c)
{
 442:	1101                	addi	sp,sp,-32
 444:	ec06                	sd	ra,24(sp)
 446:	e822                	sd	s0,16(sp)
 448:	1000                	addi	s0,sp,32
 44a:	feb407a3          	sb	a1,-17(s0)
  write(fd, &c, 1);
 44e:	4605                	li	a2,1
 450:	fef40593          	addi	a1,s0,-17
 454:	00000097          	auipc	ra,0x0
 458:	f00080e7          	jalr	-256(ra) # 354 <write>
}
 45c:	60e2                	ld	ra,24(sp)
 45e:	6442                	ld	s0,16(sp)
 460:	6105                	addi	sp,sp,32
 462:	8082                	ret

0000000000000464 <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
 464:	7139                	addi	sp,sp,-64
 466:	fc06                	sd	ra,56(sp)
 468:	f822                	sd	s0,48(sp)
 46a:	f426                	sd	s1,40(sp)
 46c:	f04a                	sd	s2,32(sp)
 46e:	ec4e                	sd	s3,24(sp)
 470:	0080                	addi	s0,sp,64
 472:	892a                	mv	s2,a0
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
  if(sgn && xx < 0){
 474:	c299                	beqz	a3,47a <printint+0x16>
 476:	0805c063          	bltz	a1,4f6 <printint+0x92>
  neg = 0;
 47a:	4e01                	li	t3,0
    x = -xx;
  } else {
    x = xx;
  }

  i = 0;
 47c:	fc040313          	addi	t1,s0,-64
  neg = 0;
 480:	869a                	mv	a3,t1
  i = 0;
 482:	4781                	li	a5,0
  do{
    buf[i++] = digits[x % base];
 484:	00000817          	auipc	a6,0x0
 488:	74480813          	addi	a6,a6,1860 # bc8 <digits>
 48c:	88be                	mv	a7,a5
 48e:	0017851b          	addiw	a0,a5,1
 492:	87aa                	mv	a5,a0
 494:	02c5f73b          	remuw	a4,a1,a2
 498:	1702                	slli	a4,a4,0x20
 49a:	9301                	srli	a4,a4,0x20
 49c:	9742                	add	a4,a4,a6
 49e:	00074703          	lbu	a4,0(a4)
 4a2:	00e68023          	sb	a4,0(a3)
  }while((x /= base) != 0);
 4a6:	872e                	mv	a4,a1
 4a8:	02c5d5bb          	divuw	a1,a1,a2
 4ac:	0685                	addi	a3,a3,1
 4ae:	fcc77fe3          	bgeu	a4,a2,48c <printint+0x28>
  if(neg)
 4b2:	000e0c63          	beqz	t3,4ca <printint+0x66>
    buf[i++] = '-';
 4b6:	fd050793          	addi	a5,a0,-48
 4ba:	00878533          	add	a0,a5,s0
 4be:	02d00793          	li	a5,45
 4c2:	fef50823          	sb	a5,-16(a0)
 4c6:	0028879b          	addiw	a5,a7,2

  while(--i >= 0)
 4ca:	fff7899b          	addiw	s3,a5,-1
 4ce:	006784b3          	add	s1,a5,t1
    putc(fd, buf[i]);
 4d2:	fff4c583          	lbu	a1,-1(s1)
 4d6:	854a                	mv	a0,s2
 4d8:	00000097          	auipc	ra,0x0
 4dc:	f6a080e7          	jalr	-150(ra) # 442 <putc>
  while(--i >= 0)
 4e0:	39fd                	addiw	s3,s3,-1
 4e2:	14fd                	addi	s1,s1,-1
 4e4:	fe09d7e3          	bgez	s3,4d2 <printint+0x6e>
}
 4e8:	70e2                	ld	ra,56(sp)
 4ea:	7442                	ld	s0,48(sp)
 4ec:	74a2                	ld	s1,40(sp)
 4ee:	7902                	ld	s2,32(sp)
 4f0:	69e2                	ld	s3,24(sp)
 4f2:	6121                	addi	sp,sp,64
 4f4:	8082                	ret
    x = -xx;
 4f6:	40b005bb          	negw	a1,a1
    neg = 1;
 4fa:	4e05                	li	t3,1
    x = -xx;
 4fc:	b741                	j	47c <printint+0x18>

00000000000004fe <vprintf>:
}

// Print to the given fd. Only understands %d, %x, %p, %s.
void
vprintf(int fd, const char *fmt, va_list ap)
{
 4fe:	715d                	addi	sp,sp,-80
 500:	e486                	sd	ra,72(sp)
 502:	e0a2                	sd	s0,64(sp)
 504:	f84a                	sd	s2,48(sp)
 506:	0880                	addi	s0,sp,80
  char *s;
  int c, i, state;

  state = 0;
  for(i = 0; fmt[i]; i++){
 508:	0005c903          	lbu	s2,0(a1)
 50c:	1a090a63          	beqz	s2,6c0 <vprintf+0x1c2>
 510:	fc26                	sd	s1,56(sp)
 512:	f44e                	sd	s3,40(sp)
 514:	f052                	sd	s4,32(sp)
 516:	ec56                	sd	s5,24(sp)
 518:	e85a                	sd	s6,16(sp)
 51a:	e45e                	sd	s7,8(sp)
 51c:	8aaa                	mv	s5,a0
 51e:	8bb2                	mv	s7,a2
 520:	00158493          	addi	s1,a1,1
  state = 0;
 524:	4981                	li	s3,0
      if(c == '%'){
        state = '%';
      } else {
        putc(fd, c);
      }
    } else if(state == '%'){
 526:	02500a13          	li	s4,37
 52a:	4b55                	li	s6,21
 52c:	a839                	j	54a <vprintf+0x4c>
        putc(fd, c);
 52e:	85ca                	mv	a1,s2
 530:	8556                	mv	a0,s5
 532:	00000097          	auipc	ra,0x0
 536:	f10080e7          	jalr	-240(ra) # 442 <putc>
 53a:	a019                	j	540 <vprintf+0x42>
    } else if(state == '%'){
 53c:	01498d63          	beq	s3,s4,556 <vprintf+0x58>
  for(i = 0; fmt[i]; i++){
 540:	0485                	addi	s1,s1,1
 542:	fff4c903          	lbu	s2,-1(s1)
 546:	16090763          	beqz	s2,6b4 <vprintf+0x1b6>
    if(state == 0){
 54a:	fe0999e3          	bnez	s3,53c <vprintf+0x3e>
      if(c == '%'){
 54e:	ff4910e3          	bne	s2,s4,52e <vprintf+0x30>
        state = '%';
 552:	89d2                	mv	s3,s4
 554:	b7f5                	j	540 <vprintf+0x42>
      if(c == 'd'){
 556:	13490463          	beq	s2,s4,67e <vprintf+0x180>
 55a:	f9d9079b          	addiw	a5,s2,-99
 55e:	0ff7f793          	zext.b	a5,a5
 562:	12fb6763          	bltu	s6,a5,690 <vprintf+0x192>
 566:	f9d9079b          	addiw	a5,s2,-99
 56a:	0ff7f713          	zext.b	a4,a5
 56e:	12eb6163          	bltu	s6,a4,690 <vprintf+0x192>
 572:	00271793          	slli	a5,a4,0x2
 576:	00000717          	auipc	a4,0x0
 57a:	5fa70713          	addi	a4,a4,1530 # b70 <ithread_join+0xbc>
 57e:	97ba                	add	a5,a5,a4
 580:	439c                	lw	a5,0(a5)
 582:	97ba                	add	a5,a5,a4
 584:	8782                	jr	a5
        printint(fd, va_arg(ap, int), 10, 1);
 586:	008b8913          	addi	s2,s7,8
 58a:	4685                	li	a3,1
 58c:	4629                	li	a2,10
 58e:	000ba583          	lw	a1,0(s7)
 592:	8556                	mv	a0,s5
 594:	00000097          	auipc	ra,0x0
 598:	ed0080e7          	jalr	-304(ra) # 464 <printint>
 59c:	8bca                	mv	s7,s2
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
        putc(fd, c);
      }
      state = 0;
 59e:	4981                	li	s3,0
 5a0:	b745                	j	540 <vprintf+0x42>
        printint(fd, va_arg(ap, uint64), 10, 0);
 5a2:	008b8913          	addi	s2,s7,8
 5a6:	4681                	li	a3,0
 5a8:	4629                	li	a2,10
 5aa:	000ba583          	lw	a1,0(s7)
 5ae:	8556                	mv	a0,s5
 5b0:	00000097          	auipc	ra,0x0
 5b4:	eb4080e7          	jalr	-332(ra) # 464 <printint>
 5b8:	8bca                	mv	s7,s2
      state = 0;
 5ba:	4981                	li	s3,0
 5bc:	b751                	j	540 <vprintf+0x42>
        printint(fd, va_arg(ap, int), 16, 0);
 5be:	008b8913          	addi	s2,s7,8
 5c2:	4681                	li	a3,0
 5c4:	4641                	li	a2,16
 5c6:	000ba583          	lw	a1,0(s7)
 5ca:	8556                	mv	a0,s5
 5cc:	00000097          	auipc	ra,0x0
 5d0:	e98080e7          	jalr	-360(ra) # 464 <printint>
 5d4:	8bca                	mv	s7,s2
      state = 0;
 5d6:	4981                	li	s3,0
 5d8:	b7a5                	j	540 <vprintf+0x42>
 5da:	e062                	sd	s8,0(sp)
        printptr(fd, va_arg(ap, uint64));
 5dc:	008b8c13          	addi	s8,s7,8
 5e0:	000bb983          	ld	s3,0(s7)
  putc(fd, '0');
 5e4:	03000593          	li	a1,48
 5e8:	8556                	mv	a0,s5
 5ea:	00000097          	auipc	ra,0x0
 5ee:	e58080e7          	jalr	-424(ra) # 442 <putc>
  putc(fd, 'x');
 5f2:	07800593          	li	a1,120
 5f6:	8556                	mv	a0,s5
 5f8:	00000097          	auipc	ra,0x0
 5fc:	e4a080e7          	jalr	-438(ra) # 442 <putc>
 600:	4941                	li	s2,16
    putc(fd, digits[x >> (sizeof(uint64) * 8 - 4)]);
 602:	00000b97          	auipc	s7,0x0
 606:	5c6b8b93          	addi	s7,s7,1478 # bc8 <digits>
 60a:	03c9d793          	srli	a5,s3,0x3c
 60e:	97de                	add	a5,a5,s7
 610:	0007c583          	lbu	a1,0(a5)
 614:	8556                	mv	a0,s5
 616:	00000097          	auipc	ra,0x0
 61a:	e2c080e7          	jalr	-468(ra) # 442 <putc>
  for (i = 0; i < (sizeof(uint64) * 2); i++, x <<= 4)
 61e:	0992                	slli	s3,s3,0x4
 620:	397d                	addiw	s2,s2,-1
 622:	fe0914e3          	bnez	s2,60a <vprintf+0x10c>
        printptr(fd, va_arg(ap, uint64));
 626:	8be2                	mv	s7,s8
      state = 0;
 628:	4981                	li	s3,0
 62a:	6c02                	ld	s8,0(sp)
 62c:	bf11                	j	540 <vprintf+0x42>
        s = va_arg(ap, char*);
 62e:	008b8993          	addi	s3,s7,8
 632:	000bb903          	ld	s2,0(s7)
        if(s == 0)
 636:	02090163          	beqz	s2,658 <vprintf+0x15a>
        while(*s != 0){
 63a:	00094583          	lbu	a1,0(s2)
 63e:	c9a5                	beqz	a1,6ae <vprintf+0x1b0>
          putc(fd, *s);
 640:	8556                	mv	a0,s5
 642:	00000097          	auipc	ra,0x0
 646:	e00080e7          	jalr	-512(ra) # 442 <putc>
          s++;
 64a:	0905                	addi	s2,s2,1
        while(*s != 0){
 64c:	00094583          	lbu	a1,0(s2)
 650:	f9e5                	bnez	a1,640 <vprintf+0x142>
        s = va_arg(ap, char*);
 652:	8bce                	mv	s7,s3
      state = 0;
 654:	4981                	li	s3,0
 656:	b5ed                	j	540 <vprintf+0x42>
          s = "(null)";
 658:	00000917          	auipc	s2,0x0
 65c:	4e090913          	addi	s2,s2,1248 # b38 <ithread_join+0x84>
        while(*s != 0){
 660:	02800593          	li	a1,40
 664:	bff1                	j	640 <vprintf+0x142>
        putc(fd, va_arg(ap, uint));
 666:	008b8913          	addi	s2,s7,8
 66a:	000bc583          	lbu	a1,0(s7)
 66e:	8556                	mv	a0,s5
 670:	00000097          	auipc	ra,0x0
 674:	dd2080e7          	jalr	-558(ra) # 442 <putc>
 678:	8bca                	mv	s7,s2
      state = 0;
 67a:	4981                	li	s3,0
 67c:	b5d1                	j	540 <vprintf+0x42>
        putc(fd, c);
 67e:	02500593          	li	a1,37
 682:	8556                	mv	a0,s5
 684:	00000097          	auipc	ra,0x0
 688:	dbe080e7          	jalr	-578(ra) # 442 <putc>
      state = 0;
 68c:	4981                	li	s3,0
 68e:	bd4d                	j	540 <vprintf+0x42>
        putc(fd, '%');
 690:	02500593          	li	a1,37
 694:	8556                	mv	a0,s5
 696:	00000097          	auipc	ra,0x0
 69a:	dac080e7          	jalr	-596(ra) # 442 <putc>
        putc(fd, c);
 69e:	85ca                	mv	a1,s2
 6a0:	8556                	mv	a0,s5
 6a2:	00000097          	auipc	ra,0x0
 6a6:	da0080e7          	jalr	-608(ra) # 442 <putc>
      state = 0;
 6aa:	4981                	li	s3,0
 6ac:	bd51                	j	540 <vprintf+0x42>
        s = va_arg(ap, char*);
 6ae:	8bce                	mv	s7,s3
      state = 0;
 6b0:	4981                	li	s3,0
 6b2:	b579                	j	540 <vprintf+0x42>
 6b4:	74e2                	ld	s1,56(sp)
 6b6:	79a2                	ld	s3,40(sp)
 6b8:	7a02                	ld	s4,32(sp)
 6ba:	6ae2                	ld	s5,24(sp)
 6bc:	6b42                	ld	s6,16(sp)
 6be:	6ba2                	ld	s7,8(sp)
    }
  }
}
 6c0:	60a6                	ld	ra,72(sp)
 6c2:	6406                	ld	s0,64(sp)
 6c4:	7942                	ld	s2,48(sp)
 6c6:	6161                	addi	sp,sp,80
 6c8:	8082                	ret

00000000000006ca <fprintf>:

void
fprintf(int fd, const char *fmt, ...)
{
 6ca:	715d                	addi	sp,sp,-80
 6cc:	ec06                	sd	ra,24(sp)
 6ce:	e822                	sd	s0,16(sp)
 6d0:	1000                	addi	s0,sp,32
 6d2:	e010                	sd	a2,0(s0)
 6d4:	e414                	sd	a3,8(s0)
 6d6:	e818                	sd	a4,16(s0)
 6d8:	ec1c                	sd	a5,24(s0)
 6da:	03043023          	sd	a6,32(s0)
 6de:	03143423          	sd	a7,40(s0)
  va_list ap;

  va_start(ap, fmt);
 6e2:	8622                	mv	a2,s0
 6e4:	fe843423          	sd	s0,-24(s0)
  vprintf(fd, fmt, ap);
 6e8:	00000097          	auipc	ra,0x0
 6ec:	e16080e7          	jalr	-490(ra) # 4fe <vprintf>
}
 6f0:	60e2                	ld	ra,24(sp)
 6f2:	6442                	ld	s0,16(sp)
 6f4:	6161                	addi	sp,sp,80
 6f6:	8082                	ret

00000000000006f8 <printf>:

void
printf(const char *fmt, ...)
{
 6f8:	711d                	addi	sp,sp,-96
 6fa:	ec06                	sd	ra,24(sp)
 6fc:	e822                	sd	s0,16(sp)
 6fe:	1000                	addi	s0,sp,32
 700:	e40c                	sd	a1,8(s0)
 702:	e810                	sd	a2,16(s0)
 704:	ec14                	sd	a3,24(s0)
 706:	f018                	sd	a4,32(s0)
 708:	f41c                	sd	a5,40(s0)
 70a:	03043823          	sd	a6,48(s0)
 70e:	03143c23          	sd	a7,56(s0)
  va_list ap;

  va_start(ap, fmt);
 712:	00840613          	addi	a2,s0,8
 716:	fec43423          	sd	a2,-24(s0)
  vprintf(1, fmt, ap);
 71a:	85aa                	mv	a1,a0
 71c:	4505                	li	a0,1
 71e:	00000097          	auipc	ra,0x0
 722:	de0080e7          	jalr	-544(ra) # 4fe <vprintf>
}
 726:	60e2                	ld	ra,24(sp)
 728:	6442                	ld	s0,16(sp)
 72a:	6125                	addi	sp,sp,96
 72c:	8082                	ret

000000000000072e <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 72e:	1141                	addi	sp,sp,-16
 730:	e406                	sd	ra,8(sp)
 732:	e022                	sd	s0,0(sp)
 734:	0800                	addi	s0,sp,16
  Header *bp, *p;

  bp = (Header*)ap - 1;
 736:	ff050693          	addi	a3,a0,-16
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 73a:	00001797          	auipc	a5,0x1
 73e:	dd67b783          	ld	a5,-554(a5) # 1510 <freep>
 742:	a02d                	j	76c <free+0x3e>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
      break;
  if(bp + bp->s.size == p->s.ptr){
    bp->s.size += p->s.ptr->s.size;
 744:	4618                	lw	a4,8(a2)
 746:	9f2d                	addw	a4,a4,a1
 748:	fee52c23          	sw	a4,-8(a0)
    bp->s.ptr = p->s.ptr->s.ptr;
 74c:	6398                	ld	a4,0(a5)
 74e:	6310                	ld	a2,0(a4)
 750:	a83d                	j	78e <free+0x60>
  } else
    bp->s.ptr = p->s.ptr;
  if(p + p->s.size == bp){
    p->s.size += bp->s.size;
 752:	ff852703          	lw	a4,-8(a0)
 756:	9f31                	addw	a4,a4,a2
 758:	c798                	sw	a4,8(a5)
    p->s.ptr = bp->s.ptr;
 75a:	ff053683          	ld	a3,-16(a0)
 75e:	a091                	j	7a2 <free+0x74>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 760:	6398                	ld	a4,0(a5)
 762:	00e7e463          	bltu	a5,a4,76a <free+0x3c>
 766:	00e6ea63          	bltu	a3,a4,77a <free+0x4c>
{
 76a:	87ba                	mv	a5,a4
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 76c:	fed7fae3          	bgeu	a5,a3,760 <free+0x32>
 770:	6398                	ld	a4,0(a5)
 772:	00e6e463          	bltu	a3,a4,77a <free+0x4c>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 776:	fee7eae3          	bltu	a5,a4,76a <free+0x3c>
  if(bp + bp->s.size == p->s.ptr){
 77a:	ff852583          	lw	a1,-8(a0)
 77e:	6390                	ld	a2,0(a5)
 780:	02059813          	slli	a6,a1,0x20
 784:	01c85713          	srli	a4,a6,0x1c
 788:	9736                	add	a4,a4,a3
 78a:	fae60de3          	beq	a2,a4,744 <free+0x16>
    bp->s.ptr = p->s.ptr->s.ptr;
 78e:	fec53823          	sd	a2,-16(a0)
  if(p + p->s.size == bp){
 792:	4790                	lw	a2,8(a5)
 794:	02061593          	slli	a1,a2,0x20
 798:	01c5d713          	srli	a4,a1,0x1c
 79c:	973e                	add	a4,a4,a5
 79e:	fae68ae3          	beq	a3,a4,752 <free+0x24>
    p->s.ptr = bp->s.ptr;
 7a2:	e394                	sd	a3,0(a5)
  } else
    p->s.ptr = bp;
  freep = p;
 7a4:	00001717          	auipc	a4,0x1
 7a8:	d6f73623          	sd	a5,-660(a4) # 1510 <freep>
}
 7ac:	60a2                	ld	ra,8(sp)
 7ae:	6402                	ld	s0,0(sp)
 7b0:	0141                	addi	sp,sp,16
 7b2:	8082                	ret

00000000000007b4 <malloc>:
  return freep;
}

void*
malloc(uint nbytes)
{
 7b4:	7139                	addi	sp,sp,-64
 7b6:	fc06                	sd	ra,56(sp)
 7b8:	f822                	sd	s0,48(sp)
 7ba:	f04a                	sd	s2,32(sp)
 7bc:	ec4e                	sd	s3,24(sp)
 7be:	0080                	addi	s0,sp,64
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 7c0:	02051993          	slli	s3,a0,0x20
 7c4:	0209d993          	srli	s3,s3,0x20
 7c8:	09bd                	addi	s3,s3,15
 7ca:	0049d993          	srli	s3,s3,0x4
 7ce:	2985                	addiw	s3,s3,1
 7d0:	894e                	mv	s2,s3
  if((prevp = freep) == 0){
 7d2:	00001517          	auipc	a0,0x1
 7d6:	d3e53503          	ld	a0,-706(a0) # 1510 <freep>
 7da:	c905                	beqz	a0,80a <malloc+0x56>
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 7dc:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
 7de:	4798                	lw	a4,8(a5)
 7e0:	09377a63          	bgeu	a4,s3,874 <malloc+0xc0>
 7e4:	f426                	sd	s1,40(sp)
 7e6:	e852                	sd	s4,16(sp)
 7e8:	e456                	sd	s5,8(sp)
 7ea:	e05a                	sd	s6,0(sp)
  if(nu < 4096)
 7ec:	8a4e                	mv	s4,s3
 7ee:	6705                	lui	a4,0x1
 7f0:	00e9f363          	bgeu	s3,a4,7f6 <malloc+0x42>
 7f4:	6a05                	lui	s4,0x1
 7f6:	000a0b1b          	sext.w	s6,s4
  p = sbrk(nu * sizeof(Header));
 7fa:	004a1a1b          	slliw	s4,s4,0x4
        p->s.size = nunits;
      }
      freep = prevp;
      return (void*)(p + 1);
    }
    if(p == freep)
 7fe:	00001497          	auipc	s1,0x1
 802:	d1248493          	addi	s1,s1,-750 # 1510 <freep>
  if(p == (char*)-1)
 806:	5afd                	li	s5,-1
 808:	a089                	j	84a <malloc+0x96>
 80a:	f426                	sd	s1,40(sp)
 80c:	e852                	sd	s4,16(sp)
 80e:	e456                	sd	s5,8(sp)
 810:	e05a                	sd	s6,0(sp)
    base.s.ptr = freep = prevp = &base;
 812:	00001797          	auipc	a5,0x1
 816:	d1e78793          	addi	a5,a5,-738 # 1530 <base>
 81a:	00001717          	auipc	a4,0x1
 81e:	cef73b23          	sd	a5,-778(a4) # 1510 <freep>
 822:	e39c                	sd	a5,0(a5)
    base.s.size = 0;
 824:	0007a423          	sw	zero,8(a5)
    if(p->s.size >= nunits){
 828:	b7d1                	j	7ec <malloc+0x38>
        prevp->s.ptr = p->s.ptr;
 82a:	6398                	ld	a4,0(a5)
 82c:	e118                	sd	a4,0(a0)
 82e:	a8b9                	j	88c <malloc+0xd8>
  hp->s.size = nu;
 830:	01652423          	sw	s6,8(a0)
  free((void*)(hp + 1));
 834:	0541                	addi	a0,a0,16
 836:	00000097          	auipc	ra,0x0
 83a:	ef8080e7          	jalr	-264(ra) # 72e <free>
  return freep;
 83e:	6088                	ld	a0,0(s1)
      if((p = morecore(nunits)) == 0)
 840:	c135                	beqz	a0,8a4 <malloc+0xf0>
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 842:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
 844:	4798                	lw	a4,8(a5)
 846:	03277363          	bgeu	a4,s2,86c <malloc+0xb8>
    if(p == freep)
 84a:	6098                	ld	a4,0(s1)
 84c:	853e                	mv	a0,a5
 84e:	fef71ae3          	bne	a4,a5,842 <malloc+0x8e>
  p = sbrk(nu * sizeof(Header));
 852:	8552                	mv	a0,s4
 854:	00000097          	auipc	ra,0x0
 858:	b68080e7          	jalr	-1176(ra) # 3bc <sbrk>
  if(p == (char*)-1)
 85c:	fd551ae3          	bne	a0,s5,830 <malloc+0x7c>
        return 0;
 860:	4501                	li	a0,0
 862:	74a2                	ld	s1,40(sp)
 864:	6a42                	ld	s4,16(sp)
 866:	6aa2                	ld	s5,8(sp)
 868:	6b02                	ld	s6,0(sp)
 86a:	a03d                	j	898 <malloc+0xe4>
 86c:	74a2                	ld	s1,40(sp)
 86e:	6a42                	ld	s4,16(sp)
 870:	6aa2                	ld	s5,8(sp)
 872:	6b02                	ld	s6,0(sp)
      if(p->s.size == nunits)
 874:	fae90be3          	beq	s2,a4,82a <malloc+0x76>
        p->s.size -= nunits;
 878:	4137073b          	subw	a4,a4,s3
 87c:	c798                	sw	a4,8(a5)
        p += p->s.size;
 87e:	02071693          	slli	a3,a4,0x20
 882:	01c6d713          	srli	a4,a3,0x1c
 886:	97ba                	add	a5,a5,a4
        p->s.size = nunits;
 888:	0137a423          	sw	s3,8(a5)
      freep = prevp;
 88c:	00001717          	auipc	a4,0x1
 890:	c8a73223          	sd	a0,-892(a4) # 1510 <freep>
      return (void*)(p + 1);
 894:	01078513          	addi	a0,a5,16
  }
}
 898:	70e2                	ld	ra,56(sp)
 89a:	7442                	ld	s0,48(sp)
 89c:	7902                	ld	s2,32(sp)
 89e:	69e2                	ld	s3,24(sp)
 8a0:	6121                	addi	sp,sp,64
 8a2:	8082                	ret
 8a4:	74a2                	ld	s1,40(sp)
 8a6:	6a42                	ld	s4,16(sp)
 8a8:	6aa2                	ld	s5,8(sp)
 8aa:	6b02                	ld	s6,0(sp)
 8ac:	b7f5                	j	898 <malloc+0xe4>

00000000000008ae <ithread_exit>:
  free(stacks);
  stacks = new_stacks;
  return 0;
}

void ithread_exit(uint64 status) {
 8ae:	1141                	addi	sp,sp,-16
 8b0:	e406                	sd	ra,8(sp)
 8b2:	e022                	sd	s0,0(sp)
 8b4:	0800                	addi	s0,sp,16
  thread_exit(status);
 8b6:	2501                	sext.w	a0,a0
 8b8:	00000097          	auipc	ra,0x0
 8bc:	b34080e7          	jalr	-1228(ra) # 3ec <thread_exit>
}
 8c0:	60a2                	ld	ra,8(sp)
 8c2:	6402                	ld	s0,0(sp)
 8c4:	0141                	addi	sp,sp,16
 8c6:	8082                	ret

00000000000008c8 <free_stacks>:
int free_stacks() {
 8c8:	7179                	addi	sp,sp,-48
 8ca:	f406                	sd	ra,40(sp)
 8cc:	f022                	sd	s0,32(sp)
 8ce:	ec26                	sd	s1,24(sp)
 8d0:	1800                	addi	s0,sp,48
  for (int i = 0; i < num_threads; i++) {
 8d2:	00001797          	auipc	a5,0x1
 8d6:	c4e7a783          	lw	a5,-946(a5) # 1520 <num_threads>
 8da:	04f05063          	blez	a5,91a <free_stacks+0x52>
 8de:	e84a                	sd	s2,16(sp)
 8e0:	e44e                	sd	s3,8(sp)
 8e2:	4481                	li	s1,0
    free(stacks[i]);
 8e4:	00001997          	auipc	s3,0x1
 8e8:	c3498993          	addi	s3,s3,-972 # 1518 <stacks>
  for (int i = 0; i < num_threads; i++) {
 8ec:	00001917          	auipc	s2,0x1
 8f0:	c3490913          	addi	s2,s2,-972 # 1520 <num_threads>
    free(stacks[i]);
 8f4:	0009b783          	ld	a5,0(s3)
 8f8:	00349713          	slli	a4,s1,0x3
 8fc:	97ba                	add	a5,a5,a4
 8fe:	6388                	ld	a0,0(a5)
 900:	00000097          	auipc	ra,0x0
 904:	e2e080e7          	jalr	-466(ra) # 72e <free>
  for (int i = 0; i < num_threads; i++) {
 908:	0485                	addi	s1,s1,1
 90a:	00092703          	lw	a4,0(s2)
 90e:	0004879b          	sext.w	a5,s1
 912:	fee7c1e3          	blt	a5,a4,8f4 <free_stacks+0x2c>
 916:	6942                	ld	s2,16(sp)
 918:	69a2                	ld	s3,8(sp)
  free(stacks);
 91a:	00001497          	auipc	s1,0x1
 91e:	bfe48493          	addi	s1,s1,-1026 # 1518 <stacks>
 922:	6088                	ld	a0,0(s1)
 924:	00000097          	auipc	ra,0x0
 928:	e0a080e7          	jalr	-502(ra) # 72e <free>
  stacks = 0;
 92c:	0004b023          	sd	zero,0(s1)
  num_threads = 0;
 930:	00001797          	auipc	a5,0x1
 934:	be07a823          	sw	zero,-1040(a5) # 1520 <num_threads>
  max_stacks = INIT_MAX_STACKS;
 938:	47a1                	li	a5,8
 93a:	00001717          	auipc	a4,0x1
 93e:	bcf72323          	sw	a5,-1082(a4) # 1500 <max_stacks>
  threads_done = 0;
 942:	00001797          	auipc	a5,0x1
 946:	be07a123          	sw	zero,-1054(a5) # 1524 <threads_done>
}
 94a:	4501                	li	a0,0
 94c:	70a2                	ld	ra,40(sp)
 94e:	7402                	ld	s0,32(sp)
 950:	64e2                	ld	s1,24(sp)
 952:	6145                	addi	sp,sp,48
 954:	8082                	ret

0000000000000956 <expand_num_threads>:
int expand_num_threads() {
 956:	1101                	addi	sp,sp,-32
 958:	ec06                	sd	ra,24(sp)
 95a:	e822                	sd	s0,16(sp)
 95c:	e426                	sd	s1,8(sp)
 95e:	e04a                	sd	s2,0(sp)
 960:	1000                	addi	s0,sp,32
  max_stacks *= 2;
 962:	00001797          	auipc	a5,0x1
 966:	b9e78793          	addi	a5,a5,-1122 # 1500 <max_stacks>
 96a:	4388                	lw	a0,0(a5)
 96c:	0015151b          	slliw	a0,a0,0x1
 970:	c388                	sw	a0,0(a5)
  void **new_stacks = malloc(max_stacks*sizeof(char*));
 972:	0035151b          	slliw	a0,a0,0x3
 976:	00000097          	auipc	ra,0x0
 97a:	e3e080e7          	jalr	-450(ra) # 7b4 <malloc>
 97e:	892a                	mv	s2,a0
  memmove(new_stacks, stacks, num_threads*sizeof(char*));
 980:	00001617          	auipc	a2,0x1
 984:	ba062603          	lw	a2,-1120(a2) # 1520 <num_threads>
 988:	00001497          	auipc	s1,0x1
 98c:	b9048493          	addi	s1,s1,-1136 # 1518 <stacks>
 990:	0036161b          	slliw	a2,a2,0x3
 994:	608c                	ld	a1,0(s1)
 996:	00000097          	auipc	ra,0x0
 99a:	8e4080e7          	jalr	-1820(ra) # 27a <memmove>
  free(stacks);
 99e:	6088                	ld	a0,0(s1)
 9a0:	00000097          	auipc	ra,0x0
 9a4:	d8e080e7          	jalr	-626(ra) # 72e <free>
  stacks = new_stacks;
 9a8:	0124b023          	sd	s2,0(s1)
}
 9ac:	4501                	li	a0,0
 9ae:	60e2                	ld	ra,24(sp)
 9b0:	6442                	ld	s0,16(sp)
 9b2:	64a2                	ld	s1,8(sp)
 9b4:	6902                	ld	s2,0(sp)
 9b6:	6105                	addi	sp,sp,32
 9b8:	8082                	ret

00000000000009ba <ithread_create>:

int ithread_create(void* (*fn_ptr)(void *), void *args) {
 9ba:	7179                	addi	sp,sp,-48
 9bc:	f406                	sd	ra,40(sp)
 9be:	f022                	sd	s0,32(sp)
 9c0:	e84a                	sd	s2,16(sp)
 9c2:	e44e                	sd	s3,8(sp)
 9c4:	1800                	addi	s0,sp,48
 9c6:	892a                	mv	s2,a0
 9c8:	89ae                	mv	s3,a1
  if (stacks == 0) {
 9ca:	00001797          	auipc	a5,0x1
 9ce:	b4e7b783          	ld	a5,-1202(a5) # 1518 <stacks>
 9d2:	c3d9                	beqz	a5,a58 <ithread_create+0x9e>
    stacks = malloc(max_stacks*sizeof(char*));
  }
  if (num_threads == max_stacks) {
 9d4:	00001797          	auipc	a5,0x1
 9d8:	b2c7a783          	lw	a5,-1236(a5) # 1500 <max_stacks>
 9dc:	00001717          	auipc	a4,0x1
 9e0:	b4472703          	lw	a4,-1212(a4) # 1520 <num_threads>
 9e4:	0af71363          	bne	a4,a5,a8a <ithread_create+0xd0>
    if (max_stacks == MAX_THREADS) {
 9e8:	04000713          	li	a4,64
 9ec:	08e78563          	beq	a5,a4,a76 <ithread_create+0xbc>
 9f0:	ec26                	sd	s1,24(sp)
      printf("ERROR: Thread capacity has been reached\n");
      return -1;
    }
    expand_num_threads();
 9f2:	00000097          	auipc	ra,0x0
 9f6:	f64080e7          	jalr	-156(ra) # 956 <expand_num_threads>
  }

  void *stack_ptr = malloc(PGSIZE);
 9fa:	6505                	lui	a0,0x1
 9fc:	00000097          	auipc	ra,0x0
 a00:	db8080e7          	jalr	-584(ra) # 7b4 <malloc>
 a04:	84aa                	mv	s1,a0
  stacks[num_threads] = stack_ptr;
 a06:	00001717          	auipc	a4,0x1
 a0a:	b1a72703          	lw	a4,-1254(a4) # 1520 <num_threads>
 a0e:	070e                	slli	a4,a4,0x3
 a10:	00001797          	auipc	a5,0x1
 a14:	b087b783          	ld	a5,-1272(a5) # 1518 <stacks>
 a18:	97ba                	add	a5,a5,a4
 a1a:	e388                	sd	a0,0(a5)
  int res = create_thread(fn_ptr, args, stack_ptr, &ithread_exit);
 a1c:	00000697          	auipc	a3,0x0
 a20:	e9268693          	addi	a3,a3,-366 # 8ae <ithread_exit>
 a24:	862a                	mv	a2,a0
 a26:	85ce                	mv	a1,s3
 a28:	854a                	mv	a0,s2
 a2a:	00000097          	auipc	ra,0x0
 a2e:	9b2080e7          	jalr	-1614(ra) # 3dc <create_thread>
 a32:	892a                	mv	s2,a0
  if (res != -1) {
 a34:	57fd                	li	a5,-1
 a36:	04f50c63          	beq	a0,a5,a8e <ithread_create+0xd4>
    num_threads++;
 a3a:	00001717          	auipc	a4,0x1
 a3e:	ae670713          	addi	a4,a4,-1306 # 1520 <num_threads>
 a42:	431c                	lw	a5,0(a4)
 a44:	2785                	addiw	a5,a5,1
 a46:	c31c                	sw	a5,0(a4)
 a48:	64e2                	ld	s1,24(sp)
  } else {
    free(stack_ptr);
    stacks[num_threads] = 0;
  }
  return res;
}
 a4a:	854a                	mv	a0,s2
 a4c:	70a2                	ld	ra,40(sp)
 a4e:	7402                	ld	s0,32(sp)
 a50:	6942                	ld	s2,16(sp)
 a52:	69a2                	ld	s3,8(sp)
 a54:	6145                	addi	sp,sp,48
 a56:	8082                	ret
    stacks = malloc(max_stacks*sizeof(char*));
 a58:	00001517          	auipc	a0,0x1
 a5c:	aa852503          	lw	a0,-1368(a0) # 1500 <max_stacks>
 a60:	0035151b          	slliw	a0,a0,0x3
 a64:	00000097          	auipc	ra,0x0
 a68:	d50080e7          	jalr	-688(ra) # 7b4 <malloc>
 a6c:	00001797          	auipc	a5,0x1
 a70:	aaa7b623          	sd	a0,-1364(a5) # 1518 <stacks>
 a74:	b785                	j	9d4 <ithread_create+0x1a>
      printf("ERROR: Thread capacity has been reached\n");
 a76:	00000517          	auipc	a0,0x0
 a7a:	0ca50513          	addi	a0,a0,202 # b40 <ithread_join+0x8c>
 a7e:	00000097          	auipc	ra,0x0
 a82:	c7a080e7          	jalr	-902(ra) # 6f8 <printf>
      return -1;
 a86:	597d                	li	s2,-1
 a88:	b7c9                	j	a4a <ithread_create+0x90>
 a8a:	ec26                	sd	s1,24(sp)
 a8c:	b7bd                	j	9fa <ithread_create+0x40>
    free(stack_ptr);
 a8e:	8526                	mv	a0,s1
 a90:	00000097          	auipc	ra,0x0
 a94:	c9e080e7          	jalr	-866(ra) # 72e <free>
    stacks[num_threads] = 0;
 a98:	00001717          	auipc	a4,0x1
 a9c:	a8872703          	lw	a4,-1400(a4) # 1520 <num_threads>
 aa0:	070e                	slli	a4,a4,0x3
 aa2:	00001797          	auipc	a5,0x1
 aa6:	a767b783          	ld	a5,-1418(a5) # 1518 <stacks>
 aaa:	97ba                	add	a5,a5,a4
 aac:	0007b023          	sd	zero,0(a5)
 ab0:	64e2                	ld	s1,24(sp)
 ab2:	bf61                	j	a4a <ithread_create+0x90>

0000000000000ab4 <ithread_join>:

int ithread_join(int thread_id) {
 ab4:	1101                	addi	sp,sp,-32
 ab6:	ec06                	sd	ra,24(sp)
 ab8:	e822                	sd	s0,16(sp)
 aba:	1000                	addi	s0,sp,32
  int status;
  join_thread(thread_id, (uint64)&status);
 abc:	ff040793          	addi	a5,s0,-16
 ac0:	ffc7859b          	addiw	a1,a5,-4
 ac4:	00000097          	auipc	ra,0x0
 ac8:	920080e7          	jalr	-1760(ra) # 3e4 <join_thread>
  threads_done++;
 acc:	00001717          	auipc	a4,0x1
 ad0:	a5870713          	addi	a4,a4,-1448 # 1524 <threads_done>
 ad4:	431c                	lw	a5,0(a4)
 ad6:	2785                	addiw	a5,a5,1
 ad8:	c31c                	sw	a5,0(a4)
  if (threads_done == num_threads) {
 ada:	00001717          	auipc	a4,0x1
 ade:	a4672703          	lw	a4,-1466(a4) # 1520 <num_threads>
 ae2:	00f70863          	beq	a4,a5,af2 <ithread_join+0x3e>
    free_stacks();
  }
  return status;
}
 ae6:	fec42503          	lw	a0,-20(s0)
 aea:	60e2                	ld	ra,24(sp)
 aec:	6442                	ld	s0,16(sp)
 aee:	6105                	addi	sp,sp,32
 af0:	8082                	ret
    free_stacks();
 af2:	00000097          	auipc	ra,0x0
 af6:	dd6080e7          	jalr	-554(ra) # 8c8 <free_stacks>
 afa:	b7f5                	j	ae6 <ithread_join+0x32>
