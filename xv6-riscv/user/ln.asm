
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
  14:	ae058593          	addi	a1,a1,-1312 # af0 <ithread_join+0x54>
  18:	4509                	li	a0,2
  1a:	00000097          	auipc	ra,0x0
  1e:	698080e7          	jalr	1688(ra) # 6b2 <fprintf>
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
  52:	aba58593          	addi	a1,a1,-1350 # b08 <ithread_join+0x6c>
  56:	4509                	li	a0,2
  58:	00000097          	auipc	ra,0x0
  5c:	65a080e7          	jalr	1626(ra) # 6b2 <fprintf>
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

0000000000000404 <send>:
.global send
send:
 li a7, SYS_send
 404:	48fd                	li	a7,31
 ecall
 406:	00000073          	ecall
 ret
 40a:	8082                	ret

000000000000040c <recv>:
.global recv
recv:
 li a7, SYS_recv
 40c:	02000893          	li	a7,32
 ecall
 410:	00000073          	ecall
 ret
 414:	8082                	ret

0000000000000416 <sendto>:
.global sendto
sendto:
 li a7, SYS_sendto
 416:	02100893          	li	a7,33
 ecall
 41a:	00000073          	ecall
 ret
 41e:	8082                	ret

0000000000000420 <recvfrom>:
.global recvfrom
recvfrom:
 li a7, SYS_recvfrom
 420:	02200893          	li	a7,34
 ecall
 424:	00000073          	ecall
 ret
 428:	8082                	ret

000000000000042a <putc>:

static char digits[] = "0123456789ABCDEF";

static void
putc(int fd, char c)
{
 42a:	1101                	addi	sp,sp,-32
 42c:	ec06                	sd	ra,24(sp)
 42e:	e822                	sd	s0,16(sp)
 430:	1000                	addi	s0,sp,32
 432:	feb407a3          	sb	a1,-17(s0)
  write(fd, &c, 1);
 436:	4605                	li	a2,1
 438:	fef40593          	addi	a1,s0,-17
 43c:	00000097          	auipc	ra,0x0
 440:	f00080e7          	jalr	-256(ra) # 33c <write>
}
 444:	60e2                	ld	ra,24(sp)
 446:	6442                	ld	s0,16(sp)
 448:	6105                	addi	sp,sp,32
 44a:	8082                	ret

000000000000044c <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
 44c:	7139                	addi	sp,sp,-64
 44e:	fc06                	sd	ra,56(sp)
 450:	f822                	sd	s0,48(sp)
 452:	f426                	sd	s1,40(sp)
 454:	f04a                	sd	s2,32(sp)
 456:	ec4e                	sd	s3,24(sp)
 458:	0080                	addi	s0,sp,64
 45a:	892a                	mv	s2,a0
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
  if(sgn && xx < 0){
 45c:	c299                	beqz	a3,462 <printint+0x16>
 45e:	0805c063          	bltz	a1,4de <printint+0x92>
  neg = 0;
 462:	4e01                	li	t3,0
    x = -xx;
  } else {
    x = xx;
  }

  i = 0;
 464:	fc040313          	addi	t1,s0,-64
  neg = 0;
 468:	869a                	mv	a3,t1
  i = 0;
 46a:	4781                	li	a5,0
  do{
    buf[i++] = digits[x % base];
 46c:	00000817          	auipc	a6,0x0
 470:	74480813          	addi	a6,a6,1860 # bb0 <digits>
 474:	88be                	mv	a7,a5
 476:	0017851b          	addiw	a0,a5,1
 47a:	87aa                	mv	a5,a0
 47c:	02c5f73b          	remuw	a4,a1,a2
 480:	1702                	slli	a4,a4,0x20
 482:	9301                	srli	a4,a4,0x20
 484:	9742                	add	a4,a4,a6
 486:	00074703          	lbu	a4,0(a4)
 48a:	00e68023          	sb	a4,0(a3)
  }while((x /= base) != 0);
 48e:	872e                	mv	a4,a1
 490:	02c5d5bb          	divuw	a1,a1,a2
 494:	0685                	addi	a3,a3,1
 496:	fcc77fe3          	bgeu	a4,a2,474 <printint+0x28>
  if(neg)
 49a:	000e0c63          	beqz	t3,4b2 <printint+0x66>
    buf[i++] = '-';
 49e:	fd050793          	addi	a5,a0,-48
 4a2:	00878533          	add	a0,a5,s0
 4a6:	02d00793          	li	a5,45
 4aa:	fef50823          	sb	a5,-16(a0)
 4ae:	0028879b          	addiw	a5,a7,2

  while(--i >= 0)
 4b2:	fff7899b          	addiw	s3,a5,-1
 4b6:	006784b3          	add	s1,a5,t1
    putc(fd, buf[i]);
 4ba:	fff4c583          	lbu	a1,-1(s1)
 4be:	854a                	mv	a0,s2
 4c0:	00000097          	auipc	ra,0x0
 4c4:	f6a080e7          	jalr	-150(ra) # 42a <putc>
  while(--i >= 0)
 4c8:	39fd                	addiw	s3,s3,-1
 4ca:	14fd                	addi	s1,s1,-1
 4cc:	fe09d7e3          	bgez	s3,4ba <printint+0x6e>
}
 4d0:	70e2                	ld	ra,56(sp)
 4d2:	7442                	ld	s0,48(sp)
 4d4:	74a2                	ld	s1,40(sp)
 4d6:	7902                	ld	s2,32(sp)
 4d8:	69e2                	ld	s3,24(sp)
 4da:	6121                	addi	sp,sp,64
 4dc:	8082                	ret
    x = -xx;
 4de:	40b005bb          	negw	a1,a1
    neg = 1;
 4e2:	4e05                	li	t3,1
    x = -xx;
 4e4:	b741                	j	464 <printint+0x18>

00000000000004e6 <vprintf>:
}

// Print to the given fd. Only understands %d, %x, %p, %s.
void
vprintf(int fd, const char *fmt, va_list ap)
{
 4e6:	715d                	addi	sp,sp,-80
 4e8:	e486                	sd	ra,72(sp)
 4ea:	e0a2                	sd	s0,64(sp)
 4ec:	f84a                	sd	s2,48(sp)
 4ee:	0880                	addi	s0,sp,80
  char *s;
  int c, i, state;

  state = 0;
  for(i = 0; fmt[i]; i++){
 4f0:	0005c903          	lbu	s2,0(a1)
 4f4:	1a090a63          	beqz	s2,6a8 <vprintf+0x1c2>
 4f8:	fc26                	sd	s1,56(sp)
 4fa:	f44e                	sd	s3,40(sp)
 4fc:	f052                	sd	s4,32(sp)
 4fe:	ec56                	sd	s5,24(sp)
 500:	e85a                	sd	s6,16(sp)
 502:	e45e                	sd	s7,8(sp)
 504:	8aaa                	mv	s5,a0
 506:	8bb2                	mv	s7,a2
 508:	00158493          	addi	s1,a1,1
  state = 0;
 50c:	4981                	li	s3,0
      if(c == '%'){
        state = '%';
      } else {
        putc(fd, c);
      }
    } else if(state == '%'){
 50e:	02500a13          	li	s4,37
 512:	4b55                	li	s6,21
 514:	a839                	j	532 <vprintf+0x4c>
        putc(fd, c);
 516:	85ca                	mv	a1,s2
 518:	8556                	mv	a0,s5
 51a:	00000097          	auipc	ra,0x0
 51e:	f10080e7          	jalr	-240(ra) # 42a <putc>
 522:	a019                	j	528 <vprintf+0x42>
    } else if(state == '%'){
 524:	01498d63          	beq	s3,s4,53e <vprintf+0x58>
  for(i = 0; fmt[i]; i++){
 528:	0485                	addi	s1,s1,1
 52a:	fff4c903          	lbu	s2,-1(s1)
 52e:	16090763          	beqz	s2,69c <vprintf+0x1b6>
    if(state == 0){
 532:	fe0999e3          	bnez	s3,524 <vprintf+0x3e>
      if(c == '%'){
 536:	ff4910e3          	bne	s2,s4,516 <vprintf+0x30>
        state = '%';
 53a:	89d2                	mv	s3,s4
 53c:	b7f5                	j	528 <vprintf+0x42>
      if(c == 'd'){
 53e:	13490463          	beq	s2,s4,666 <vprintf+0x180>
 542:	f9d9079b          	addiw	a5,s2,-99
 546:	0ff7f793          	zext.b	a5,a5
 54a:	12fb6763          	bltu	s6,a5,678 <vprintf+0x192>
 54e:	f9d9079b          	addiw	a5,s2,-99
 552:	0ff7f713          	zext.b	a4,a5
 556:	12eb6163          	bltu	s6,a4,678 <vprintf+0x192>
 55a:	00271793          	slli	a5,a4,0x2
 55e:	00000717          	auipc	a4,0x0
 562:	5fa70713          	addi	a4,a4,1530 # b58 <ithread_join+0xbc>
 566:	97ba                	add	a5,a5,a4
 568:	439c                	lw	a5,0(a5)
 56a:	97ba                	add	a5,a5,a4
 56c:	8782                	jr	a5
        printint(fd, va_arg(ap, int), 10, 1);
 56e:	008b8913          	addi	s2,s7,8
 572:	4685                	li	a3,1
 574:	4629                	li	a2,10
 576:	000ba583          	lw	a1,0(s7)
 57a:	8556                	mv	a0,s5
 57c:	00000097          	auipc	ra,0x0
 580:	ed0080e7          	jalr	-304(ra) # 44c <printint>
 584:	8bca                	mv	s7,s2
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
        putc(fd, c);
      }
      state = 0;
 586:	4981                	li	s3,0
 588:	b745                	j	528 <vprintf+0x42>
        printint(fd, va_arg(ap, uint64), 10, 0);
 58a:	008b8913          	addi	s2,s7,8
 58e:	4681                	li	a3,0
 590:	4629                	li	a2,10
 592:	000ba583          	lw	a1,0(s7)
 596:	8556                	mv	a0,s5
 598:	00000097          	auipc	ra,0x0
 59c:	eb4080e7          	jalr	-332(ra) # 44c <printint>
 5a0:	8bca                	mv	s7,s2
      state = 0;
 5a2:	4981                	li	s3,0
 5a4:	b751                	j	528 <vprintf+0x42>
        printint(fd, va_arg(ap, int), 16, 0);
 5a6:	008b8913          	addi	s2,s7,8
 5aa:	4681                	li	a3,0
 5ac:	4641                	li	a2,16
 5ae:	000ba583          	lw	a1,0(s7)
 5b2:	8556                	mv	a0,s5
 5b4:	00000097          	auipc	ra,0x0
 5b8:	e98080e7          	jalr	-360(ra) # 44c <printint>
 5bc:	8bca                	mv	s7,s2
      state = 0;
 5be:	4981                	li	s3,0
 5c0:	b7a5                	j	528 <vprintf+0x42>
 5c2:	e062                	sd	s8,0(sp)
        printptr(fd, va_arg(ap, uint64));
 5c4:	008b8c13          	addi	s8,s7,8
 5c8:	000bb983          	ld	s3,0(s7)
  putc(fd, '0');
 5cc:	03000593          	li	a1,48
 5d0:	8556                	mv	a0,s5
 5d2:	00000097          	auipc	ra,0x0
 5d6:	e58080e7          	jalr	-424(ra) # 42a <putc>
  putc(fd, 'x');
 5da:	07800593          	li	a1,120
 5de:	8556                	mv	a0,s5
 5e0:	00000097          	auipc	ra,0x0
 5e4:	e4a080e7          	jalr	-438(ra) # 42a <putc>
 5e8:	4941                	li	s2,16
    putc(fd, digits[x >> (sizeof(uint64) * 8 - 4)]);
 5ea:	00000b97          	auipc	s7,0x0
 5ee:	5c6b8b93          	addi	s7,s7,1478 # bb0 <digits>
 5f2:	03c9d793          	srli	a5,s3,0x3c
 5f6:	97de                	add	a5,a5,s7
 5f8:	0007c583          	lbu	a1,0(a5)
 5fc:	8556                	mv	a0,s5
 5fe:	00000097          	auipc	ra,0x0
 602:	e2c080e7          	jalr	-468(ra) # 42a <putc>
  for (i = 0; i < (sizeof(uint64) * 2); i++, x <<= 4)
 606:	0992                	slli	s3,s3,0x4
 608:	397d                	addiw	s2,s2,-1
 60a:	fe0914e3          	bnez	s2,5f2 <vprintf+0x10c>
        printptr(fd, va_arg(ap, uint64));
 60e:	8be2                	mv	s7,s8
      state = 0;
 610:	4981                	li	s3,0
 612:	6c02                	ld	s8,0(sp)
 614:	bf11                	j	528 <vprintf+0x42>
        s = va_arg(ap, char*);
 616:	008b8993          	addi	s3,s7,8
 61a:	000bb903          	ld	s2,0(s7)
        if(s == 0)
 61e:	02090163          	beqz	s2,640 <vprintf+0x15a>
        while(*s != 0){
 622:	00094583          	lbu	a1,0(s2)
 626:	c9a5                	beqz	a1,696 <vprintf+0x1b0>
          putc(fd, *s);
 628:	8556                	mv	a0,s5
 62a:	00000097          	auipc	ra,0x0
 62e:	e00080e7          	jalr	-512(ra) # 42a <putc>
          s++;
 632:	0905                	addi	s2,s2,1
        while(*s != 0){
 634:	00094583          	lbu	a1,0(s2)
 638:	f9e5                	bnez	a1,628 <vprintf+0x142>
        s = va_arg(ap, char*);
 63a:	8bce                	mv	s7,s3
      state = 0;
 63c:	4981                	li	s3,0
 63e:	b5ed                	j	528 <vprintf+0x42>
          s = "(null)";
 640:	00000917          	auipc	s2,0x0
 644:	4e090913          	addi	s2,s2,1248 # b20 <ithread_join+0x84>
        while(*s != 0){
 648:	02800593          	li	a1,40
 64c:	bff1                	j	628 <vprintf+0x142>
        putc(fd, va_arg(ap, uint));
 64e:	008b8913          	addi	s2,s7,8
 652:	000bc583          	lbu	a1,0(s7)
 656:	8556                	mv	a0,s5
 658:	00000097          	auipc	ra,0x0
 65c:	dd2080e7          	jalr	-558(ra) # 42a <putc>
 660:	8bca                	mv	s7,s2
      state = 0;
 662:	4981                	li	s3,0
 664:	b5d1                	j	528 <vprintf+0x42>
        putc(fd, c);
 666:	02500593          	li	a1,37
 66a:	8556                	mv	a0,s5
 66c:	00000097          	auipc	ra,0x0
 670:	dbe080e7          	jalr	-578(ra) # 42a <putc>
      state = 0;
 674:	4981                	li	s3,0
 676:	bd4d                	j	528 <vprintf+0x42>
        putc(fd, '%');
 678:	02500593          	li	a1,37
 67c:	8556                	mv	a0,s5
 67e:	00000097          	auipc	ra,0x0
 682:	dac080e7          	jalr	-596(ra) # 42a <putc>
        putc(fd, c);
 686:	85ca                	mv	a1,s2
 688:	8556                	mv	a0,s5
 68a:	00000097          	auipc	ra,0x0
 68e:	da0080e7          	jalr	-608(ra) # 42a <putc>
      state = 0;
 692:	4981                	li	s3,0
 694:	bd51                	j	528 <vprintf+0x42>
        s = va_arg(ap, char*);
 696:	8bce                	mv	s7,s3
      state = 0;
 698:	4981                	li	s3,0
 69a:	b579                	j	528 <vprintf+0x42>
 69c:	74e2                	ld	s1,56(sp)
 69e:	79a2                	ld	s3,40(sp)
 6a0:	7a02                	ld	s4,32(sp)
 6a2:	6ae2                	ld	s5,24(sp)
 6a4:	6b42                	ld	s6,16(sp)
 6a6:	6ba2                	ld	s7,8(sp)
    }
  }
}
 6a8:	60a6                	ld	ra,72(sp)
 6aa:	6406                	ld	s0,64(sp)
 6ac:	7942                	ld	s2,48(sp)
 6ae:	6161                	addi	sp,sp,80
 6b0:	8082                	ret

00000000000006b2 <fprintf>:

void
fprintf(int fd, const char *fmt, ...)
{
 6b2:	715d                	addi	sp,sp,-80
 6b4:	ec06                	sd	ra,24(sp)
 6b6:	e822                	sd	s0,16(sp)
 6b8:	1000                	addi	s0,sp,32
 6ba:	e010                	sd	a2,0(s0)
 6bc:	e414                	sd	a3,8(s0)
 6be:	e818                	sd	a4,16(s0)
 6c0:	ec1c                	sd	a5,24(s0)
 6c2:	03043023          	sd	a6,32(s0)
 6c6:	03143423          	sd	a7,40(s0)
  va_list ap;

  va_start(ap, fmt);
 6ca:	8622                	mv	a2,s0
 6cc:	fe843423          	sd	s0,-24(s0)
  vprintf(fd, fmt, ap);
 6d0:	00000097          	auipc	ra,0x0
 6d4:	e16080e7          	jalr	-490(ra) # 4e6 <vprintf>
}
 6d8:	60e2                	ld	ra,24(sp)
 6da:	6442                	ld	s0,16(sp)
 6dc:	6161                	addi	sp,sp,80
 6de:	8082                	ret

00000000000006e0 <printf>:

void
printf(const char *fmt, ...)
{
 6e0:	711d                	addi	sp,sp,-96
 6e2:	ec06                	sd	ra,24(sp)
 6e4:	e822                	sd	s0,16(sp)
 6e6:	1000                	addi	s0,sp,32
 6e8:	e40c                	sd	a1,8(s0)
 6ea:	e810                	sd	a2,16(s0)
 6ec:	ec14                	sd	a3,24(s0)
 6ee:	f018                	sd	a4,32(s0)
 6f0:	f41c                	sd	a5,40(s0)
 6f2:	03043823          	sd	a6,48(s0)
 6f6:	03143c23          	sd	a7,56(s0)
  va_list ap;

  va_start(ap, fmt);
 6fa:	00840613          	addi	a2,s0,8
 6fe:	fec43423          	sd	a2,-24(s0)
  vprintf(1, fmt, ap);
 702:	85aa                	mv	a1,a0
 704:	4505                	li	a0,1
 706:	00000097          	auipc	ra,0x0
 70a:	de0080e7          	jalr	-544(ra) # 4e6 <vprintf>
}
 70e:	60e2                	ld	ra,24(sp)
 710:	6442                	ld	s0,16(sp)
 712:	6125                	addi	sp,sp,96
 714:	8082                	ret

0000000000000716 <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 716:	1141                	addi	sp,sp,-16
 718:	e406                	sd	ra,8(sp)
 71a:	e022                	sd	s0,0(sp)
 71c:	0800                	addi	s0,sp,16
  Header *bp, *p;

  bp = (Header*)ap - 1;
 71e:	ff050693          	addi	a3,a0,-16
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 722:	00001797          	auipc	a5,0x1
 726:	dee7b783          	ld	a5,-530(a5) # 1510 <freep>
 72a:	a02d                	j	754 <free+0x3e>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
      break;
  if(bp + bp->s.size == p->s.ptr){
    bp->s.size += p->s.ptr->s.size;
 72c:	4618                	lw	a4,8(a2)
 72e:	9f2d                	addw	a4,a4,a1
 730:	fee52c23          	sw	a4,-8(a0)
    bp->s.ptr = p->s.ptr->s.ptr;
 734:	6398                	ld	a4,0(a5)
 736:	6310                	ld	a2,0(a4)
 738:	a83d                	j	776 <free+0x60>
  } else
    bp->s.ptr = p->s.ptr;
  if(p + p->s.size == bp){
    p->s.size += bp->s.size;
 73a:	ff852703          	lw	a4,-8(a0)
 73e:	9f31                	addw	a4,a4,a2
 740:	c798                	sw	a4,8(a5)
    p->s.ptr = bp->s.ptr;
 742:	ff053683          	ld	a3,-16(a0)
 746:	a091                	j	78a <free+0x74>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 748:	6398                	ld	a4,0(a5)
 74a:	00e7e463          	bltu	a5,a4,752 <free+0x3c>
 74e:	00e6ea63          	bltu	a3,a4,762 <free+0x4c>
{
 752:	87ba                	mv	a5,a4
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 754:	fed7fae3          	bgeu	a5,a3,748 <free+0x32>
 758:	6398                	ld	a4,0(a5)
 75a:	00e6e463          	bltu	a3,a4,762 <free+0x4c>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 75e:	fee7eae3          	bltu	a5,a4,752 <free+0x3c>
  if(bp + bp->s.size == p->s.ptr){
 762:	ff852583          	lw	a1,-8(a0)
 766:	6390                	ld	a2,0(a5)
 768:	02059813          	slli	a6,a1,0x20
 76c:	01c85713          	srli	a4,a6,0x1c
 770:	9736                	add	a4,a4,a3
 772:	fae60de3          	beq	a2,a4,72c <free+0x16>
    bp->s.ptr = p->s.ptr->s.ptr;
 776:	fec53823          	sd	a2,-16(a0)
  if(p + p->s.size == bp){
 77a:	4790                	lw	a2,8(a5)
 77c:	02061593          	slli	a1,a2,0x20
 780:	01c5d713          	srli	a4,a1,0x1c
 784:	973e                	add	a4,a4,a5
 786:	fae68ae3          	beq	a3,a4,73a <free+0x24>
    p->s.ptr = bp->s.ptr;
 78a:	e394                	sd	a3,0(a5)
  } else
    p->s.ptr = bp;
  freep = p;
 78c:	00001717          	auipc	a4,0x1
 790:	d8f73223          	sd	a5,-636(a4) # 1510 <freep>
}
 794:	60a2                	ld	ra,8(sp)
 796:	6402                	ld	s0,0(sp)
 798:	0141                	addi	sp,sp,16
 79a:	8082                	ret

000000000000079c <malloc>:
  return freep;
}

void*
malloc(uint nbytes)
{
 79c:	7139                	addi	sp,sp,-64
 79e:	fc06                	sd	ra,56(sp)
 7a0:	f822                	sd	s0,48(sp)
 7a2:	f04a                	sd	s2,32(sp)
 7a4:	ec4e                	sd	s3,24(sp)
 7a6:	0080                	addi	s0,sp,64
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 7a8:	02051993          	slli	s3,a0,0x20
 7ac:	0209d993          	srli	s3,s3,0x20
 7b0:	09bd                	addi	s3,s3,15
 7b2:	0049d993          	srli	s3,s3,0x4
 7b6:	2985                	addiw	s3,s3,1
 7b8:	894e                	mv	s2,s3
  if((prevp = freep) == 0){
 7ba:	00001517          	auipc	a0,0x1
 7be:	d5653503          	ld	a0,-682(a0) # 1510 <freep>
 7c2:	c905                	beqz	a0,7f2 <malloc+0x56>
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 7c4:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
 7c6:	4798                	lw	a4,8(a5)
 7c8:	09377a63          	bgeu	a4,s3,85c <malloc+0xc0>
 7cc:	f426                	sd	s1,40(sp)
 7ce:	e852                	sd	s4,16(sp)
 7d0:	e456                	sd	s5,8(sp)
 7d2:	e05a                	sd	s6,0(sp)
  if(nu < 4096)
 7d4:	8a4e                	mv	s4,s3
 7d6:	6705                	lui	a4,0x1
 7d8:	00e9f363          	bgeu	s3,a4,7de <malloc+0x42>
 7dc:	6a05                	lui	s4,0x1
 7de:	000a0b1b          	sext.w	s6,s4
  p = sbrk(nu * sizeof(Header));
 7e2:	004a1a1b          	slliw	s4,s4,0x4
        p->s.size = nunits;
      }
      freep = prevp;
      return (void*)(p + 1);
    }
    if(p == freep)
 7e6:	00001497          	auipc	s1,0x1
 7ea:	d2a48493          	addi	s1,s1,-726 # 1510 <freep>
  if(p == (char*)-1)
 7ee:	5afd                	li	s5,-1
 7f0:	a089                	j	832 <malloc+0x96>
 7f2:	f426                	sd	s1,40(sp)
 7f4:	e852                	sd	s4,16(sp)
 7f6:	e456                	sd	s5,8(sp)
 7f8:	e05a                	sd	s6,0(sp)
    base.s.ptr = freep = prevp = &base;
 7fa:	00001797          	auipc	a5,0x1
 7fe:	d3678793          	addi	a5,a5,-714 # 1530 <base>
 802:	00001717          	auipc	a4,0x1
 806:	d0f73723          	sd	a5,-754(a4) # 1510 <freep>
 80a:	e39c                	sd	a5,0(a5)
    base.s.size = 0;
 80c:	0007a423          	sw	zero,8(a5)
    if(p->s.size >= nunits){
 810:	b7d1                	j	7d4 <malloc+0x38>
        prevp->s.ptr = p->s.ptr;
 812:	6398                	ld	a4,0(a5)
 814:	e118                	sd	a4,0(a0)
 816:	a8b9                	j	874 <malloc+0xd8>
  hp->s.size = nu;
 818:	01652423          	sw	s6,8(a0)
  free((void*)(hp + 1));
 81c:	0541                	addi	a0,a0,16
 81e:	00000097          	auipc	ra,0x0
 822:	ef8080e7          	jalr	-264(ra) # 716 <free>
  return freep;
 826:	6088                	ld	a0,0(s1)
      if((p = morecore(nunits)) == 0)
 828:	c135                	beqz	a0,88c <malloc+0xf0>
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 82a:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
 82c:	4798                	lw	a4,8(a5)
 82e:	03277363          	bgeu	a4,s2,854 <malloc+0xb8>
    if(p == freep)
 832:	6098                	ld	a4,0(s1)
 834:	853e                	mv	a0,a5
 836:	fef71ae3          	bne	a4,a5,82a <malloc+0x8e>
  p = sbrk(nu * sizeof(Header));
 83a:	8552                	mv	a0,s4
 83c:	00000097          	auipc	ra,0x0
 840:	b68080e7          	jalr	-1176(ra) # 3a4 <sbrk>
  if(p == (char*)-1)
 844:	fd551ae3          	bne	a0,s5,818 <malloc+0x7c>
        return 0;
 848:	4501                	li	a0,0
 84a:	74a2                	ld	s1,40(sp)
 84c:	6a42                	ld	s4,16(sp)
 84e:	6aa2                	ld	s5,8(sp)
 850:	6b02                	ld	s6,0(sp)
 852:	a03d                	j	880 <malloc+0xe4>
 854:	74a2                	ld	s1,40(sp)
 856:	6a42                	ld	s4,16(sp)
 858:	6aa2                	ld	s5,8(sp)
 85a:	6b02                	ld	s6,0(sp)
      if(p->s.size == nunits)
 85c:	fae90be3          	beq	s2,a4,812 <malloc+0x76>
        p->s.size -= nunits;
 860:	4137073b          	subw	a4,a4,s3
 864:	c798                	sw	a4,8(a5)
        p += p->s.size;
 866:	02071693          	slli	a3,a4,0x20
 86a:	01c6d713          	srli	a4,a3,0x1c
 86e:	97ba                	add	a5,a5,a4
        p->s.size = nunits;
 870:	0137a423          	sw	s3,8(a5)
      freep = prevp;
 874:	00001717          	auipc	a4,0x1
 878:	c8a73e23          	sd	a0,-868(a4) # 1510 <freep>
      return (void*)(p + 1);
 87c:	01078513          	addi	a0,a5,16
  }
}
 880:	70e2                	ld	ra,56(sp)
 882:	7442                	ld	s0,48(sp)
 884:	7902                	ld	s2,32(sp)
 886:	69e2                	ld	s3,24(sp)
 888:	6121                	addi	sp,sp,64
 88a:	8082                	ret
 88c:	74a2                	ld	s1,40(sp)
 88e:	6a42                	ld	s4,16(sp)
 890:	6aa2                	ld	s5,8(sp)
 892:	6b02                	ld	s6,0(sp)
 894:	b7f5                	j	880 <malloc+0xe4>

0000000000000896 <ithread_exit>:
  free(stacks);
  stacks = new_stacks;
  return 0;
}

void ithread_exit(uint64 status) {
 896:	1141                	addi	sp,sp,-16
 898:	e406                	sd	ra,8(sp)
 89a:	e022                	sd	s0,0(sp)
 89c:	0800                	addi	s0,sp,16
  thread_exit(status);
 89e:	2501                	sext.w	a0,a0
 8a0:	00000097          	auipc	ra,0x0
 8a4:	b34080e7          	jalr	-1228(ra) # 3d4 <thread_exit>
}
 8a8:	60a2                	ld	ra,8(sp)
 8aa:	6402                	ld	s0,0(sp)
 8ac:	0141                	addi	sp,sp,16
 8ae:	8082                	ret

00000000000008b0 <free_stacks>:
int free_stacks() {
 8b0:	7179                	addi	sp,sp,-48
 8b2:	f406                	sd	ra,40(sp)
 8b4:	f022                	sd	s0,32(sp)
 8b6:	ec26                	sd	s1,24(sp)
 8b8:	1800                	addi	s0,sp,48
  for (int i = 0; i < num_threads; i++) {
 8ba:	00001797          	auipc	a5,0x1
 8be:	c667a783          	lw	a5,-922(a5) # 1520 <num_threads>
 8c2:	04f05063          	blez	a5,902 <free_stacks+0x52>
 8c6:	e84a                	sd	s2,16(sp)
 8c8:	e44e                	sd	s3,8(sp)
 8ca:	4481                	li	s1,0
    free(stacks[i]);
 8cc:	00001997          	auipc	s3,0x1
 8d0:	c4c98993          	addi	s3,s3,-948 # 1518 <stacks>
  for (int i = 0; i < num_threads; i++) {
 8d4:	00001917          	auipc	s2,0x1
 8d8:	c4c90913          	addi	s2,s2,-948 # 1520 <num_threads>
    free(stacks[i]);
 8dc:	0009b783          	ld	a5,0(s3)
 8e0:	00349713          	slli	a4,s1,0x3
 8e4:	97ba                	add	a5,a5,a4
 8e6:	6388                	ld	a0,0(a5)
 8e8:	00000097          	auipc	ra,0x0
 8ec:	e2e080e7          	jalr	-466(ra) # 716 <free>
  for (int i = 0; i < num_threads; i++) {
 8f0:	0485                	addi	s1,s1,1
 8f2:	00092703          	lw	a4,0(s2)
 8f6:	0004879b          	sext.w	a5,s1
 8fa:	fee7c1e3          	blt	a5,a4,8dc <free_stacks+0x2c>
 8fe:	6942                	ld	s2,16(sp)
 900:	69a2                	ld	s3,8(sp)
  free(stacks);
 902:	00001497          	auipc	s1,0x1
 906:	c1648493          	addi	s1,s1,-1002 # 1518 <stacks>
 90a:	6088                	ld	a0,0(s1)
 90c:	00000097          	auipc	ra,0x0
 910:	e0a080e7          	jalr	-502(ra) # 716 <free>
  stacks = 0;
 914:	0004b023          	sd	zero,0(s1)
  num_threads = 0;
 918:	00001797          	auipc	a5,0x1
 91c:	c007a423          	sw	zero,-1016(a5) # 1520 <num_threads>
  max_stacks = INIT_MAX_STACKS;
 920:	47a1                	li	a5,8
 922:	00001717          	auipc	a4,0x1
 926:	bcf72f23          	sw	a5,-1058(a4) # 1500 <max_stacks>
  threads_done = 0;
 92a:	00001797          	auipc	a5,0x1
 92e:	be07ad23          	sw	zero,-1030(a5) # 1524 <threads_done>
}
 932:	4501                	li	a0,0
 934:	70a2                	ld	ra,40(sp)
 936:	7402                	ld	s0,32(sp)
 938:	64e2                	ld	s1,24(sp)
 93a:	6145                	addi	sp,sp,48
 93c:	8082                	ret

000000000000093e <expand_num_threads>:
int expand_num_threads() {
 93e:	1101                	addi	sp,sp,-32
 940:	ec06                	sd	ra,24(sp)
 942:	e822                	sd	s0,16(sp)
 944:	e426                	sd	s1,8(sp)
 946:	e04a                	sd	s2,0(sp)
 948:	1000                	addi	s0,sp,32
  max_stacks *= 2;
 94a:	00001797          	auipc	a5,0x1
 94e:	bb678793          	addi	a5,a5,-1098 # 1500 <max_stacks>
 952:	4388                	lw	a0,0(a5)
 954:	0015151b          	slliw	a0,a0,0x1
 958:	c388                	sw	a0,0(a5)
  void **new_stacks = malloc(max_stacks*sizeof(char*));
 95a:	0035151b          	slliw	a0,a0,0x3
 95e:	00000097          	auipc	ra,0x0
 962:	e3e080e7          	jalr	-450(ra) # 79c <malloc>
 966:	892a                	mv	s2,a0
  memmove(new_stacks, stacks, num_threads*sizeof(char*));
 968:	00001617          	auipc	a2,0x1
 96c:	bb862603          	lw	a2,-1096(a2) # 1520 <num_threads>
 970:	00001497          	auipc	s1,0x1
 974:	ba848493          	addi	s1,s1,-1112 # 1518 <stacks>
 978:	0036161b          	slliw	a2,a2,0x3
 97c:	608c                	ld	a1,0(s1)
 97e:	00000097          	auipc	ra,0x0
 982:	8e4080e7          	jalr	-1820(ra) # 262 <memmove>
  free(stacks);
 986:	6088                	ld	a0,0(s1)
 988:	00000097          	auipc	ra,0x0
 98c:	d8e080e7          	jalr	-626(ra) # 716 <free>
  stacks = new_stacks;
 990:	0124b023          	sd	s2,0(s1)
}
 994:	4501                	li	a0,0
 996:	60e2                	ld	ra,24(sp)
 998:	6442                	ld	s0,16(sp)
 99a:	64a2                	ld	s1,8(sp)
 99c:	6902                	ld	s2,0(sp)
 99e:	6105                	addi	sp,sp,32
 9a0:	8082                	ret

00000000000009a2 <ithread_create>:

int ithread_create(void* (*fn_ptr)(void *), void *args) {
 9a2:	7179                	addi	sp,sp,-48
 9a4:	f406                	sd	ra,40(sp)
 9a6:	f022                	sd	s0,32(sp)
 9a8:	e84a                	sd	s2,16(sp)
 9aa:	e44e                	sd	s3,8(sp)
 9ac:	1800                	addi	s0,sp,48
 9ae:	892a                	mv	s2,a0
 9b0:	89ae                	mv	s3,a1
  if (stacks == 0) {
 9b2:	00001797          	auipc	a5,0x1
 9b6:	b667b783          	ld	a5,-1178(a5) # 1518 <stacks>
 9ba:	c3d9                	beqz	a5,a40 <ithread_create+0x9e>
    stacks = malloc(max_stacks*sizeof(char*));
  }
  if (num_threads == max_stacks) {
 9bc:	00001797          	auipc	a5,0x1
 9c0:	b447a783          	lw	a5,-1212(a5) # 1500 <max_stacks>
 9c4:	00001717          	auipc	a4,0x1
 9c8:	b5c72703          	lw	a4,-1188(a4) # 1520 <num_threads>
 9cc:	0af71363          	bne	a4,a5,a72 <ithread_create+0xd0>
    if (max_stacks == MAX_THREADS) {
 9d0:	04000713          	li	a4,64
 9d4:	08e78563          	beq	a5,a4,a5e <ithread_create+0xbc>
 9d8:	ec26                	sd	s1,24(sp)
      printf("ERROR: Thread capacity has been reached\n");
      return -1;
    }
    expand_num_threads();
 9da:	00000097          	auipc	ra,0x0
 9de:	f64080e7          	jalr	-156(ra) # 93e <expand_num_threads>
  }

  void *stack_ptr = malloc(PGSIZE);
 9e2:	6505                	lui	a0,0x1
 9e4:	00000097          	auipc	ra,0x0
 9e8:	db8080e7          	jalr	-584(ra) # 79c <malloc>
 9ec:	84aa                	mv	s1,a0
  stacks[num_threads] = stack_ptr;
 9ee:	00001717          	auipc	a4,0x1
 9f2:	b3272703          	lw	a4,-1230(a4) # 1520 <num_threads>
 9f6:	070e                	slli	a4,a4,0x3
 9f8:	00001797          	auipc	a5,0x1
 9fc:	b207b783          	ld	a5,-1248(a5) # 1518 <stacks>
 a00:	97ba                	add	a5,a5,a4
 a02:	e388                	sd	a0,0(a5)
  int res = create_thread(fn_ptr, args, stack_ptr, &ithread_exit);
 a04:	00000697          	auipc	a3,0x0
 a08:	e9268693          	addi	a3,a3,-366 # 896 <ithread_exit>
 a0c:	862a                	mv	a2,a0
 a0e:	85ce                	mv	a1,s3
 a10:	854a                	mv	a0,s2
 a12:	00000097          	auipc	ra,0x0
 a16:	9b2080e7          	jalr	-1614(ra) # 3c4 <create_thread>
 a1a:	892a                	mv	s2,a0
  if (res != -1) {
 a1c:	57fd                	li	a5,-1
 a1e:	04f50c63          	beq	a0,a5,a76 <ithread_create+0xd4>
    num_threads++;
 a22:	00001717          	auipc	a4,0x1
 a26:	afe70713          	addi	a4,a4,-1282 # 1520 <num_threads>
 a2a:	431c                	lw	a5,0(a4)
 a2c:	2785                	addiw	a5,a5,1
 a2e:	c31c                	sw	a5,0(a4)
 a30:	64e2                	ld	s1,24(sp)
  } else {
    free(stack_ptr);
    stacks[num_threads] = 0;
  }
  return res;
}
 a32:	854a                	mv	a0,s2
 a34:	70a2                	ld	ra,40(sp)
 a36:	7402                	ld	s0,32(sp)
 a38:	6942                	ld	s2,16(sp)
 a3a:	69a2                	ld	s3,8(sp)
 a3c:	6145                	addi	sp,sp,48
 a3e:	8082                	ret
    stacks = malloc(max_stacks*sizeof(char*));
 a40:	00001517          	auipc	a0,0x1
 a44:	ac052503          	lw	a0,-1344(a0) # 1500 <max_stacks>
 a48:	0035151b          	slliw	a0,a0,0x3
 a4c:	00000097          	auipc	ra,0x0
 a50:	d50080e7          	jalr	-688(ra) # 79c <malloc>
 a54:	00001797          	auipc	a5,0x1
 a58:	aca7b223          	sd	a0,-1340(a5) # 1518 <stacks>
 a5c:	b785                	j	9bc <ithread_create+0x1a>
      printf("ERROR: Thread capacity has been reached\n");
 a5e:	00000517          	auipc	a0,0x0
 a62:	0ca50513          	addi	a0,a0,202 # b28 <ithread_join+0x8c>
 a66:	00000097          	auipc	ra,0x0
 a6a:	c7a080e7          	jalr	-902(ra) # 6e0 <printf>
      return -1;
 a6e:	597d                	li	s2,-1
 a70:	b7c9                	j	a32 <ithread_create+0x90>
 a72:	ec26                	sd	s1,24(sp)
 a74:	b7bd                	j	9e2 <ithread_create+0x40>
    free(stack_ptr);
 a76:	8526                	mv	a0,s1
 a78:	00000097          	auipc	ra,0x0
 a7c:	c9e080e7          	jalr	-866(ra) # 716 <free>
    stacks[num_threads] = 0;
 a80:	00001717          	auipc	a4,0x1
 a84:	aa072703          	lw	a4,-1376(a4) # 1520 <num_threads>
 a88:	070e                	slli	a4,a4,0x3
 a8a:	00001797          	auipc	a5,0x1
 a8e:	a8e7b783          	ld	a5,-1394(a5) # 1518 <stacks>
 a92:	97ba                	add	a5,a5,a4
 a94:	0007b023          	sd	zero,0(a5)
 a98:	64e2                	ld	s1,24(sp)
 a9a:	bf61                	j	a32 <ithread_create+0x90>

0000000000000a9c <ithread_join>:

int ithread_join(int thread_id) {
 a9c:	1101                	addi	sp,sp,-32
 a9e:	ec06                	sd	ra,24(sp)
 aa0:	e822                	sd	s0,16(sp)
 aa2:	1000                	addi	s0,sp,32
  int status;
  join_thread(thread_id, (uint64)&status);
 aa4:	ff040793          	addi	a5,s0,-16
 aa8:	ffc7859b          	addiw	a1,a5,-4
 aac:	00000097          	auipc	ra,0x0
 ab0:	920080e7          	jalr	-1760(ra) # 3cc <join_thread>
  threads_done++;
 ab4:	00001717          	auipc	a4,0x1
 ab8:	a7070713          	addi	a4,a4,-1424 # 1524 <threads_done>
 abc:	431c                	lw	a5,0(a4)
 abe:	2785                	addiw	a5,a5,1
 ac0:	c31c                	sw	a5,0(a4)
  if (threads_done == num_threads) {
 ac2:	00001717          	auipc	a4,0x1
 ac6:	a5e72703          	lw	a4,-1442(a4) # 1520 <num_threads>
 aca:	00f70863          	beq	a4,a5,ada <ithread_join+0x3e>
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
 ade:	dd6080e7          	jalr	-554(ra) # 8b0 <free_stacks>
 ae2:	b7f5                	j	ace <ithread_join+0x32>
