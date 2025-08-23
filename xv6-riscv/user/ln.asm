
user/_ln:     file format elf64-littleriscv


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
  if(argc != 3){
   8:	478d                	li	a5,3
   a:	02f50163          	beq	a0,a5,2c <main+0x2c>
   e:	e426                	sd	s1,8(sp)
    fprintf(2, "Usage: ln old new\n");
  10:	00001597          	auipc	a1,0x1
  14:	ab058593          	addi	a1,a1,-1360 # ac0 <ithread_join+0x4a>
  18:	4509                	li	a0,2
  1a:	00000097          	auipc	ra,0x0
  1e:	672080e7          	jalr	1650(ra) # 68c <fprintf>
    exit(1);
  22:	4505                	li	a0,1
  24:	00000097          	auipc	ra,0x0
  28:	2f8080e7          	jalr	760(ra) # 31c <exit>
  2c:	e426                	sd	s1,8(sp)
  2e:	84ae                	mv	s1,a1
  }
  if(link(argv[1], argv[2]) < 0)
  30:	698c                	ld	a1,16(a1)
  32:	6488                	ld	a0,8(s1)
  34:	00000097          	auipc	ra,0x0
  38:	348080e7          	jalr	840(ra) # 37c <link>
  3c:	00054763          	bltz	a0,4a <main+0x4a>
    fprintf(2, "link %s %s: failed\n", argv[1], argv[2]);
  exit(0);
  40:	4501                	li	a0,0
  42:	00000097          	auipc	ra,0x0
  46:	2da080e7          	jalr	730(ra) # 31c <exit>
    fprintf(2, "link %s %s: failed\n", argv[1], argv[2]);
  4a:	6894                	ld	a3,16(s1)
  4c:	6490                	ld	a2,8(s1)
  4e:	00001597          	auipc	a1,0x1
  52:	a8a58593          	addi	a1,a1,-1398 # ad8 <ithread_join+0x62>
  56:	4509                	li	a0,2
  58:	00000097          	auipc	ra,0x0
  5c:	634080e7          	jalr	1588(ra) # 68c <fprintf>
  60:	b7c5                	j	40 <main+0x40>

0000000000000062 <_main>:
//
// wrapper so that it's OK if main() does not call exit().
//
void
_main()
{
  62:	1141                	addi	sp,sp,-16
  64:	e406                	sd	ra,8(sp)
  66:	e022                	sd	s0,0(sp)
  68:	0800                	addi	s0,sp,16
  extern int main();
  main();
  6a:	00000097          	auipc	ra,0x0
  6e:	f96080e7          	jalr	-106(ra) # 0 <main>
  exit(0);
  72:	4501                	li	a0,0
  74:	00000097          	auipc	ra,0x0
  78:	2a8080e7          	jalr	680(ra) # 31c <exit>

000000000000007c <strcpy>:
}

char*
strcpy(char *s, const char *t)
{
  7c:	1141                	addi	sp,sp,-16
  7e:	e406                	sd	ra,8(sp)
  80:	e022                	sd	s0,0(sp)
  82:	0800                	addi	s0,sp,16
  char *os;

  os = s;
  while((*s++ = *t++) != 0)
  84:	87aa                	mv	a5,a0
  86:	0585                	addi	a1,a1,1
  88:	0785                	addi	a5,a5,1
  8a:	fff5c703          	lbu	a4,-1(a1)
  8e:	fee78fa3          	sb	a4,-1(a5)
  92:	fb75                	bnez	a4,86 <strcpy+0xa>
    ;
  return os;
}
  94:	60a2                	ld	ra,8(sp)
  96:	6402                	ld	s0,0(sp)
  98:	0141                	addi	sp,sp,16
  9a:	8082                	ret

000000000000009c <strcmp>:

int
strcmp(const char *p, const char *q)
{
  9c:	1141                	addi	sp,sp,-16
  9e:	e406                	sd	ra,8(sp)
  a0:	e022                	sd	s0,0(sp)
  a2:	0800                	addi	s0,sp,16
  while(*p && *p == *q)
  a4:	00054783          	lbu	a5,0(a0)
  a8:	cb91                	beqz	a5,bc <strcmp+0x20>
  aa:	0005c703          	lbu	a4,0(a1)
  ae:	00f71763          	bne	a4,a5,bc <strcmp+0x20>
    p++, q++;
  b2:	0505                	addi	a0,a0,1
  b4:	0585                	addi	a1,a1,1
  while(*p && *p == *q)
  b6:	00054783          	lbu	a5,0(a0)
  ba:	fbe5                	bnez	a5,aa <strcmp+0xe>
  return (uchar)*p - (uchar)*q;
  bc:	0005c503          	lbu	a0,0(a1)
}
  c0:	40a7853b          	subw	a0,a5,a0
  c4:	60a2                	ld	ra,8(sp)
  c6:	6402                	ld	s0,0(sp)
  c8:	0141                	addi	sp,sp,16
  ca:	8082                	ret

00000000000000cc <strlen>:

uint
strlen(const char *s)
{
  cc:	1141                	addi	sp,sp,-16
  ce:	e406                	sd	ra,8(sp)
  d0:	e022                	sd	s0,0(sp)
  d2:	0800                	addi	s0,sp,16
  int n;

  for(n = 0; s[n]; n++)
  d4:	00054783          	lbu	a5,0(a0)
  d8:	cf99                	beqz	a5,f6 <strlen+0x2a>
  da:	0505                	addi	a0,a0,1
  dc:	87aa                	mv	a5,a0
  de:	86be                	mv	a3,a5
  e0:	0785                	addi	a5,a5,1
  e2:	fff7c703          	lbu	a4,-1(a5)
  e6:	ff65                	bnez	a4,de <strlen+0x12>
  e8:	40a6853b          	subw	a0,a3,a0
  ec:	2505                	addiw	a0,a0,1
    ;
  return n;
}
  ee:	60a2                	ld	ra,8(sp)
  f0:	6402                	ld	s0,0(sp)
  f2:	0141                	addi	sp,sp,16
  f4:	8082                	ret
  for(n = 0; s[n]; n++)
  f6:	4501                	li	a0,0
  f8:	bfdd                	j	ee <strlen+0x22>

00000000000000fa <memset>:

void*
memset(void *dst, int c, uint n)
{
  fa:	1141                	addi	sp,sp,-16
  fc:	e406                	sd	ra,8(sp)
  fe:	e022                	sd	s0,0(sp)
 100:	0800                	addi	s0,sp,16
  char *cdst = (char *) dst;
  int i;
  for(i = 0; i < n; i++){
 102:	ca19                	beqz	a2,118 <memset+0x1e>
 104:	87aa                	mv	a5,a0
 106:	1602                	slli	a2,a2,0x20
 108:	9201                	srli	a2,a2,0x20
 10a:	00a60733          	add	a4,a2,a0
    cdst[i] = c;
 10e:	00b78023          	sb	a1,0(a5)
  for(i = 0; i < n; i++){
 112:	0785                	addi	a5,a5,1
 114:	fee79de3          	bne	a5,a4,10e <memset+0x14>
  }
  return dst;
}
 118:	60a2                	ld	ra,8(sp)
 11a:	6402                	ld	s0,0(sp)
 11c:	0141                	addi	sp,sp,16
 11e:	8082                	ret

0000000000000120 <strchr>:

char*
strchr(const char *s, char c)
{
 120:	1141                	addi	sp,sp,-16
 122:	e406                	sd	ra,8(sp)
 124:	e022                	sd	s0,0(sp)
 126:	0800                	addi	s0,sp,16
  for(; *s; s++)
 128:	00054783          	lbu	a5,0(a0)
 12c:	cf81                	beqz	a5,144 <strchr+0x24>
    if(*s == c)
 12e:	00f58763          	beq	a1,a5,13c <strchr+0x1c>
  for(; *s; s++)
 132:	0505                	addi	a0,a0,1
 134:	00054783          	lbu	a5,0(a0)
 138:	fbfd                	bnez	a5,12e <strchr+0xe>
      return (char*)s;
  return 0;
 13a:	4501                	li	a0,0
}
 13c:	60a2                	ld	ra,8(sp)
 13e:	6402                	ld	s0,0(sp)
 140:	0141                	addi	sp,sp,16
 142:	8082                	ret
  return 0;
 144:	4501                	li	a0,0
 146:	bfdd                	j	13c <strchr+0x1c>

0000000000000148 <gets>:

char*
gets(char *buf, int max)
{
 148:	7159                	addi	sp,sp,-112
 14a:	f486                	sd	ra,104(sp)
 14c:	f0a2                	sd	s0,96(sp)
 14e:	eca6                	sd	s1,88(sp)
 150:	e8ca                	sd	s2,80(sp)
 152:	e4ce                	sd	s3,72(sp)
 154:	e0d2                	sd	s4,64(sp)
 156:	fc56                	sd	s5,56(sp)
 158:	f85a                	sd	s6,48(sp)
 15a:	f45e                	sd	s7,40(sp)
 15c:	f062                	sd	s8,32(sp)
 15e:	ec66                	sd	s9,24(sp)
 160:	e86a                	sd	s10,16(sp)
 162:	1880                	addi	s0,sp,112
 164:	8caa                	mv	s9,a0
 166:	8a2e                	mv	s4,a1
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 168:	892a                	mv	s2,a0
 16a:	4481                	li	s1,0
    cc = read(0, &c, 1);
 16c:	f9f40b13          	addi	s6,s0,-97
 170:	4a85                	li	s5,1
    if(cc < 1)
      break;
    buf[i++] = c;
    if(c == '\n' || c == '\r')
 172:	4ba9                	li	s7,10
 174:	4c35                	li	s8,13
  for(i=0; i+1 < max; ){
 176:	8d26                	mv	s10,s1
 178:	0014899b          	addiw	s3,s1,1
 17c:	84ce                	mv	s1,s3
 17e:	0349d763          	bge	s3,s4,1ac <gets+0x64>
    cc = read(0, &c, 1);
 182:	8656                	mv	a2,s5
 184:	85da                	mv	a1,s6
 186:	4501                	li	a0,0
 188:	00000097          	auipc	ra,0x0
 18c:	1ac080e7          	jalr	428(ra) # 334 <read>
    if(cc < 1)
 190:	00a05e63          	blez	a0,1ac <gets+0x64>
    buf[i++] = c;
 194:	f9f44783          	lbu	a5,-97(s0)
 198:	00f90023          	sb	a5,0(s2)
    if(c == '\n' || c == '\r')
 19c:	01778763          	beq	a5,s7,1aa <gets+0x62>
 1a0:	0905                	addi	s2,s2,1
 1a2:	fd879ae3          	bne	a5,s8,176 <gets+0x2e>
    buf[i++] = c;
 1a6:	8d4e                	mv	s10,s3
 1a8:	a011                	j	1ac <gets+0x64>
 1aa:	8d4e                	mv	s10,s3
      break;
  }
  buf[i] = '\0';
 1ac:	9d66                	add	s10,s10,s9
 1ae:	000d0023          	sb	zero,0(s10)
  return buf;
}
 1b2:	8566                	mv	a0,s9
 1b4:	70a6                	ld	ra,104(sp)
 1b6:	7406                	ld	s0,96(sp)
 1b8:	64e6                	ld	s1,88(sp)
 1ba:	6946                	ld	s2,80(sp)
 1bc:	69a6                	ld	s3,72(sp)
 1be:	6a06                	ld	s4,64(sp)
 1c0:	7ae2                	ld	s5,56(sp)
 1c2:	7b42                	ld	s6,48(sp)
 1c4:	7ba2                	ld	s7,40(sp)
 1c6:	7c02                	ld	s8,32(sp)
 1c8:	6ce2                	ld	s9,24(sp)
 1ca:	6d42                	ld	s10,16(sp)
 1cc:	6165                	addi	sp,sp,112
 1ce:	8082                	ret

00000000000001d0 <stat>:

int
stat(const char *n, struct stat *st)
{
 1d0:	1101                	addi	sp,sp,-32
 1d2:	ec06                	sd	ra,24(sp)
 1d4:	e822                	sd	s0,16(sp)
 1d6:	e04a                	sd	s2,0(sp)
 1d8:	1000                	addi	s0,sp,32
 1da:	892e                	mv	s2,a1
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 1dc:	4581                	li	a1,0
 1de:	00000097          	auipc	ra,0x0
 1e2:	17e080e7          	jalr	382(ra) # 35c <open>
  if(fd < 0)
 1e6:	02054663          	bltz	a0,212 <stat+0x42>
 1ea:	e426                	sd	s1,8(sp)
 1ec:	84aa                	mv	s1,a0
    return -1;
  r = fstat(fd, st);
 1ee:	85ca                	mv	a1,s2
 1f0:	00000097          	auipc	ra,0x0
 1f4:	184080e7          	jalr	388(ra) # 374 <fstat>
 1f8:	892a                	mv	s2,a0
  close(fd);
 1fa:	8526                	mv	a0,s1
 1fc:	00000097          	auipc	ra,0x0
 200:	148080e7          	jalr	328(ra) # 344 <close>
  return r;
 204:	64a2                	ld	s1,8(sp)
}
 206:	854a                	mv	a0,s2
 208:	60e2                	ld	ra,24(sp)
 20a:	6442                	ld	s0,16(sp)
 20c:	6902                	ld	s2,0(sp)
 20e:	6105                	addi	sp,sp,32
 210:	8082                	ret
    return -1;
 212:	597d                	li	s2,-1
 214:	bfcd                	j	206 <stat+0x36>

0000000000000216 <atoi>:

int
atoi(const char *s)
{
 216:	1141                	addi	sp,sp,-16
 218:	e406                	sd	ra,8(sp)
 21a:	e022                	sd	s0,0(sp)
 21c:	0800                	addi	s0,sp,16
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
 21e:	00054683          	lbu	a3,0(a0)
 222:	fd06879b          	addiw	a5,a3,-48
 226:	0ff7f793          	zext.b	a5,a5
 22a:	4625                	li	a2,9
 22c:	02f66963          	bltu	a2,a5,25e <atoi+0x48>
 230:	872a                	mv	a4,a0
  n = 0;
 232:	4501                	li	a0,0
    n = n*10 + *s++ - '0';
 234:	0705                	addi	a4,a4,1
 236:	0025179b          	slliw	a5,a0,0x2
 23a:	9fa9                	addw	a5,a5,a0
 23c:	0017979b          	slliw	a5,a5,0x1
 240:	9fb5                	addw	a5,a5,a3
 242:	fd07851b          	addiw	a0,a5,-48
  while('0' <= *s && *s <= '9')
 246:	00074683          	lbu	a3,0(a4)
 24a:	fd06879b          	addiw	a5,a3,-48
 24e:	0ff7f793          	zext.b	a5,a5
 252:	fef671e3          	bgeu	a2,a5,234 <atoi+0x1e>
  return n;
}
 256:	60a2                	ld	ra,8(sp)
 258:	6402                	ld	s0,0(sp)
 25a:	0141                	addi	sp,sp,16
 25c:	8082                	ret
  n = 0;
 25e:	4501                	li	a0,0
 260:	bfdd                	j	256 <atoi+0x40>

0000000000000262 <memmove>:

void*
memmove(void *vdst, const void *vsrc, int n)
{
 262:	1141                	addi	sp,sp,-16
 264:	e406                	sd	ra,8(sp)
 266:	e022                	sd	s0,0(sp)
 268:	0800                	addi	s0,sp,16
  char *dst;
  const char *src;

  dst = vdst;
  src = vsrc;
  if (src > dst) {
 26a:	02b57563          	bgeu	a0,a1,294 <memmove+0x32>
    while(n-- > 0)
 26e:	00c05f63          	blez	a2,28c <memmove+0x2a>
 272:	1602                	slli	a2,a2,0x20
 274:	9201                	srli	a2,a2,0x20
 276:	00c507b3          	add	a5,a0,a2
  dst = vdst;
 27a:	872a                	mv	a4,a0
      *dst++ = *src++;
 27c:	0585                	addi	a1,a1,1
 27e:	0705                	addi	a4,a4,1
 280:	fff5c683          	lbu	a3,-1(a1)
 284:	fed70fa3          	sb	a3,-1(a4)
    while(n-- > 0)
 288:	fee79ae3          	bne	a5,a4,27c <memmove+0x1a>
    src += n;
    while(n-- > 0)
      *--dst = *--src;
  }
  return vdst;
}
 28c:	60a2                	ld	ra,8(sp)
 28e:	6402                	ld	s0,0(sp)
 290:	0141                	addi	sp,sp,16
 292:	8082                	ret
    dst += n;
 294:	00c50733          	add	a4,a0,a2
    src += n;
 298:	95b2                	add	a1,a1,a2
    while(n-- > 0)
 29a:	fec059e3          	blez	a2,28c <memmove+0x2a>
 29e:	fff6079b          	addiw	a5,a2,-1
 2a2:	1782                	slli	a5,a5,0x20
 2a4:	9381                	srli	a5,a5,0x20
 2a6:	fff7c793          	not	a5,a5
 2aa:	97ba                	add	a5,a5,a4
      *--dst = *--src;
 2ac:	15fd                	addi	a1,a1,-1
 2ae:	177d                	addi	a4,a4,-1
 2b0:	0005c683          	lbu	a3,0(a1)
 2b4:	00d70023          	sb	a3,0(a4)
    while(n-- > 0)
 2b8:	fef71ae3          	bne	a4,a5,2ac <memmove+0x4a>
 2bc:	bfc1                	j	28c <memmove+0x2a>

00000000000002be <memcmp>:

int
memcmp(const void *s1, const void *s2, uint n)
{
 2be:	1141                	addi	sp,sp,-16
 2c0:	e406                	sd	ra,8(sp)
 2c2:	e022                	sd	s0,0(sp)
 2c4:	0800                	addi	s0,sp,16
  const char *p1 = s1, *p2 = s2;
  while (n-- > 0) {
 2c6:	ca0d                	beqz	a2,2f8 <memcmp+0x3a>
 2c8:	fff6069b          	addiw	a3,a2,-1
 2cc:	1682                	slli	a3,a3,0x20
 2ce:	9281                	srli	a3,a3,0x20
 2d0:	0685                	addi	a3,a3,1
 2d2:	96aa                	add	a3,a3,a0
    if (*p1 != *p2) {
 2d4:	00054783          	lbu	a5,0(a0)
 2d8:	0005c703          	lbu	a4,0(a1)
 2dc:	00e79863          	bne	a5,a4,2ec <memcmp+0x2e>
      return *p1 - *p2;
    }
    p1++;
 2e0:	0505                	addi	a0,a0,1
    p2++;
 2e2:	0585                	addi	a1,a1,1
  while (n-- > 0) {
 2e4:	fed518e3          	bne	a0,a3,2d4 <memcmp+0x16>
  }
  return 0;
 2e8:	4501                	li	a0,0
 2ea:	a019                	j	2f0 <memcmp+0x32>
      return *p1 - *p2;
 2ec:	40e7853b          	subw	a0,a5,a4
}
 2f0:	60a2                	ld	ra,8(sp)
 2f2:	6402                	ld	s0,0(sp)
 2f4:	0141                	addi	sp,sp,16
 2f6:	8082                	ret
  return 0;
 2f8:	4501                	li	a0,0
 2fa:	bfdd                	j	2f0 <memcmp+0x32>

00000000000002fc <memcpy>:

void *
memcpy(void *dst, const void *src, uint n)
{
 2fc:	1141                	addi	sp,sp,-16
 2fe:	e406                	sd	ra,8(sp)
 300:	e022                	sd	s0,0(sp)
 302:	0800                	addi	s0,sp,16
  return memmove(dst, src, n);
 304:	00000097          	auipc	ra,0x0
 308:	f5e080e7          	jalr	-162(ra) # 262 <memmove>
}
 30c:	60a2                	ld	ra,8(sp)
 30e:	6402                	ld	s0,0(sp)
 310:	0141                	addi	sp,sp,16
 312:	8082                	ret

0000000000000314 <fork>:
# generated by usys.pl - do not edit
#include "kernel/syscall.h"
.global fork
fork:
 li a7, SYS_fork
 314:	4885                	li	a7,1
 ecall
 316:	00000073          	ecall
 ret
 31a:	8082                	ret

000000000000031c <exit>:
.global exit
exit:
 li a7, SYS_exit
 31c:	4889                	li	a7,2
 ecall
 31e:	00000073          	ecall
 ret
 322:	8082                	ret

0000000000000324 <wait>:
.global wait
wait:
 li a7, SYS_wait
 324:	488d                	li	a7,3
 ecall
 326:	00000073          	ecall
 ret
 32a:	8082                	ret

000000000000032c <pipe>:
.global pipe
pipe:
 li a7, SYS_pipe
 32c:	4891                	li	a7,4
 ecall
 32e:	00000073          	ecall
 ret
 332:	8082                	ret

0000000000000334 <read>:
.global read
read:
 li a7, SYS_read
 334:	4895                	li	a7,5
 ecall
 336:	00000073          	ecall
 ret
 33a:	8082                	ret

000000000000033c <write>:
.global write
write:
 li a7, SYS_write
 33c:	48c1                	li	a7,16
 ecall
 33e:	00000073          	ecall
 ret
 342:	8082                	ret

0000000000000344 <close>:
.global close
close:
 li a7, SYS_close
 344:	48d5                	li	a7,21
 ecall
 346:	00000073          	ecall
 ret
 34a:	8082                	ret

000000000000034c <kill>:
.global kill
kill:
 li a7, SYS_kill
 34c:	4899                	li	a7,6
 ecall
 34e:	00000073          	ecall
 ret
 352:	8082                	ret

0000000000000354 <exec>:
.global exec
exec:
 li a7, SYS_exec
 354:	489d                	li	a7,7
 ecall
 356:	00000073          	ecall
 ret
 35a:	8082                	ret

000000000000035c <open>:
.global open
open:
 li a7, SYS_open
 35c:	48bd                	li	a7,15
 ecall
 35e:	00000073          	ecall
 ret
 362:	8082                	ret

0000000000000364 <mknod>:
.global mknod
mknod:
 li a7, SYS_mknod
 364:	48c5                	li	a7,17
 ecall
 366:	00000073          	ecall
 ret
 36a:	8082                	ret

000000000000036c <unlink>:
.global unlink
unlink:
 li a7, SYS_unlink
 36c:	48c9                	li	a7,18
 ecall
 36e:	00000073          	ecall
 ret
 372:	8082                	ret

0000000000000374 <fstat>:
.global fstat
fstat:
 li a7, SYS_fstat
 374:	48a1                	li	a7,8
 ecall
 376:	00000073          	ecall
 ret
 37a:	8082                	ret

000000000000037c <link>:
.global link
link:
 li a7, SYS_link
 37c:	48cd                	li	a7,19
 ecall
 37e:	00000073          	ecall
 ret
 382:	8082                	ret

0000000000000384 <mkdir>:
.global mkdir
mkdir:
 li a7, SYS_mkdir
 384:	48d1                	li	a7,20
 ecall
 386:	00000073          	ecall
 ret
 38a:	8082                	ret

000000000000038c <chdir>:
.global chdir
chdir:
 li a7, SYS_chdir
 38c:	48a5                	li	a7,9
 ecall
 38e:	00000073          	ecall
 ret
 392:	8082                	ret

0000000000000394 <dup>:
.global dup
dup:
 li a7, SYS_dup
 394:	48a9                	li	a7,10
 ecall
 396:	00000073          	ecall
 ret
 39a:	8082                	ret

000000000000039c <getpid>:
.global getpid
getpid:
 li a7, SYS_getpid
 39c:	48ad                	li	a7,11
 ecall
 39e:	00000073          	ecall
 ret
 3a2:	8082                	ret

00000000000003a4 <sbrk>:
.global sbrk
sbrk:
 li a7, SYS_sbrk
 3a4:	48b1                	li	a7,12
 ecall
 3a6:	00000073          	ecall
 ret
 3aa:	8082                	ret

00000000000003ac <sleep>:
.global sleep
sleep:
 li a7, SYS_sleep
 3ac:	48b5                	li	a7,13
 ecall
 3ae:	00000073          	ecall
 ret
 3b2:	8082                	ret

00000000000003b4 <uptime>:
.global uptime
uptime:
 li a7, SYS_uptime
 3b4:	48b9                	li	a7,14
 ecall
 3b6:	00000073          	ecall
 ret
 3ba:	8082                	ret

00000000000003bc <spoon>:
.global spoon
spoon:
 li a7, SYS_spoon
 3bc:	48d9                	li	a7,22
 ecall
 3be:	00000073          	ecall
 ret
 3c2:	8082                	ret

00000000000003c4 <create_thread>:
.global create_thread
create_thread:
 li a7, SYS_create_thread
 3c4:	48dd                	li	a7,23
 ecall
 3c6:	00000073          	ecall
 ret
 3ca:	8082                	ret

00000000000003cc <join_thread>:
.global join_thread
join_thread:
 li a7, SYS_join_thread
 3cc:	48e1                	li	a7,24
 ecall
 3ce:	00000073          	ecall
 ret
 3d2:	8082                	ret

00000000000003d4 <thread_exit>:
.global thread_exit
thread_exit:
 li a7, SYS_thread_exit
 3d4:	48e5                	li	a7,25
 ecall
 3d6:	00000073          	ecall
 ret
 3da:	8082                	ret

00000000000003dc <socket>:
.global socket
socket:
 li a7, SYS_socket
 3dc:	48e9                	li	a7,26
 ecall
 3de:	00000073          	ecall
 ret
 3e2:	8082                	ret

00000000000003e4 <bind>:
.global bind
bind:
 li a7, SYS_bind
 3e4:	48ed                	li	a7,27
 ecall
 3e6:	00000073          	ecall
 ret
 3ea:	8082                	ret

00000000000003ec <accept>:
.global accept
accept:
 li a7, SYS_accept
 3ec:	48f5                	li	a7,29
 ecall
 3ee:	00000073          	ecall
 ret
 3f2:	8082                	ret

00000000000003f4 <listen>:
.global listen
listen:
 li a7, SYS_listen
 3f4:	48f1                	li	a7,28
 ecall
 3f6:	00000073          	ecall
 ret
 3fa:	8082                	ret

00000000000003fc <connect>:
.global connect
connect:
 li a7, SYS_connect
 3fc:	48f9                	li	a7,30
 ecall
 3fe:	00000073          	ecall
 ret
 402:	8082                	ret

0000000000000404 <putc>:

static char digits[] = "0123456789ABCDEF";

static void
putc(int fd, char c)
{
 404:	1101                	addi	sp,sp,-32
 406:	ec06                	sd	ra,24(sp)
 408:	e822                	sd	s0,16(sp)
 40a:	1000                	addi	s0,sp,32
 40c:	feb407a3          	sb	a1,-17(s0)
  write(fd, &c, 1);
 410:	4605                	li	a2,1
 412:	fef40593          	addi	a1,s0,-17
 416:	00000097          	auipc	ra,0x0
 41a:	f26080e7          	jalr	-218(ra) # 33c <write>
}
 41e:	60e2                	ld	ra,24(sp)
 420:	6442                	ld	s0,16(sp)
 422:	6105                	addi	sp,sp,32
 424:	8082                	ret

0000000000000426 <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
 426:	7139                	addi	sp,sp,-64
 428:	fc06                	sd	ra,56(sp)
 42a:	f822                	sd	s0,48(sp)
 42c:	f426                	sd	s1,40(sp)
 42e:	f04a                	sd	s2,32(sp)
 430:	ec4e                	sd	s3,24(sp)
 432:	0080                	addi	s0,sp,64
 434:	892a                	mv	s2,a0
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
  if(sgn && xx < 0){
 436:	c299                	beqz	a3,43c <printint+0x16>
 438:	0805c063          	bltz	a1,4b8 <printint+0x92>
  neg = 0;
 43c:	4e01                	li	t3,0
    x = -xx;
  } else {
    x = xx;
  }

  i = 0;
 43e:	fc040313          	addi	t1,s0,-64
  neg = 0;
 442:	869a                	mv	a3,t1
  i = 0;
 444:	4781                	li	a5,0
  do{
    buf[i++] = digits[x % base];
 446:	00000817          	auipc	a6,0x0
 44a:	73a80813          	addi	a6,a6,1850 # b80 <digits>
 44e:	88be                	mv	a7,a5
 450:	0017851b          	addiw	a0,a5,1
 454:	87aa                	mv	a5,a0
 456:	02c5f73b          	remuw	a4,a1,a2
 45a:	1702                	slli	a4,a4,0x20
 45c:	9301                	srli	a4,a4,0x20
 45e:	9742                	add	a4,a4,a6
 460:	00074703          	lbu	a4,0(a4)
 464:	00e68023          	sb	a4,0(a3)
  }while((x /= base) != 0);
 468:	872e                	mv	a4,a1
 46a:	02c5d5bb          	divuw	a1,a1,a2
 46e:	0685                	addi	a3,a3,1
 470:	fcc77fe3          	bgeu	a4,a2,44e <printint+0x28>
  if(neg)
 474:	000e0c63          	beqz	t3,48c <printint+0x66>
    buf[i++] = '-';
 478:	fd050793          	addi	a5,a0,-48
 47c:	00878533          	add	a0,a5,s0
 480:	02d00793          	li	a5,45
 484:	fef50823          	sb	a5,-16(a0)
 488:	0028879b          	addiw	a5,a7,2

  while(--i >= 0)
 48c:	fff7899b          	addiw	s3,a5,-1
 490:	006784b3          	add	s1,a5,t1
    putc(fd, buf[i]);
 494:	fff4c583          	lbu	a1,-1(s1)
 498:	854a                	mv	a0,s2
 49a:	00000097          	auipc	ra,0x0
 49e:	f6a080e7          	jalr	-150(ra) # 404 <putc>
  while(--i >= 0)
 4a2:	39fd                	addiw	s3,s3,-1
 4a4:	14fd                	addi	s1,s1,-1
 4a6:	fe09d7e3          	bgez	s3,494 <printint+0x6e>
}
 4aa:	70e2                	ld	ra,56(sp)
 4ac:	7442                	ld	s0,48(sp)
 4ae:	74a2                	ld	s1,40(sp)
 4b0:	7902                	ld	s2,32(sp)
 4b2:	69e2                	ld	s3,24(sp)
 4b4:	6121                	addi	sp,sp,64
 4b6:	8082                	ret
    x = -xx;
 4b8:	40b005bb          	negw	a1,a1
    neg = 1;
 4bc:	4e05                	li	t3,1
    x = -xx;
 4be:	b741                	j	43e <printint+0x18>

00000000000004c0 <vprintf>:
}

// Print to the given fd. Only understands %d, %x, %p, %s.
void
vprintf(int fd, const char *fmt, va_list ap)
{
 4c0:	715d                	addi	sp,sp,-80
 4c2:	e486                	sd	ra,72(sp)
 4c4:	e0a2                	sd	s0,64(sp)
 4c6:	f84a                	sd	s2,48(sp)
 4c8:	0880                	addi	s0,sp,80
  char *s;
  int c, i, state;

  state = 0;
  for(i = 0; fmt[i]; i++){
 4ca:	0005c903          	lbu	s2,0(a1)
 4ce:	1a090a63          	beqz	s2,682 <vprintf+0x1c2>
 4d2:	fc26                	sd	s1,56(sp)
 4d4:	f44e                	sd	s3,40(sp)
 4d6:	f052                	sd	s4,32(sp)
 4d8:	ec56                	sd	s5,24(sp)
 4da:	e85a                	sd	s6,16(sp)
 4dc:	e45e                	sd	s7,8(sp)
 4de:	8aaa                	mv	s5,a0
 4e0:	8bb2                	mv	s7,a2
 4e2:	00158493          	addi	s1,a1,1
  state = 0;
 4e6:	4981                	li	s3,0
      if(c == '%'){
        state = '%';
      } else {
        putc(fd, c);
      }
    } else if(state == '%'){
 4e8:	02500a13          	li	s4,37
 4ec:	4b55                	li	s6,21
 4ee:	a839                	j	50c <vprintf+0x4c>
        putc(fd, c);
 4f0:	85ca                	mv	a1,s2
 4f2:	8556                	mv	a0,s5
 4f4:	00000097          	auipc	ra,0x0
 4f8:	f10080e7          	jalr	-240(ra) # 404 <putc>
 4fc:	a019                	j	502 <vprintf+0x42>
    } else if(state == '%'){
 4fe:	01498d63          	beq	s3,s4,518 <vprintf+0x58>
  for(i = 0; fmt[i]; i++){
 502:	0485                	addi	s1,s1,1
 504:	fff4c903          	lbu	s2,-1(s1)
 508:	16090763          	beqz	s2,676 <vprintf+0x1b6>
    if(state == 0){
 50c:	fe0999e3          	bnez	s3,4fe <vprintf+0x3e>
      if(c == '%'){
 510:	ff4910e3          	bne	s2,s4,4f0 <vprintf+0x30>
        state = '%';
 514:	89d2                	mv	s3,s4
 516:	b7f5                	j	502 <vprintf+0x42>
      if(c == 'd'){
 518:	13490463          	beq	s2,s4,640 <vprintf+0x180>
 51c:	f9d9079b          	addiw	a5,s2,-99
 520:	0ff7f793          	zext.b	a5,a5
 524:	12fb6763          	bltu	s6,a5,652 <vprintf+0x192>
 528:	f9d9079b          	addiw	a5,s2,-99
 52c:	0ff7f713          	zext.b	a4,a5
 530:	12eb6163          	bltu	s6,a4,652 <vprintf+0x192>
 534:	00271793          	slli	a5,a4,0x2
 538:	00000717          	auipc	a4,0x0
 53c:	5f070713          	addi	a4,a4,1520 # b28 <ithread_join+0xb2>
 540:	97ba                	add	a5,a5,a4
 542:	439c                	lw	a5,0(a5)
 544:	97ba                	add	a5,a5,a4
 546:	8782                	jr	a5
        printint(fd, va_arg(ap, int), 10, 1);
 548:	008b8913          	addi	s2,s7,8
 54c:	4685                	li	a3,1
 54e:	4629                	li	a2,10
 550:	000ba583          	lw	a1,0(s7)
 554:	8556                	mv	a0,s5
 556:	00000097          	auipc	ra,0x0
 55a:	ed0080e7          	jalr	-304(ra) # 426 <printint>
 55e:	8bca                	mv	s7,s2
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
        putc(fd, c);
      }
      state = 0;
 560:	4981                	li	s3,0
 562:	b745                	j	502 <vprintf+0x42>
        printint(fd, va_arg(ap, uint64), 10, 0);
 564:	008b8913          	addi	s2,s7,8
 568:	4681                	li	a3,0
 56a:	4629                	li	a2,10
 56c:	000ba583          	lw	a1,0(s7)
 570:	8556                	mv	a0,s5
 572:	00000097          	auipc	ra,0x0
 576:	eb4080e7          	jalr	-332(ra) # 426 <printint>
 57a:	8bca                	mv	s7,s2
      state = 0;
 57c:	4981                	li	s3,0
 57e:	b751                	j	502 <vprintf+0x42>
        printint(fd, va_arg(ap, int), 16, 0);
 580:	008b8913          	addi	s2,s7,8
 584:	4681                	li	a3,0
 586:	4641                	li	a2,16
 588:	000ba583          	lw	a1,0(s7)
 58c:	8556                	mv	a0,s5
 58e:	00000097          	auipc	ra,0x0
 592:	e98080e7          	jalr	-360(ra) # 426 <printint>
 596:	8bca                	mv	s7,s2
      state = 0;
 598:	4981                	li	s3,0
 59a:	b7a5                	j	502 <vprintf+0x42>
 59c:	e062                	sd	s8,0(sp)
        printptr(fd, va_arg(ap, uint64));
 59e:	008b8c13          	addi	s8,s7,8
 5a2:	000bb983          	ld	s3,0(s7)
  putc(fd, '0');
 5a6:	03000593          	li	a1,48
 5aa:	8556                	mv	a0,s5
 5ac:	00000097          	auipc	ra,0x0
 5b0:	e58080e7          	jalr	-424(ra) # 404 <putc>
  putc(fd, 'x');
 5b4:	07800593          	li	a1,120
 5b8:	8556                	mv	a0,s5
 5ba:	00000097          	auipc	ra,0x0
 5be:	e4a080e7          	jalr	-438(ra) # 404 <putc>
 5c2:	4941                	li	s2,16
    putc(fd, digits[x >> (sizeof(uint64) * 8 - 4)]);
 5c4:	00000b97          	auipc	s7,0x0
 5c8:	5bcb8b93          	addi	s7,s7,1468 # b80 <digits>
 5cc:	03c9d793          	srli	a5,s3,0x3c
 5d0:	97de                	add	a5,a5,s7
 5d2:	0007c583          	lbu	a1,0(a5)
 5d6:	8556                	mv	a0,s5
 5d8:	00000097          	auipc	ra,0x0
 5dc:	e2c080e7          	jalr	-468(ra) # 404 <putc>
  for (i = 0; i < (sizeof(uint64) * 2); i++, x <<= 4)
 5e0:	0992                	slli	s3,s3,0x4
 5e2:	397d                	addiw	s2,s2,-1
 5e4:	fe0914e3          	bnez	s2,5cc <vprintf+0x10c>
        printptr(fd, va_arg(ap, uint64));
 5e8:	8be2                	mv	s7,s8
      state = 0;
 5ea:	4981                	li	s3,0
 5ec:	6c02                	ld	s8,0(sp)
 5ee:	bf11                	j	502 <vprintf+0x42>
        s = va_arg(ap, char*);
 5f0:	008b8993          	addi	s3,s7,8
 5f4:	000bb903          	ld	s2,0(s7)
        if(s == 0)
 5f8:	02090163          	beqz	s2,61a <vprintf+0x15a>
        while(*s != 0){
 5fc:	00094583          	lbu	a1,0(s2)
 600:	c9a5                	beqz	a1,670 <vprintf+0x1b0>
          putc(fd, *s);
 602:	8556                	mv	a0,s5
 604:	00000097          	auipc	ra,0x0
 608:	e00080e7          	jalr	-512(ra) # 404 <putc>
          s++;
 60c:	0905                	addi	s2,s2,1
        while(*s != 0){
 60e:	00094583          	lbu	a1,0(s2)
 612:	f9e5                	bnez	a1,602 <vprintf+0x142>
        s = va_arg(ap, char*);
 614:	8bce                	mv	s7,s3
      state = 0;
 616:	4981                	li	s3,0
 618:	b5ed                	j	502 <vprintf+0x42>
          s = "(null)";
 61a:	00000917          	auipc	s2,0x0
 61e:	4d690913          	addi	s2,s2,1238 # af0 <ithread_join+0x7a>
        while(*s != 0){
 622:	02800593          	li	a1,40
 626:	bff1                	j	602 <vprintf+0x142>
        putc(fd, va_arg(ap, uint));
 628:	008b8913          	addi	s2,s7,8
 62c:	000bc583          	lbu	a1,0(s7)
 630:	8556                	mv	a0,s5
 632:	00000097          	auipc	ra,0x0
 636:	dd2080e7          	jalr	-558(ra) # 404 <putc>
 63a:	8bca                	mv	s7,s2
      state = 0;
 63c:	4981                	li	s3,0
 63e:	b5d1                	j	502 <vprintf+0x42>
        putc(fd, c);
 640:	02500593          	li	a1,37
 644:	8556                	mv	a0,s5
 646:	00000097          	auipc	ra,0x0
 64a:	dbe080e7          	jalr	-578(ra) # 404 <putc>
      state = 0;
 64e:	4981                	li	s3,0
 650:	bd4d                	j	502 <vprintf+0x42>
        putc(fd, '%');
 652:	02500593          	li	a1,37
 656:	8556                	mv	a0,s5
 658:	00000097          	auipc	ra,0x0
 65c:	dac080e7          	jalr	-596(ra) # 404 <putc>
        putc(fd, c);
 660:	85ca                	mv	a1,s2
 662:	8556                	mv	a0,s5
 664:	00000097          	auipc	ra,0x0
 668:	da0080e7          	jalr	-608(ra) # 404 <putc>
      state = 0;
 66c:	4981                	li	s3,0
 66e:	bd51                	j	502 <vprintf+0x42>
        s = va_arg(ap, char*);
 670:	8bce                	mv	s7,s3
      state = 0;
 672:	4981                	li	s3,0
 674:	b579                	j	502 <vprintf+0x42>
 676:	74e2                	ld	s1,56(sp)
 678:	79a2                	ld	s3,40(sp)
 67a:	7a02                	ld	s4,32(sp)
 67c:	6ae2                	ld	s5,24(sp)
 67e:	6b42                	ld	s6,16(sp)
 680:	6ba2                	ld	s7,8(sp)
    }
  }
}
 682:	60a6                	ld	ra,72(sp)
 684:	6406                	ld	s0,64(sp)
 686:	7942                	ld	s2,48(sp)
 688:	6161                	addi	sp,sp,80
 68a:	8082                	ret

000000000000068c <fprintf>:

void
fprintf(int fd, const char *fmt, ...)
{
 68c:	715d                	addi	sp,sp,-80
 68e:	ec06                	sd	ra,24(sp)
 690:	e822                	sd	s0,16(sp)
 692:	1000                	addi	s0,sp,32
 694:	e010                	sd	a2,0(s0)
 696:	e414                	sd	a3,8(s0)
 698:	e818                	sd	a4,16(s0)
 69a:	ec1c                	sd	a5,24(s0)
 69c:	03043023          	sd	a6,32(s0)
 6a0:	03143423          	sd	a7,40(s0)
  va_list ap;

  va_start(ap, fmt);
 6a4:	8622                	mv	a2,s0
 6a6:	fe843423          	sd	s0,-24(s0)
  vprintf(fd, fmt, ap);
 6aa:	00000097          	auipc	ra,0x0
 6ae:	e16080e7          	jalr	-490(ra) # 4c0 <vprintf>
}
 6b2:	60e2                	ld	ra,24(sp)
 6b4:	6442                	ld	s0,16(sp)
 6b6:	6161                	addi	sp,sp,80
 6b8:	8082                	ret

00000000000006ba <printf>:

void
printf(const char *fmt, ...)
{
 6ba:	711d                	addi	sp,sp,-96
 6bc:	ec06                	sd	ra,24(sp)
 6be:	e822                	sd	s0,16(sp)
 6c0:	1000                	addi	s0,sp,32
 6c2:	e40c                	sd	a1,8(s0)
 6c4:	e810                	sd	a2,16(s0)
 6c6:	ec14                	sd	a3,24(s0)
 6c8:	f018                	sd	a4,32(s0)
 6ca:	f41c                	sd	a5,40(s0)
 6cc:	03043823          	sd	a6,48(s0)
 6d0:	03143c23          	sd	a7,56(s0)
  va_list ap;

  va_start(ap, fmt);
 6d4:	00840613          	addi	a2,s0,8
 6d8:	fec43423          	sd	a2,-24(s0)
  vprintf(1, fmt, ap);
 6dc:	85aa                	mv	a1,a0
 6de:	4505                	li	a0,1
 6e0:	00000097          	auipc	ra,0x0
 6e4:	de0080e7          	jalr	-544(ra) # 4c0 <vprintf>
}
 6e8:	60e2                	ld	ra,24(sp)
 6ea:	6442                	ld	s0,16(sp)
 6ec:	6125                	addi	sp,sp,96
 6ee:	8082                	ret

00000000000006f0 <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 6f0:	1141                	addi	sp,sp,-16
 6f2:	e406                	sd	ra,8(sp)
 6f4:	e022                	sd	s0,0(sp)
 6f6:	0800                	addi	s0,sp,16
  Header *bp, *p;

  bp = (Header*)ap - 1;
 6f8:	ff050693          	addi	a3,a0,-16
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 6fc:	00001797          	auipc	a5,0x1
 700:	e147b783          	ld	a5,-492(a5) # 1510 <freep>
 704:	a02d                	j	72e <free+0x3e>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
      break;
  if(bp + bp->s.size == p->s.ptr){
    bp->s.size += p->s.ptr->s.size;
 706:	4618                	lw	a4,8(a2)
 708:	9f2d                	addw	a4,a4,a1
 70a:	fee52c23          	sw	a4,-8(a0)
    bp->s.ptr = p->s.ptr->s.ptr;
 70e:	6398                	ld	a4,0(a5)
 710:	6310                	ld	a2,0(a4)
 712:	a83d                	j	750 <free+0x60>
  } else
    bp->s.ptr = p->s.ptr;
  if(p + p->s.size == bp){
    p->s.size += bp->s.size;
 714:	ff852703          	lw	a4,-8(a0)
 718:	9f31                	addw	a4,a4,a2
 71a:	c798                	sw	a4,8(a5)
    p->s.ptr = bp->s.ptr;
 71c:	ff053683          	ld	a3,-16(a0)
 720:	a091                	j	764 <free+0x74>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 722:	6398                	ld	a4,0(a5)
 724:	00e7e463          	bltu	a5,a4,72c <free+0x3c>
 728:	00e6ea63          	bltu	a3,a4,73c <free+0x4c>
{
 72c:	87ba                	mv	a5,a4
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 72e:	fed7fae3          	bgeu	a5,a3,722 <free+0x32>
 732:	6398                	ld	a4,0(a5)
 734:	00e6e463          	bltu	a3,a4,73c <free+0x4c>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 738:	fee7eae3          	bltu	a5,a4,72c <free+0x3c>
  if(bp + bp->s.size == p->s.ptr){
 73c:	ff852583          	lw	a1,-8(a0)
 740:	6390                	ld	a2,0(a5)
 742:	02059813          	slli	a6,a1,0x20
 746:	01c85713          	srli	a4,a6,0x1c
 74a:	9736                	add	a4,a4,a3
 74c:	fae60de3          	beq	a2,a4,706 <free+0x16>
    bp->s.ptr = p->s.ptr->s.ptr;
 750:	fec53823          	sd	a2,-16(a0)
  if(p + p->s.size == bp){
 754:	4790                	lw	a2,8(a5)
 756:	02061593          	slli	a1,a2,0x20
 75a:	01c5d713          	srli	a4,a1,0x1c
 75e:	973e                	add	a4,a4,a5
 760:	fae68ae3          	beq	a3,a4,714 <free+0x24>
    p->s.ptr = bp->s.ptr;
 764:	e394                	sd	a3,0(a5)
  } else
    p->s.ptr = bp;
  freep = p;
 766:	00001717          	auipc	a4,0x1
 76a:	daf73523          	sd	a5,-598(a4) # 1510 <freep>
}
 76e:	60a2                	ld	ra,8(sp)
 770:	6402                	ld	s0,0(sp)
 772:	0141                	addi	sp,sp,16
 774:	8082                	ret

0000000000000776 <malloc>:
  return freep;
}

void*
malloc(uint nbytes)
{
 776:	7139                	addi	sp,sp,-64
 778:	fc06                	sd	ra,56(sp)
 77a:	f822                	sd	s0,48(sp)
 77c:	f04a                	sd	s2,32(sp)
 77e:	ec4e                	sd	s3,24(sp)
 780:	0080                	addi	s0,sp,64
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 782:	02051993          	slli	s3,a0,0x20
 786:	0209d993          	srli	s3,s3,0x20
 78a:	09bd                	addi	s3,s3,15
 78c:	0049d993          	srli	s3,s3,0x4
 790:	2985                	addiw	s3,s3,1
 792:	894e                	mv	s2,s3
  if((prevp = freep) == 0){
 794:	00001517          	auipc	a0,0x1
 798:	d7c53503          	ld	a0,-644(a0) # 1510 <freep>
 79c:	c905                	beqz	a0,7cc <malloc+0x56>
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 79e:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
 7a0:	4798                	lw	a4,8(a5)
 7a2:	09377a63          	bgeu	a4,s3,836 <malloc+0xc0>
 7a6:	f426                	sd	s1,40(sp)
 7a8:	e852                	sd	s4,16(sp)
 7aa:	e456                	sd	s5,8(sp)
 7ac:	e05a                	sd	s6,0(sp)
  if(nu < 4096)
 7ae:	8a4e                	mv	s4,s3
 7b0:	6705                	lui	a4,0x1
 7b2:	00e9f363          	bgeu	s3,a4,7b8 <malloc+0x42>
 7b6:	6a05                	lui	s4,0x1
 7b8:	000a0b1b          	sext.w	s6,s4
  p = sbrk(nu * sizeof(Header));
 7bc:	004a1a1b          	slliw	s4,s4,0x4
        p->s.size = nunits;
      }
      freep = prevp;
      return (void*)(p + 1);
    }
    if(p == freep)
 7c0:	00001497          	auipc	s1,0x1
 7c4:	d5048493          	addi	s1,s1,-688 # 1510 <freep>
  if(p == (char*)-1)
 7c8:	5afd                	li	s5,-1
 7ca:	a089                	j	80c <malloc+0x96>
 7cc:	f426                	sd	s1,40(sp)
 7ce:	e852                	sd	s4,16(sp)
 7d0:	e456                	sd	s5,8(sp)
 7d2:	e05a                	sd	s6,0(sp)
    base.s.ptr = freep = prevp = &base;
 7d4:	00001797          	auipc	a5,0x1
 7d8:	d5c78793          	addi	a5,a5,-676 # 1530 <base>
 7dc:	00001717          	auipc	a4,0x1
 7e0:	d2f73a23          	sd	a5,-716(a4) # 1510 <freep>
 7e4:	e39c                	sd	a5,0(a5)
    base.s.size = 0;
 7e6:	0007a423          	sw	zero,8(a5)
    if(p->s.size >= nunits){
 7ea:	b7d1                	j	7ae <malloc+0x38>
        prevp->s.ptr = p->s.ptr;
 7ec:	6398                	ld	a4,0(a5)
 7ee:	e118                	sd	a4,0(a0)
 7f0:	a8b9                	j	84e <malloc+0xd8>
  hp->s.size = nu;
 7f2:	01652423          	sw	s6,8(a0)
  free((void*)(hp + 1));
 7f6:	0541                	addi	a0,a0,16
 7f8:	00000097          	auipc	ra,0x0
 7fc:	ef8080e7          	jalr	-264(ra) # 6f0 <free>
  return freep;
 800:	6088                	ld	a0,0(s1)
      if((p = morecore(nunits)) == 0)
 802:	c135                	beqz	a0,866 <malloc+0xf0>
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 804:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
 806:	4798                	lw	a4,8(a5)
 808:	03277363          	bgeu	a4,s2,82e <malloc+0xb8>
    if(p == freep)
 80c:	6098                	ld	a4,0(s1)
 80e:	853e                	mv	a0,a5
 810:	fef71ae3          	bne	a4,a5,804 <malloc+0x8e>
  p = sbrk(nu * sizeof(Header));
 814:	8552                	mv	a0,s4
 816:	00000097          	auipc	ra,0x0
 81a:	b8e080e7          	jalr	-1138(ra) # 3a4 <sbrk>
  if(p == (char*)-1)
 81e:	fd551ae3          	bne	a0,s5,7f2 <malloc+0x7c>
        return 0;
 822:	4501                	li	a0,0
 824:	74a2                	ld	s1,40(sp)
 826:	6a42                	ld	s4,16(sp)
 828:	6aa2                	ld	s5,8(sp)
 82a:	6b02                	ld	s6,0(sp)
 82c:	a03d                	j	85a <malloc+0xe4>
 82e:	74a2                	ld	s1,40(sp)
 830:	6a42                	ld	s4,16(sp)
 832:	6aa2                	ld	s5,8(sp)
 834:	6b02                	ld	s6,0(sp)
      if(p->s.size == nunits)
 836:	fae90be3          	beq	s2,a4,7ec <malloc+0x76>
        p->s.size -= nunits;
 83a:	4137073b          	subw	a4,a4,s3
 83e:	c798                	sw	a4,8(a5)
        p += p->s.size;
 840:	02071693          	slli	a3,a4,0x20
 844:	01c6d713          	srli	a4,a3,0x1c
 848:	97ba                	add	a5,a5,a4
        p->s.size = nunits;
 84a:	0137a423          	sw	s3,8(a5)
      freep = prevp;
 84e:	00001717          	auipc	a4,0x1
 852:	cca73123          	sd	a0,-830(a4) # 1510 <freep>
      return (void*)(p + 1);
 856:	01078513          	addi	a0,a5,16
  }
}
 85a:	70e2                	ld	ra,56(sp)
 85c:	7442                	ld	s0,48(sp)
 85e:	7902                	ld	s2,32(sp)
 860:	69e2                	ld	s3,24(sp)
 862:	6121                	addi	sp,sp,64
 864:	8082                	ret
 866:	74a2                	ld	s1,40(sp)
 868:	6a42                	ld	s4,16(sp)
 86a:	6aa2                	ld	s5,8(sp)
 86c:	6b02                	ld	s6,0(sp)
 86e:	b7f5                	j	85a <malloc+0xe4>

0000000000000870 <ithread_exit>:
  free(stacks);
  stacks = new_stacks;
  return 0;
}

void ithread_exit(uint64 status) {
 870:	1141                	addi	sp,sp,-16
 872:	e406                	sd	ra,8(sp)
 874:	e022                	sd	s0,0(sp)
 876:	0800                	addi	s0,sp,16
  thread_exit(status);
 878:	2501                	sext.w	a0,a0
 87a:	00000097          	auipc	ra,0x0
 87e:	b5a080e7          	jalr	-1190(ra) # 3d4 <thread_exit>
}
 882:	60a2                	ld	ra,8(sp)
 884:	6402                	ld	s0,0(sp)
 886:	0141                	addi	sp,sp,16
 888:	8082                	ret

000000000000088a <free_stacks>:
int free_stacks() {
 88a:	7179                	addi	sp,sp,-48
 88c:	f406                	sd	ra,40(sp)
 88e:	f022                	sd	s0,32(sp)
 890:	ec26                	sd	s1,24(sp)
 892:	1800                	addi	s0,sp,48
  for (int i = 0; i < num_threads; i++) {
 894:	00001797          	auipc	a5,0x1
 898:	c8c7a783          	lw	a5,-884(a5) # 1520 <num_threads>
 89c:	04f05063          	blez	a5,8dc <free_stacks+0x52>
 8a0:	e84a                	sd	s2,16(sp)
 8a2:	e44e                	sd	s3,8(sp)
 8a4:	4481                	li	s1,0
    free(stacks[i]);
 8a6:	00001997          	auipc	s3,0x1
 8aa:	c7298993          	addi	s3,s3,-910 # 1518 <stacks>
  for (int i = 0; i < num_threads; i++) {
 8ae:	00001917          	auipc	s2,0x1
 8b2:	c7290913          	addi	s2,s2,-910 # 1520 <num_threads>
    free(stacks[i]);
 8b6:	0009b783          	ld	a5,0(s3)
 8ba:	00349713          	slli	a4,s1,0x3
 8be:	97ba                	add	a5,a5,a4
 8c0:	6388                	ld	a0,0(a5)
 8c2:	00000097          	auipc	ra,0x0
 8c6:	e2e080e7          	jalr	-466(ra) # 6f0 <free>
  for (int i = 0; i < num_threads; i++) {
 8ca:	0485                	addi	s1,s1,1
 8cc:	00092703          	lw	a4,0(s2)
 8d0:	0004879b          	sext.w	a5,s1
 8d4:	fee7c1e3          	blt	a5,a4,8b6 <free_stacks+0x2c>
 8d8:	6942                	ld	s2,16(sp)
 8da:	69a2                	ld	s3,8(sp)
  free(stacks);
 8dc:	00001497          	auipc	s1,0x1
 8e0:	c3c48493          	addi	s1,s1,-964 # 1518 <stacks>
 8e4:	6088                	ld	a0,0(s1)
 8e6:	00000097          	auipc	ra,0x0
 8ea:	e0a080e7          	jalr	-502(ra) # 6f0 <free>
  stacks = 0;
 8ee:	0004b023          	sd	zero,0(s1)
  num_threads = 0;
 8f2:	00001797          	auipc	a5,0x1
 8f6:	c207a723          	sw	zero,-978(a5) # 1520 <num_threads>
  max_stacks = INIT_MAX_STACKS;
 8fa:	47a1                	li	a5,8
 8fc:	00001717          	auipc	a4,0x1
 900:	c0f72223          	sw	a5,-1020(a4) # 1500 <max_stacks>
  threads_done = 0;
 904:	00001797          	auipc	a5,0x1
 908:	c207a023          	sw	zero,-992(a5) # 1524 <threads_done>
}
 90c:	4501                	li	a0,0
 90e:	70a2                	ld	ra,40(sp)
 910:	7402                	ld	s0,32(sp)
 912:	64e2                	ld	s1,24(sp)
 914:	6145                	addi	sp,sp,48
 916:	8082                	ret

0000000000000918 <expand_num_threads>:
int expand_num_threads() {
 918:	1101                	addi	sp,sp,-32
 91a:	ec06                	sd	ra,24(sp)
 91c:	e822                	sd	s0,16(sp)
 91e:	e426                	sd	s1,8(sp)
 920:	e04a                	sd	s2,0(sp)
 922:	1000                	addi	s0,sp,32
  max_stacks *= 2;
 924:	00001797          	auipc	a5,0x1
 928:	bdc78793          	addi	a5,a5,-1060 # 1500 <max_stacks>
 92c:	4388                	lw	a0,0(a5)
 92e:	0015151b          	slliw	a0,a0,0x1
 932:	c388                	sw	a0,0(a5)
  void **new_stacks = malloc(max_stacks*sizeof(char*));
 934:	0035151b          	slliw	a0,a0,0x3
 938:	00000097          	auipc	ra,0x0
 93c:	e3e080e7          	jalr	-450(ra) # 776 <malloc>
 940:	892a                	mv	s2,a0
  memmove(new_stacks, stacks, num_threads*sizeof(char*));
 942:	00001617          	auipc	a2,0x1
 946:	bde62603          	lw	a2,-1058(a2) # 1520 <num_threads>
 94a:	00001497          	auipc	s1,0x1
 94e:	bce48493          	addi	s1,s1,-1074 # 1518 <stacks>
 952:	0036161b          	slliw	a2,a2,0x3
 956:	608c                	ld	a1,0(s1)
 958:	00000097          	auipc	ra,0x0
 95c:	90a080e7          	jalr	-1782(ra) # 262 <memmove>
  free(stacks);
 960:	6088                	ld	a0,0(s1)
 962:	00000097          	auipc	ra,0x0
 966:	d8e080e7          	jalr	-626(ra) # 6f0 <free>
  stacks = new_stacks;
 96a:	0124b023          	sd	s2,0(s1)
}
 96e:	4501                	li	a0,0
 970:	60e2                	ld	ra,24(sp)
 972:	6442                	ld	s0,16(sp)
 974:	64a2                	ld	s1,8(sp)
 976:	6902                	ld	s2,0(sp)
 978:	6105                	addi	sp,sp,32
 97a:	8082                	ret

000000000000097c <ithread_create>:

int ithread_create(void* (*fn_ptr)(void *), void *args) {
 97c:	7179                	addi	sp,sp,-48
 97e:	f406                	sd	ra,40(sp)
 980:	f022                	sd	s0,32(sp)
 982:	e84a                	sd	s2,16(sp)
 984:	e44e                	sd	s3,8(sp)
 986:	1800                	addi	s0,sp,48
 988:	892a                	mv	s2,a0
 98a:	89ae                	mv	s3,a1
  if (stacks == 0) {
 98c:	00001797          	auipc	a5,0x1
 990:	b8c7b783          	ld	a5,-1140(a5) # 1518 <stacks>
 994:	c3d9                	beqz	a5,a1a <ithread_create+0x9e>
    stacks = malloc(max_stacks*sizeof(char*));
  }
  if (num_threads == max_stacks) {
 996:	00001797          	auipc	a5,0x1
 99a:	b6a7a783          	lw	a5,-1174(a5) # 1500 <max_stacks>
 99e:	00001717          	auipc	a4,0x1
 9a2:	b8272703          	lw	a4,-1150(a4) # 1520 <num_threads>
 9a6:	0af71363          	bne	a4,a5,a4c <ithread_create+0xd0>
    if (max_stacks == MAX_THREADS) {
 9aa:	04000713          	li	a4,64
 9ae:	08e78563          	beq	a5,a4,a38 <ithread_create+0xbc>
 9b2:	ec26                	sd	s1,24(sp)
      printf("ERROR: Thread capacity has been reached\n");
      return -1;
    }
    expand_num_threads();
 9b4:	00000097          	auipc	ra,0x0
 9b8:	f64080e7          	jalr	-156(ra) # 918 <expand_num_threads>
  }

  void *stack_ptr = malloc(PGSIZE);
 9bc:	6505                	lui	a0,0x1
 9be:	00000097          	auipc	ra,0x0
 9c2:	db8080e7          	jalr	-584(ra) # 776 <malloc>
 9c6:	84aa                	mv	s1,a0
  stacks[num_threads] = stack_ptr;
 9c8:	00001717          	auipc	a4,0x1
 9cc:	b5872703          	lw	a4,-1192(a4) # 1520 <num_threads>
 9d0:	070e                	slli	a4,a4,0x3
 9d2:	00001797          	auipc	a5,0x1
 9d6:	b467b783          	ld	a5,-1210(a5) # 1518 <stacks>
 9da:	97ba                	add	a5,a5,a4
 9dc:	e388                	sd	a0,0(a5)
  int res = create_thread(fn_ptr, args, stack_ptr, &ithread_exit);
 9de:	00000697          	auipc	a3,0x0
 9e2:	e9268693          	addi	a3,a3,-366 # 870 <ithread_exit>
 9e6:	862a                	mv	a2,a0
 9e8:	85ce                	mv	a1,s3
 9ea:	854a                	mv	a0,s2
 9ec:	00000097          	auipc	ra,0x0
 9f0:	9d8080e7          	jalr	-1576(ra) # 3c4 <create_thread>
 9f4:	892a                	mv	s2,a0
  if (res != -1) {
 9f6:	57fd                	li	a5,-1
 9f8:	04f50c63          	beq	a0,a5,a50 <ithread_create+0xd4>
    num_threads++;
 9fc:	00001717          	auipc	a4,0x1
 a00:	b2470713          	addi	a4,a4,-1244 # 1520 <num_threads>
 a04:	431c                	lw	a5,0(a4)
 a06:	2785                	addiw	a5,a5,1
 a08:	c31c                	sw	a5,0(a4)
 a0a:	64e2                	ld	s1,24(sp)
  } else {
    free(stack_ptr);
    stacks[num_threads] = 0;
  }
  return res;
}
 a0c:	854a                	mv	a0,s2
 a0e:	70a2                	ld	ra,40(sp)
 a10:	7402                	ld	s0,32(sp)
 a12:	6942                	ld	s2,16(sp)
 a14:	69a2                	ld	s3,8(sp)
 a16:	6145                	addi	sp,sp,48
 a18:	8082                	ret
    stacks = malloc(max_stacks*sizeof(char*));
 a1a:	00001517          	auipc	a0,0x1
 a1e:	ae652503          	lw	a0,-1306(a0) # 1500 <max_stacks>
 a22:	0035151b          	slliw	a0,a0,0x3
 a26:	00000097          	auipc	ra,0x0
 a2a:	d50080e7          	jalr	-688(ra) # 776 <malloc>
 a2e:	00001797          	auipc	a5,0x1
 a32:	aea7b523          	sd	a0,-1302(a5) # 1518 <stacks>
 a36:	b785                	j	996 <ithread_create+0x1a>
      printf("ERROR: Thread capacity has been reached\n");
 a38:	00000517          	auipc	a0,0x0
 a3c:	0c050513          	addi	a0,a0,192 # af8 <ithread_join+0x82>
 a40:	00000097          	auipc	ra,0x0
 a44:	c7a080e7          	jalr	-902(ra) # 6ba <printf>
      return -1;
 a48:	597d                	li	s2,-1
 a4a:	b7c9                	j	a0c <ithread_create+0x90>
 a4c:	ec26                	sd	s1,24(sp)
 a4e:	b7bd                	j	9bc <ithread_create+0x40>
    free(stack_ptr);
 a50:	8526                	mv	a0,s1
 a52:	00000097          	auipc	ra,0x0
 a56:	c9e080e7          	jalr	-866(ra) # 6f0 <free>
    stacks[num_threads] = 0;
 a5a:	00001717          	auipc	a4,0x1
 a5e:	ac672703          	lw	a4,-1338(a4) # 1520 <num_threads>
 a62:	070e                	slli	a4,a4,0x3
 a64:	00001797          	auipc	a5,0x1
 a68:	ab47b783          	ld	a5,-1356(a5) # 1518 <stacks>
 a6c:	97ba                	add	a5,a5,a4
 a6e:	0007b023          	sd	zero,0(a5)
 a72:	64e2                	ld	s1,24(sp)
 a74:	bf61                	j	a0c <ithread_create+0x90>

0000000000000a76 <ithread_join>:

int ithread_join(int thread_id) {
 a76:	1101                	addi	sp,sp,-32
 a78:	ec06                	sd	ra,24(sp)
 a7a:	e822                	sd	s0,16(sp)
 a7c:	1000                	addi	s0,sp,32
  int status;
  join_thread(thread_id, (uint64)&status);
 a7e:	ff040793          	addi	a5,s0,-16
 a82:	ffc7859b          	addiw	a1,a5,-4
 a86:	00000097          	auipc	ra,0x0
 a8a:	946080e7          	jalr	-1722(ra) # 3cc <join_thread>
  threads_done++;
 a8e:	00001717          	auipc	a4,0x1
 a92:	a9670713          	addi	a4,a4,-1386 # 1524 <threads_done>
 a96:	431c                	lw	a5,0(a4)
 a98:	2785                	addiw	a5,a5,1
 a9a:	c31c                	sw	a5,0(a4)
  if (threads_done == num_threads) {
 a9c:	00001717          	auipc	a4,0x1
 aa0:	a8472703          	lw	a4,-1404(a4) # 1520 <num_threads>
 aa4:	00f70863          	beq	a4,a5,ab4 <ithread_join+0x3e>
    free_stacks();
  }
  return status;
}
 aa8:	fec42503          	lw	a0,-20(s0)
 aac:	60e2                	ld	ra,24(sp)
 aae:	6442                	ld	s0,16(sp)
 ab0:	6105                	addi	sp,sp,32
 ab2:	8082                	ret
    free_stacks();
 ab4:	00000097          	auipc	ra,0x0
 ab8:	dd6080e7          	jalr	-554(ra) # 88a <free_stacks>
 abc:	b7f5                	j	aa8 <ithread_join+0x32>
