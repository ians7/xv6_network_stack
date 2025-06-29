
user/_echo:     file format elf64-littleriscv


Disassembly of section .text:

0000000000000000 <main>:
#include "kernel/stat.h"
#include "user/user.h"

int
main(int argc, char *argv[])
{
   0:	7139                	addi	sp,sp,-64
   2:	fc06                	sd	ra,56(sp)
   4:	f822                	sd	s0,48(sp)
   6:	f426                	sd	s1,40(sp)
   8:	f04a                	sd	s2,32(sp)
   a:	ec4e                	sd	s3,24(sp)
   c:	e852                	sd	s4,16(sp)
   e:	e456                	sd	s5,8(sp)
  10:	e05a                	sd	s6,0(sp)
  12:	0080                	addi	s0,sp,64
  int i;

  for(i = 1; i < argc; i++){
  14:	4785                	li	a5,1
  16:	06a7d863          	bge	a5,a0,86 <main+0x86>
  1a:	00858493          	addi	s1,a1,8
  1e:	3579                	addiw	a0,a0,-2
  20:	02051793          	slli	a5,a0,0x20
  24:	01d7d513          	srli	a0,a5,0x1d
  28:	00a48ab3          	add	s5,s1,a0
  2c:	05c1                	addi	a1,a1,16
  2e:	00a58a33          	add	s4,a1,a0
    write(1, argv[i], strlen(argv[i]));
  32:	4985                	li	s3,1
    if(i + 1 < argc){
      write(1, " ", 1);
  34:	00001b17          	auipc	s6,0x1
  38:	abcb0b13          	addi	s6,s6,-1348 # af0 <ithread_join+0x4c>
  3c:	a819                	j	52 <main+0x52>
  3e:	864e                	mv	a2,s3
  40:	85da                	mv	a1,s6
  42:	854e                	mv	a0,s3
  44:	00000097          	auipc	ra,0x0
  48:	326080e7          	jalr	806(ra) # 36a <write>
  for(i = 1; i < argc; i++){
  4c:	04a1                	addi	s1,s1,8
  4e:	03448c63          	beq	s1,s4,86 <main+0x86>
    write(1, argv[i], strlen(argv[i]));
  52:	0004b903          	ld	s2,0(s1)
  56:	854a                	mv	a0,s2
  58:	00000097          	auipc	ra,0x0
  5c:	0a2080e7          	jalr	162(ra) # fa <strlen>
  60:	862a                	mv	a2,a0
  62:	85ca                	mv	a1,s2
  64:	854e                	mv	a0,s3
  66:	00000097          	auipc	ra,0x0
  6a:	304080e7          	jalr	772(ra) # 36a <write>
    if(i + 1 < argc){
  6e:	fd5498e3          	bne	s1,s5,3e <main+0x3e>
    } else {
      write(1, "\n", 1);
  72:	4605                	li	a2,1
  74:	00001597          	auipc	a1,0x1
  78:	a8458593          	addi	a1,a1,-1404 # af8 <ithread_join+0x54>
  7c:	8532                	mv	a0,a2
  7e:	00000097          	auipc	ra,0x0
  82:	2ec080e7          	jalr	748(ra) # 36a <write>
    }
  }
  exit(0);
  86:	4501                	li	a0,0
  88:	00000097          	auipc	ra,0x0
  8c:	2c2080e7          	jalr	706(ra) # 34a <exit>

0000000000000090 <_main>:
//
// wrapper so that it's OK if main() does not call exit().
//
void
_main()
{
  90:	1141                	addi	sp,sp,-16
  92:	e406                	sd	ra,8(sp)
  94:	e022                	sd	s0,0(sp)
  96:	0800                	addi	s0,sp,16
  extern int main();
  main();
  98:	00000097          	auipc	ra,0x0
  9c:	f68080e7          	jalr	-152(ra) # 0 <main>
  exit(0);
  a0:	4501                	li	a0,0
  a2:	00000097          	auipc	ra,0x0
  a6:	2a8080e7          	jalr	680(ra) # 34a <exit>

00000000000000aa <strcpy>:
}

char*
strcpy(char *s, const char *t)
{
  aa:	1141                	addi	sp,sp,-16
  ac:	e406                	sd	ra,8(sp)
  ae:	e022                	sd	s0,0(sp)
  b0:	0800                	addi	s0,sp,16
  char *os;

  os = s;
  while((*s++ = *t++) != 0)
  b2:	87aa                	mv	a5,a0
  b4:	0585                	addi	a1,a1,1
  b6:	0785                	addi	a5,a5,1
  b8:	fff5c703          	lbu	a4,-1(a1)
  bc:	fee78fa3          	sb	a4,-1(a5)
  c0:	fb75                	bnez	a4,b4 <strcpy+0xa>
    ;
  return os;
}
  c2:	60a2                	ld	ra,8(sp)
  c4:	6402                	ld	s0,0(sp)
  c6:	0141                	addi	sp,sp,16
  c8:	8082                	ret

00000000000000ca <strcmp>:

int
strcmp(const char *p, const char *q)
{
  ca:	1141                	addi	sp,sp,-16
  cc:	e406                	sd	ra,8(sp)
  ce:	e022                	sd	s0,0(sp)
  d0:	0800                	addi	s0,sp,16
  while(*p && *p == *q)
  d2:	00054783          	lbu	a5,0(a0)
  d6:	cb91                	beqz	a5,ea <strcmp+0x20>
  d8:	0005c703          	lbu	a4,0(a1)
  dc:	00f71763          	bne	a4,a5,ea <strcmp+0x20>
    p++, q++;
  e0:	0505                	addi	a0,a0,1
  e2:	0585                	addi	a1,a1,1
  while(*p && *p == *q)
  e4:	00054783          	lbu	a5,0(a0)
  e8:	fbe5                	bnez	a5,d8 <strcmp+0xe>
  return (uchar)*p - (uchar)*q;
  ea:	0005c503          	lbu	a0,0(a1)
}
  ee:	40a7853b          	subw	a0,a5,a0
  f2:	60a2                	ld	ra,8(sp)
  f4:	6402                	ld	s0,0(sp)
  f6:	0141                	addi	sp,sp,16
  f8:	8082                	ret

00000000000000fa <strlen>:

uint
strlen(const char *s)
{
  fa:	1141                	addi	sp,sp,-16
  fc:	e406                	sd	ra,8(sp)
  fe:	e022                	sd	s0,0(sp)
 100:	0800                	addi	s0,sp,16
  int n;

  for(n = 0; s[n]; n++)
 102:	00054783          	lbu	a5,0(a0)
 106:	cf99                	beqz	a5,124 <strlen+0x2a>
 108:	0505                	addi	a0,a0,1
 10a:	87aa                	mv	a5,a0
 10c:	86be                	mv	a3,a5
 10e:	0785                	addi	a5,a5,1
 110:	fff7c703          	lbu	a4,-1(a5)
 114:	ff65                	bnez	a4,10c <strlen+0x12>
 116:	40a6853b          	subw	a0,a3,a0
 11a:	2505                	addiw	a0,a0,1
    ;
  return n;
}
 11c:	60a2                	ld	ra,8(sp)
 11e:	6402                	ld	s0,0(sp)
 120:	0141                	addi	sp,sp,16
 122:	8082                	ret
  for(n = 0; s[n]; n++)
 124:	4501                	li	a0,0
 126:	bfdd                	j	11c <strlen+0x22>

0000000000000128 <memset>:

void*
memset(void *dst, int c, uint n)
{
 128:	1141                	addi	sp,sp,-16
 12a:	e406                	sd	ra,8(sp)
 12c:	e022                	sd	s0,0(sp)
 12e:	0800                	addi	s0,sp,16
  char *cdst = (char *) dst;
  int i;
  for(i = 0; i < n; i++){
 130:	ca19                	beqz	a2,146 <memset+0x1e>
 132:	87aa                	mv	a5,a0
 134:	1602                	slli	a2,a2,0x20
 136:	9201                	srli	a2,a2,0x20
 138:	00a60733          	add	a4,a2,a0
    cdst[i] = c;
 13c:	00b78023          	sb	a1,0(a5)
  for(i = 0; i < n; i++){
 140:	0785                	addi	a5,a5,1
 142:	fee79de3          	bne	a5,a4,13c <memset+0x14>
  }
  return dst;
}
 146:	60a2                	ld	ra,8(sp)
 148:	6402                	ld	s0,0(sp)
 14a:	0141                	addi	sp,sp,16
 14c:	8082                	ret

000000000000014e <strchr>:

char*
strchr(const char *s, char c)
{
 14e:	1141                	addi	sp,sp,-16
 150:	e406                	sd	ra,8(sp)
 152:	e022                	sd	s0,0(sp)
 154:	0800                	addi	s0,sp,16
  for(; *s; s++)
 156:	00054783          	lbu	a5,0(a0)
 15a:	cf81                	beqz	a5,172 <strchr+0x24>
    if(*s == c)
 15c:	00f58763          	beq	a1,a5,16a <strchr+0x1c>
  for(; *s; s++)
 160:	0505                	addi	a0,a0,1
 162:	00054783          	lbu	a5,0(a0)
 166:	fbfd                	bnez	a5,15c <strchr+0xe>
      return (char*)s;
  return 0;
 168:	4501                	li	a0,0
}
 16a:	60a2                	ld	ra,8(sp)
 16c:	6402                	ld	s0,0(sp)
 16e:	0141                	addi	sp,sp,16
 170:	8082                	ret
  return 0;
 172:	4501                	li	a0,0
 174:	bfdd                	j	16a <strchr+0x1c>

0000000000000176 <gets>:

char*
gets(char *buf, int max)
{
 176:	7159                	addi	sp,sp,-112
 178:	f486                	sd	ra,104(sp)
 17a:	f0a2                	sd	s0,96(sp)
 17c:	eca6                	sd	s1,88(sp)
 17e:	e8ca                	sd	s2,80(sp)
 180:	e4ce                	sd	s3,72(sp)
 182:	e0d2                	sd	s4,64(sp)
 184:	fc56                	sd	s5,56(sp)
 186:	f85a                	sd	s6,48(sp)
 188:	f45e                	sd	s7,40(sp)
 18a:	f062                	sd	s8,32(sp)
 18c:	ec66                	sd	s9,24(sp)
 18e:	e86a                	sd	s10,16(sp)
 190:	1880                	addi	s0,sp,112
 192:	8caa                	mv	s9,a0
 194:	8a2e                	mv	s4,a1
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 196:	892a                	mv	s2,a0
 198:	4481                	li	s1,0
    cc = read(0, &c, 1);
 19a:	f9f40b13          	addi	s6,s0,-97
 19e:	4a85                	li	s5,1
    if(cc < 1)
      break;
    buf[i++] = c;
    if(c == '\n' || c == '\r')
 1a0:	4ba9                	li	s7,10
 1a2:	4c35                	li	s8,13
  for(i=0; i+1 < max; ){
 1a4:	8d26                	mv	s10,s1
 1a6:	0014899b          	addiw	s3,s1,1
 1aa:	84ce                	mv	s1,s3
 1ac:	0349d763          	bge	s3,s4,1da <gets+0x64>
    cc = read(0, &c, 1);
 1b0:	8656                	mv	a2,s5
 1b2:	85da                	mv	a1,s6
 1b4:	4501                	li	a0,0
 1b6:	00000097          	auipc	ra,0x0
 1ba:	1ac080e7          	jalr	428(ra) # 362 <read>
    if(cc < 1)
 1be:	00a05e63          	blez	a0,1da <gets+0x64>
    buf[i++] = c;
 1c2:	f9f44783          	lbu	a5,-97(s0)
 1c6:	00f90023          	sb	a5,0(s2)
    if(c == '\n' || c == '\r')
 1ca:	01778763          	beq	a5,s7,1d8 <gets+0x62>
 1ce:	0905                	addi	s2,s2,1
 1d0:	fd879ae3          	bne	a5,s8,1a4 <gets+0x2e>
    buf[i++] = c;
 1d4:	8d4e                	mv	s10,s3
 1d6:	a011                	j	1da <gets+0x64>
 1d8:	8d4e                	mv	s10,s3
      break;
  }
  buf[i] = '\0';
 1da:	9d66                	add	s10,s10,s9
 1dc:	000d0023          	sb	zero,0(s10)
  return buf;
}
 1e0:	8566                	mv	a0,s9
 1e2:	70a6                	ld	ra,104(sp)
 1e4:	7406                	ld	s0,96(sp)
 1e6:	64e6                	ld	s1,88(sp)
 1e8:	6946                	ld	s2,80(sp)
 1ea:	69a6                	ld	s3,72(sp)
 1ec:	6a06                	ld	s4,64(sp)
 1ee:	7ae2                	ld	s5,56(sp)
 1f0:	7b42                	ld	s6,48(sp)
 1f2:	7ba2                	ld	s7,40(sp)
 1f4:	7c02                	ld	s8,32(sp)
 1f6:	6ce2                	ld	s9,24(sp)
 1f8:	6d42                	ld	s10,16(sp)
 1fa:	6165                	addi	sp,sp,112
 1fc:	8082                	ret

00000000000001fe <stat>:

int
stat(const char *n, struct stat *st)
{
 1fe:	1101                	addi	sp,sp,-32
 200:	ec06                	sd	ra,24(sp)
 202:	e822                	sd	s0,16(sp)
 204:	e04a                	sd	s2,0(sp)
 206:	1000                	addi	s0,sp,32
 208:	892e                	mv	s2,a1
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 20a:	4581                	li	a1,0
 20c:	00000097          	auipc	ra,0x0
 210:	17e080e7          	jalr	382(ra) # 38a <open>
  if(fd < 0)
 214:	02054663          	bltz	a0,240 <stat+0x42>
 218:	e426                	sd	s1,8(sp)
 21a:	84aa                	mv	s1,a0
    return -1;
  r = fstat(fd, st);
 21c:	85ca                	mv	a1,s2
 21e:	00000097          	auipc	ra,0x0
 222:	184080e7          	jalr	388(ra) # 3a2 <fstat>
 226:	892a                	mv	s2,a0
  close(fd);
 228:	8526                	mv	a0,s1
 22a:	00000097          	auipc	ra,0x0
 22e:	148080e7          	jalr	328(ra) # 372 <close>
  return r;
 232:	64a2                	ld	s1,8(sp)
}
 234:	854a                	mv	a0,s2
 236:	60e2                	ld	ra,24(sp)
 238:	6442                	ld	s0,16(sp)
 23a:	6902                	ld	s2,0(sp)
 23c:	6105                	addi	sp,sp,32
 23e:	8082                	ret
    return -1;
 240:	597d                	li	s2,-1
 242:	bfcd                	j	234 <stat+0x36>

0000000000000244 <atoi>:

int
atoi(const char *s)
{
 244:	1141                	addi	sp,sp,-16
 246:	e406                	sd	ra,8(sp)
 248:	e022                	sd	s0,0(sp)
 24a:	0800                	addi	s0,sp,16
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
 24c:	00054683          	lbu	a3,0(a0)
 250:	fd06879b          	addiw	a5,a3,-48
 254:	0ff7f793          	zext.b	a5,a5
 258:	4625                	li	a2,9
 25a:	02f66963          	bltu	a2,a5,28c <atoi+0x48>
 25e:	872a                	mv	a4,a0
  n = 0;
 260:	4501                	li	a0,0
    n = n*10 + *s++ - '0';
 262:	0705                	addi	a4,a4,1
 264:	0025179b          	slliw	a5,a0,0x2
 268:	9fa9                	addw	a5,a5,a0
 26a:	0017979b          	slliw	a5,a5,0x1
 26e:	9fb5                	addw	a5,a5,a3
 270:	fd07851b          	addiw	a0,a5,-48
  while('0' <= *s && *s <= '9')
 274:	00074683          	lbu	a3,0(a4)
 278:	fd06879b          	addiw	a5,a3,-48
 27c:	0ff7f793          	zext.b	a5,a5
 280:	fef671e3          	bgeu	a2,a5,262 <atoi+0x1e>
  return n;
}
 284:	60a2                	ld	ra,8(sp)
 286:	6402                	ld	s0,0(sp)
 288:	0141                	addi	sp,sp,16
 28a:	8082                	ret
  n = 0;
 28c:	4501                	li	a0,0
 28e:	bfdd                	j	284 <atoi+0x40>

0000000000000290 <memmove>:

void*
memmove(void *vdst, const void *vsrc, int n)
{
 290:	1141                	addi	sp,sp,-16
 292:	e406                	sd	ra,8(sp)
 294:	e022                	sd	s0,0(sp)
 296:	0800                	addi	s0,sp,16
  char *dst;
  const char *src;

  dst = vdst;
  src = vsrc;
  if (src > dst) {
 298:	02b57563          	bgeu	a0,a1,2c2 <memmove+0x32>
    while(n-- > 0)
 29c:	00c05f63          	blez	a2,2ba <memmove+0x2a>
 2a0:	1602                	slli	a2,a2,0x20
 2a2:	9201                	srli	a2,a2,0x20
 2a4:	00c507b3          	add	a5,a0,a2
  dst = vdst;
 2a8:	872a                	mv	a4,a0
      *dst++ = *src++;
 2aa:	0585                	addi	a1,a1,1
 2ac:	0705                	addi	a4,a4,1
 2ae:	fff5c683          	lbu	a3,-1(a1)
 2b2:	fed70fa3          	sb	a3,-1(a4)
    while(n-- > 0)
 2b6:	fee79ae3          	bne	a5,a4,2aa <memmove+0x1a>
    src += n;
    while(n-- > 0)
      *--dst = *--src;
  }
  return vdst;
}
 2ba:	60a2                	ld	ra,8(sp)
 2bc:	6402                	ld	s0,0(sp)
 2be:	0141                	addi	sp,sp,16
 2c0:	8082                	ret
    dst += n;
 2c2:	00c50733          	add	a4,a0,a2
    src += n;
 2c6:	95b2                	add	a1,a1,a2
    while(n-- > 0)
 2c8:	fec059e3          	blez	a2,2ba <memmove+0x2a>
 2cc:	fff6079b          	addiw	a5,a2,-1
 2d0:	1782                	slli	a5,a5,0x20
 2d2:	9381                	srli	a5,a5,0x20
 2d4:	fff7c793          	not	a5,a5
 2d8:	97ba                	add	a5,a5,a4
      *--dst = *--src;
 2da:	15fd                	addi	a1,a1,-1
 2dc:	177d                	addi	a4,a4,-1
 2de:	0005c683          	lbu	a3,0(a1)
 2e2:	00d70023          	sb	a3,0(a4)
    while(n-- > 0)
 2e6:	fef71ae3          	bne	a4,a5,2da <memmove+0x4a>
 2ea:	bfc1                	j	2ba <memmove+0x2a>

00000000000002ec <memcmp>:

int
memcmp(const void *s1, const void *s2, uint n)
{
 2ec:	1141                	addi	sp,sp,-16
 2ee:	e406                	sd	ra,8(sp)
 2f0:	e022                	sd	s0,0(sp)
 2f2:	0800                	addi	s0,sp,16
  const char *p1 = s1, *p2 = s2;
  while (n-- > 0) {
 2f4:	ca0d                	beqz	a2,326 <memcmp+0x3a>
 2f6:	fff6069b          	addiw	a3,a2,-1
 2fa:	1682                	slli	a3,a3,0x20
 2fc:	9281                	srli	a3,a3,0x20
 2fe:	0685                	addi	a3,a3,1
 300:	96aa                	add	a3,a3,a0
    if (*p1 != *p2) {
 302:	00054783          	lbu	a5,0(a0)
 306:	0005c703          	lbu	a4,0(a1)
 30a:	00e79863          	bne	a5,a4,31a <memcmp+0x2e>
      return *p1 - *p2;
    }
    p1++;
 30e:	0505                	addi	a0,a0,1
    p2++;
 310:	0585                	addi	a1,a1,1
  while (n-- > 0) {
 312:	fed518e3          	bne	a0,a3,302 <memcmp+0x16>
  }
  return 0;
 316:	4501                	li	a0,0
 318:	a019                	j	31e <memcmp+0x32>
      return *p1 - *p2;
 31a:	40e7853b          	subw	a0,a5,a4
}
 31e:	60a2                	ld	ra,8(sp)
 320:	6402                	ld	s0,0(sp)
 322:	0141                	addi	sp,sp,16
 324:	8082                	ret
  return 0;
 326:	4501                	li	a0,0
 328:	bfdd                	j	31e <memcmp+0x32>

000000000000032a <memcpy>:

void *
memcpy(void *dst, const void *src, uint n)
{
 32a:	1141                	addi	sp,sp,-16
 32c:	e406                	sd	ra,8(sp)
 32e:	e022                	sd	s0,0(sp)
 330:	0800                	addi	s0,sp,16
  return memmove(dst, src, n);
 332:	00000097          	auipc	ra,0x0
 336:	f5e080e7          	jalr	-162(ra) # 290 <memmove>
}
 33a:	60a2                	ld	ra,8(sp)
 33c:	6402                	ld	s0,0(sp)
 33e:	0141                	addi	sp,sp,16
 340:	8082                	ret

0000000000000342 <fork>:
# generated by usys.pl - do not edit
#include "kernel/syscall.h"
.global fork
fork:
 li a7, SYS_fork
 342:	4885                	li	a7,1
 ecall
 344:	00000073          	ecall
 ret
 348:	8082                	ret

000000000000034a <exit>:
.global exit
exit:
 li a7, SYS_exit
 34a:	4889                	li	a7,2
 ecall
 34c:	00000073          	ecall
 ret
 350:	8082                	ret

0000000000000352 <wait>:
.global wait
wait:
 li a7, SYS_wait
 352:	488d                	li	a7,3
 ecall
 354:	00000073          	ecall
 ret
 358:	8082                	ret

000000000000035a <pipe>:
.global pipe
pipe:
 li a7, SYS_pipe
 35a:	4891                	li	a7,4
 ecall
 35c:	00000073          	ecall
 ret
 360:	8082                	ret

0000000000000362 <read>:
.global read
read:
 li a7, SYS_read
 362:	4895                	li	a7,5
 ecall
 364:	00000073          	ecall
 ret
 368:	8082                	ret

000000000000036a <write>:
.global write
write:
 li a7, SYS_write
 36a:	48c1                	li	a7,16
 ecall
 36c:	00000073          	ecall
 ret
 370:	8082                	ret

0000000000000372 <close>:
.global close
close:
 li a7, SYS_close
 372:	48d5                	li	a7,21
 ecall
 374:	00000073          	ecall
 ret
 378:	8082                	ret

000000000000037a <kill>:
.global kill
kill:
 li a7, SYS_kill
 37a:	4899                	li	a7,6
 ecall
 37c:	00000073          	ecall
 ret
 380:	8082                	ret

0000000000000382 <exec>:
.global exec
exec:
 li a7, SYS_exec
 382:	489d                	li	a7,7
 ecall
 384:	00000073          	ecall
 ret
 388:	8082                	ret

000000000000038a <open>:
.global open
open:
 li a7, SYS_open
 38a:	48bd                	li	a7,15
 ecall
 38c:	00000073          	ecall
 ret
 390:	8082                	ret

0000000000000392 <mknod>:
.global mknod
mknod:
 li a7, SYS_mknod
 392:	48c5                	li	a7,17
 ecall
 394:	00000073          	ecall
 ret
 398:	8082                	ret

000000000000039a <unlink>:
.global unlink
unlink:
 li a7, SYS_unlink
 39a:	48c9                	li	a7,18
 ecall
 39c:	00000073          	ecall
 ret
 3a0:	8082                	ret

00000000000003a2 <fstat>:
.global fstat
fstat:
 li a7, SYS_fstat
 3a2:	48a1                	li	a7,8
 ecall
 3a4:	00000073          	ecall
 ret
 3a8:	8082                	ret

00000000000003aa <link>:
.global link
link:
 li a7, SYS_link
 3aa:	48cd                	li	a7,19
 ecall
 3ac:	00000073          	ecall
 ret
 3b0:	8082                	ret

00000000000003b2 <mkdir>:
.global mkdir
mkdir:
 li a7, SYS_mkdir
 3b2:	48d1                	li	a7,20
 ecall
 3b4:	00000073          	ecall
 ret
 3b8:	8082                	ret

00000000000003ba <chdir>:
.global chdir
chdir:
 li a7, SYS_chdir
 3ba:	48a5                	li	a7,9
 ecall
 3bc:	00000073          	ecall
 ret
 3c0:	8082                	ret

00000000000003c2 <dup>:
.global dup
dup:
 li a7, SYS_dup
 3c2:	48a9                	li	a7,10
 ecall
 3c4:	00000073          	ecall
 ret
 3c8:	8082                	ret

00000000000003ca <getpid>:
.global getpid
getpid:
 li a7, SYS_getpid
 3ca:	48ad                	li	a7,11
 ecall
 3cc:	00000073          	ecall
 ret
 3d0:	8082                	ret

00000000000003d2 <sbrk>:
.global sbrk
sbrk:
 li a7, SYS_sbrk
 3d2:	48b1                	li	a7,12
 ecall
 3d4:	00000073          	ecall
 ret
 3d8:	8082                	ret

00000000000003da <sleep>:
.global sleep
sleep:
 li a7, SYS_sleep
 3da:	48b5                	li	a7,13
 ecall
 3dc:	00000073          	ecall
 ret
 3e0:	8082                	ret

00000000000003e2 <uptime>:
.global uptime
uptime:
 li a7, SYS_uptime
 3e2:	48b9                	li	a7,14
 ecall
 3e4:	00000073          	ecall
 ret
 3e8:	8082                	ret

00000000000003ea <spoon>:
.global spoon
spoon:
 li a7, SYS_spoon
 3ea:	48d9                	li	a7,22
 ecall
 3ec:	00000073          	ecall
 ret
 3f0:	8082                	ret

00000000000003f2 <create_thread>:
.global create_thread
create_thread:
 li a7, SYS_create_thread
 3f2:	48dd                	li	a7,23
 ecall
 3f4:	00000073          	ecall
 ret
 3f8:	8082                	ret

00000000000003fa <join_thread>:
.global join_thread
join_thread:
 li a7, SYS_join_thread
 3fa:	48e1                	li	a7,24
 ecall
 3fc:	00000073          	ecall
 ret
 400:	8082                	ret

0000000000000402 <thread_exit>:
.global thread_exit
thread_exit:
 li a7, SYS_thread_exit
 402:	48e5                	li	a7,25
 ecall
 404:	00000073          	ecall
 ret
 408:	8082                	ret

000000000000040a <socket>:
.global socket
socket:
 li a7, SYS_socket
 40a:	48e9                	li	a7,26
 ecall
 40c:	00000073          	ecall
 ret
 410:	8082                	ret

0000000000000412 <bind>:
.global bind
bind:
 li a7, SYS_bind
 412:	48ed                	li	a7,27
 ecall
 414:	00000073          	ecall
 ret
 418:	8082                	ret

000000000000041a <accept>:
.global accept
accept:
 li a7, SYS_accept
 41a:	48f5                	li	a7,29
 ecall
 41c:	00000073          	ecall
 ret
 420:	8082                	ret

0000000000000422 <listen>:
.global listen
listen:
 li a7, SYS_listen
 422:	48f1                	li	a7,28
 ecall
 424:	00000073          	ecall
 ret
 428:	8082                	ret

000000000000042a <connect>:
.global connect
connect:
 li a7, SYS_connect
 42a:	48f9                	li	a7,30
 ecall
 42c:	00000073          	ecall
 ret
 430:	8082                	ret

0000000000000432 <putc>:

static char digits[] = "0123456789ABCDEF";

static void
putc(int fd, char c)
{
 432:	1101                	addi	sp,sp,-32
 434:	ec06                	sd	ra,24(sp)
 436:	e822                	sd	s0,16(sp)
 438:	1000                	addi	s0,sp,32
 43a:	feb407a3          	sb	a1,-17(s0)
  write(fd, &c, 1);
 43e:	4605                	li	a2,1
 440:	fef40593          	addi	a1,s0,-17
 444:	00000097          	auipc	ra,0x0
 448:	f26080e7          	jalr	-218(ra) # 36a <write>
}
 44c:	60e2                	ld	ra,24(sp)
 44e:	6442                	ld	s0,16(sp)
 450:	6105                	addi	sp,sp,32
 452:	8082                	ret

0000000000000454 <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
 454:	7139                	addi	sp,sp,-64
 456:	fc06                	sd	ra,56(sp)
 458:	f822                	sd	s0,48(sp)
 45a:	f426                	sd	s1,40(sp)
 45c:	f04a                	sd	s2,32(sp)
 45e:	ec4e                	sd	s3,24(sp)
 460:	0080                	addi	s0,sp,64
 462:	892a                	mv	s2,a0
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
  if(sgn && xx < 0){
 464:	c299                	beqz	a3,46a <printint+0x16>
 466:	0805c063          	bltz	a1,4e6 <printint+0x92>
  neg = 0;
 46a:	4e01                	li	t3,0
    x = -xx;
  } else {
    x = xx;
  }

  i = 0;
 46c:	fc040313          	addi	t1,s0,-64
  neg = 0;
 470:	869a                	mv	a3,t1
  i = 0;
 472:	4781                	li	a5,0
  do{
    buf[i++] = digits[x % base];
 474:	00000817          	auipc	a6,0x0
 478:	71c80813          	addi	a6,a6,1820 # b90 <digits>
 47c:	88be                	mv	a7,a5
 47e:	0017851b          	addiw	a0,a5,1
 482:	87aa                	mv	a5,a0
 484:	02c5f73b          	remuw	a4,a1,a2
 488:	1702                	slli	a4,a4,0x20
 48a:	9301                	srli	a4,a4,0x20
 48c:	9742                	add	a4,a4,a6
 48e:	00074703          	lbu	a4,0(a4)
 492:	00e68023          	sb	a4,0(a3)
  }while((x /= base) != 0);
 496:	872e                	mv	a4,a1
 498:	02c5d5bb          	divuw	a1,a1,a2
 49c:	0685                	addi	a3,a3,1
 49e:	fcc77fe3          	bgeu	a4,a2,47c <printint+0x28>
  if(neg)
 4a2:	000e0c63          	beqz	t3,4ba <printint+0x66>
    buf[i++] = '-';
 4a6:	fd050793          	addi	a5,a0,-48
 4aa:	00878533          	add	a0,a5,s0
 4ae:	02d00793          	li	a5,45
 4b2:	fef50823          	sb	a5,-16(a0)
 4b6:	0028879b          	addiw	a5,a7,2

  while(--i >= 0)
 4ba:	fff7899b          	addiw	s3,a5,-1
 4be:	006784b3          	add	s1,a5,t1
    putc(fd, buf[i]);
 4c2:	fff4c583          	lbu	a1,-1(s1)
 4c6:	854a                	mv	a0,s2
 4c8:	00000097          	auipc	ra,0x0
 4cc:	f6a080e7          	jalr	-150(ra) # 432 <putc>
  while(--i >= 0)
 4d0:	39fd                	addiw	s3,s3,-1
 4d2:	14fd                	addi	s1,s1,-1
 4d4:	fe09d7e3          	bgez	s3,4c2 <printint+0x6e>
}
 4d8:	70e2                	ld	ra,56(sp)
 4da:	7442                	ld	s0,48(sp)
 4dc:	74a2                	ld	s1,40(sp)
 4de:	7902                	ld	s2,32(sp)
 4e0:	69e2                	ld	s3,24(sp)
 4e2:	6121                	addi	sp,sp,64
 4e4:	8082                	ret
    x = -xx;
 4e6:	40b005bb          	negw	a1,a1
    neg = 1;
 4ea:	4e05                	li	t3,1
    x = -xx;
 4ec:	b741                	j	46c <printint+0x18>

00000000000004ee <vprintf>:
}

// Print to the given fd. Only understands %d, %x, %p, %s.
void
vprintf(int fd, const char *fmt, va_list ap)
{
 4ee:	715d                	addi	sp,sp,-80
 4f0:	e486                	sd	ra,72(sp)
 4f2:	e0a2                	sd	s0,64(sp)
 4f4:	f84a                	sd	s2,48(sp)
 4f6:	0880                	addi	s0,sp,80
  char *s;
  int c, i, state;

  state = 0;
  for(i = 0; fmt[i]; i++){
 4f8:	0005c903          	lbu	s2,0(a1)
 4fc:	1a090a63          	beqz	s2,6b0 <vprintf+0x1c2>
 500:	fc26                	sd	s1,56(sp)
 502:	f44e                	sd	s3,40(sp)
 504:	f052                	sd	s4,32(sp)
 506:	ec56                	sd	s5,24(sp)
 508:	e85a                	sd	s6,16(sp)
 50a:	e45e                	sd	s7,8(sp)
 50c:	8aaa                	mv	s5,a0
 50e:	8bb2                	mv	s7,a2
 510:	00158493          	addi	s1,a1,1
  state = 0;
 514:	4981                	li	s3,0
      if(c == '%'){
        state = '%';
      } else {
        putc(fd, c);
      }
    } else if(state == '%'){
 516:	02500a13          	li	s4,37
 51a:	4b55                	li	s6,21
 51c:	a839                	j	53a <vprintf+0x4c>
        putc(fd, c);
 51e:	85ca                	mv	a1,s2
 520:	8556                	mv	a0,s5
 522:	00000097          	auipc	ra,0x0
 526:	f10080e7          	jalr	-240(ra) # 432 <putc>
 52a:	a019                	j	530 <vprintf+0x42>
    } else if(state == '%'){
 52c:	01498d63          	beq	s3,s4,546 <vprintf+0x58>
  for(i = 0; fmt[i]; i++){
 530:	0485                	addi	s1,s1,1
 532:	fff4c903          	lbu	s2,-1(s1)
 536:	16090763          	beqz	s2,6a4 <vprintf+0x1b6>
    if(state == 0){
 53a:	fe0999e3          	bnez	s3,52c <vprintf+0x3e>
      if(c == '%'){
 53e:	ff4910e3          	bne	s2,s4,51e <vprintf+0x30>
        state = '%';
 542:	89d2                	mv	s3,s4
 544:	b7f5                	j	530 <vprintf+0x42>
      if(c == 'd'){
 546:	13490463          	beq	s2,s4,66e <vprintf+0x180>
 54a:	f9d9079b          	addiw	a5,s2,-99
 54e:	0ff7f793          	zext.b	a5,a5
 552:	12fb6763          	bltu	s6,a5,680 <vprintf+0x192>
 556:	f9d9079b          	addiw	a5,s2,-99
 55a:	0ff7f713          	zext.b	a4,a5
 55e:	12eb6163          	bltu	s6,a4,680 <vprintf+0x192>
 562:	00271793          	slli	a5,a4,0x2
 566:	00000717          	auipc	a4,0x0
 56a:	5d270713          	addi	a4,a4,1490 # b38 <ithread_join+0x94>
 56e:	97ba                	add	a5,a5,a4
 570:	439c                	lw	a5,0(a5)
 572:	97ba                	add	a5,a5,a4
 574:	8782                	jr	a5
        printint(fd, va_arg(ap, int), 10, 1);
 576:	008b8913          	addi	s2,s7,8
 57a:	4685                	li	a3,1
 57c:	4629                	li	a2,10
 57e:	000ba583          	lw	a1,0(s7)
 582:	8556                	mv	a0,s5
 584:	00000097          	auipc	ra,0x0
 588:	ed0080e7          	jalr	-304(ra) # 454 <printint>
 58c:	8bca                	mv	s7,s2
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
        putc(fd, c);
      }
      state = 0;
 58e:	4981                	li	s3,0
 590:	b745                	j	530 <vprintf+0x42>
        printint(fd, va_arg(ap, uint64), 10, 0);
 592:	008b8913          	addi	s2,s7,8
 596:	4681                	li	a3,0
 598:	4629                	li	a2,10
 59a:	000ba583          	lw	a1,0(s7)
 59e:	8556                	mv	a0,s5
 5a0:	00000097          	auipc	ra,0x0
 5a4:	eb4080e7          	jalr	-332(ra) # 454 <printint>
 5a8:	8bca                	mv	s7,s2
      state = 0;
 5aa:	4981                	li	s3,0
 5ac:	b751                	j	530 <vprintf+0x42>
        printint(fd, va_arg(ap, int), 16, 0);
 5ae:	008b8913          	addi	s2,s7,8
 5b2:	4681                	li	a3,0
 5b4:	4641                	li	a2,16
 5b6:	000ba583          	lw	a1,0(s7)
 5ba:	8556                	mv	a0,s5
 5bc:	00000097          	auipc	ra,0x0
 5c0:	e98080e7          	jalr	-360(ra) # 454 <printint>
 5c4:	8bca                	mv	s7,s2
      state = 0;
 5c6:	4981                	li	s3,0
 5c8:	b7a5                	j	530 <vprintf+0x42>
 5ca:	e062                	sd	s8,0(sp)
        printptr(fd, va_arg(ap, uint64));
 5cc:	008b8c13          	addi	s8,s7,8
 5d0:	000bb983          	ld	s3,0(s7)
  putc(fd, '0');
 5d4:	03000593          	li	a1,48
 5d8:	8556                	mv	a0,s5
 5da:	00000097          	auipc	ra,0x0
 5de:	e58080e7          	jalr	-424(ra) # 432 <putc>
  putc(fd, 'x');
 5e2:	07800593          	li	a1,120
 5e6:	8556                	mv	a0,s5
 5e8:	00000097          	auipc	ra,0x0
 5ec:	e4a080e7          	jalr	-438(ra) # 432 <putc>
 5f0:	4941                	li	s2,16
    putc(fd, digits[x >> (sizeof(uint64) * 8 - 4)]);
 5f2:	00000b97          	auipc	s7,0x0
 5f6:	59eb8b93          	addi	s7,s7,1438 # b90 <digits>
 5fa:	03c9d793          	srli	a5,s3,0x3c
 5fe:	97de                	add	a5,a5,s7
 600:	0007c583          	lbu	a1,0(a5)
 604:	8556                	mv	a0,s5
 606:	00000097          	auipc	ra,0x0
 60a:	e2c080e7          	jalr	-468(ra) # 432 <putc>
  for (i = 0; i < (sizeof(uint64) * 2); i++, x <<= 4)
 60e:	0992                	slli	s3,s3,0x4
 610:	397d                	addiw	s2,s2,-1
 612:	fe0914e3          	bnez	s2,5fa <vprintf+0x10c>
        printptr(fd, va_arg(ap, uint64));
 616:	8be2                	mv	s7,s8
      state = 0;
 618:	4981                	li	s3,0
 61a:	6c02                	ld	s8,0(sp)
 61c:	bf11                	j	530 <vprintf+0x42>
        s = va_arg(ap, char*);
 61e:	008b8993          	addi	s3,s7,8
 622:	000bb903          	ld	s2,0(s7)
        if(s == 0)
 626:	02090163          	beqz	s2,648 <vprintf+0x15a>
        while(*s != 0){
 62a:	00094583          	lbu	a1,0(s2)
 62e:	c9a5                	beqz	a1,69e <vprintf+0x1b0>
          putc(fd, *s);
 630:	8556                	mv	a0,s5
 632:	00000097          	auipc	ra,0x0
 636:	e00080e7          	jalr	-512(ra) # 432 <putc>
          s++;
 63a:	0905                	addi	s2,s2,1
        while(*s != 0){
 63c:	00094583          	lbu	a1,0(s2)
 640:	f9e5                	bnez	a1,630 <vprintf+0x142>
        s = va_arg(ap, char*);
 642:	8bce                	mv	s7,s3
      state = 0;
 644:	4981                	li	s3,0
 646:	b5ed                	j	530 <vprintf+0x42>
          s = "(null)";
 648:	00000917          	auipc	s2,0x0
 64c:	4b890913          	addi	s2,s2,1208 # b00 <ithread_join+0x5c>
        while(*s != 0){
 650:	02800593          	li	a1,40
 654:	bff1                	j	630 <vprintf+0x142>
        putc(fd, va_arg(ap, uint));
 656:	008b8913          	addi	s2,s7,8
 65a:	000bc583          	lbu	a1,0(s7)
 65e:	8556                	mv	a0,s5
 660:	00000097          	auipc	ra,0x0
 664:	dd2080e7          	jalr	-558(ra) # 432 <putc>
 668:	8bca                	mv	s7,s2
      state = 0;
 66a:	4981                	li	s3,0
 66c:	b5d1                	j	530 <vprintf+0x42>
        putc(fd, c);
 66e:	02500593          	li	a1,37
 672:	8556                	mv	a0,s5
 674:	00000097          	auipc	ra,0x0
 678:	dbe080e7          	jalr	-578(ra) # 432 <putc>
      state = 0;
 67c:	4981                	li	s3,0
 67e:	bd4d                	j	530 <vprintf+0x42>
        putc(fd, '%');
 680:	02500593          	li	a1,37
 684:	8556                	mv	a0,s5
 686:	00000097          	auipc	ra,0x0
 68a:	dac080e7          	jalr	-596(ra) # 432 <putc>
        putc(fd, c);
 68e:	85ca                	mv	a1,s2
 690:	8556                	mv	a0,s5
 692:	00000097          	auipc	ra,0x0
 696:	da0080e7          	jalr	-608(ra) # 432 <putc>
      state = 0;
 69a:	4981                	li	s3,0
 69c:	bd51                	j	530 <vprintf+0x42>
        s = va_arg(ap, char*);
 69e:	8bce                	mv	s7,s3
      state = 0;
 6a0:	4981                	li	s3,0
 6a2:	b579                	j	530 <vprintf+0x42>
 6a4:	74e2                	ld	s1,56(sp)
 6a6:	79a2                	ld	s3,40(sp)
 6a8:	7a02                	ld	s4,32(sp)
 6aa:	6ae2                	ld	s5,24(sp)
 6ac:	6b42                	ld	s6,16(sp)
 6ae:	6ba2                	ld	s7,8(sp)
    }
  }
}
 6b0:	60a6                	ld	ra,72(sp)
 6b2:	6406                	ld	s0,64(sp)
 6b4:	7942                	ld	s2,48(sp)
 6b6:	6161                	addi	sp,sp,80
 6b8:	8082                	ret

00000000000006ba <fprintf>:

void
fprintf(int fd, const char *fmt, ...)
{
 6ba:	715d                	addi	sp,sp,-80
 6bc:	ec06                	sd	ra,24(sp)
 6be:	e822                	sd	s0,16(sp)
 6c0:	1000                	addi	s0,sp,32
 6c2:	e010                	sd	a2,0(s0)
 6c4:	e414                	sd	a3,8(s0)
 6c6:	e818                	sd	a4,16(s0)
 6c8:	ec1c                	sd	a5,24(s0)
 6ca:	03043023          	sd	a6,32(s0)
 6ce:	03143423          	sd	a7,40(s0)
  va_list ap;

  va_start(ap, fmt);
 6d2:	8622                	mv	a2,s0
 6d4:	fe843423          	sd	s0,-24(s0)
  vprintf(fd, fmt, ap);
 6d8:	00000097          	auipc	ra,0x0
 6dc:	e16080e7          	jalr	-490(ra) # 4ee <vprintf>
}
 6e0:	60e2                	ld	ra,24(sp)
 6e2:	6442                	ld	s0,16(sp)
 6e4:	6161                	addi	sp,sp,80
 6e6:	8082                	ret

00000000000006e8 <printf>:

void
printf(const char *fmt, ...)
{
 6e8:	711d                	addi	sp,sp,-96
 6ea:	ec06                	sd	ra,24(sp)
 6ec:	e822                	sd	s0,16(sp)
 6ee:	1000                	addi	s0,sp,32
 6f0:	e40c                	sd	a1,8(s0)
 6f2:	e810                	sd	a2,16(s0)
 6f4:	ec14                	sd	a3,24(s0)
 6f6:	f018                	sd	a4,32(s0)
 6f8:	f41c                	sd	a5,40(s0)
 6fa:	03043823          	sd	a6,48(s0)
 6fe:	03143c23          	sd	a7,56(s0)
  va_list ap;

  va_start(ap, fmt);
 702:	00840613          	addi	a2,s0,8
 706:	fec43423          	sd	a2,-24(s0)
  vprintf(1, fmt, ap);
 70a:	85aa                	mv	a1,a0
 70c:	4505                	li	a0,1
 70e:	00000097          	auipc	ra,0x0
 712:	de0080e7          	jalr	-544(ra) # 4ee <vprintf>
}
 716:	60e2                	ld	ra,24(sp)
 718:	6442                	ld	s0,16(sp)
 71a:	6125                	addi	sp,sp,96
 71c:	8082                	ret

000000000000071e <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 71e:	1141                	addi	sp,sp,-16
 720:	e406                	sd	ra,8(sp)
 722:	e022                	sd	s0,0(sp)
 724:	0800                	addi	s0,sp,16
  Header *bp, *p;

  bp = (Header*)ap - 1;
 726:	ff050693          	addi	a3,a0,-16
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 72a:	00001797          	auipc	a5,0x1
 72e:	de67b783          	ld	a5,-538(a5) # 1510 <freep>
 732:	a02d                	j	75c <free+0x3e>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
      break;
  if(bp + bp->s.size == p->s.ptr){
    bp->s.size += p->s.ptr->s.size;
 734:	4618                	lw	a4,8(a2)
 736:	9f2d                	addw	a4,a4,a1
 738:	fee52c23          	sw	a4,-8(a0)
    bp->s.ptr = p->s.ptr->s.ptr;
 73c:	6398                	ld	a4,0(a5)
 73e:	6310                	ld	a2,0(a4)
 740:	a83d                	j	77e <free+0x60>
  } else
    bp->s.ptr = p->s.ptr;
  if(p + p->s.size == bp){
    p->s.size += bp->s.size;
 742:	ff852703          	lw	a4,-8(a0)
 746:	9f31                	addw	a4,a4,a2
 748:	c798                	sw	a4,8(a5)
    p->s.ptr = bp->s.ptr;
 74a:	ff053683          	ld	a3,-16(a0)
 74e:	a091                	j	792 <free+0x74>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 750:	6398                	ld	a4,0(a5)
 752:	00e7e463          	bltu	a5,a4,75a <free+0x3c>
 756:	00e6ea63          	bltu	a3,a4,76a <free+0x4c>
{
 75a:	87ba                	mv	a5,a4
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 75c:	fed7fae3          	bgeu	a5,a3,750 <free+0x32>
 760:	6398                	ld	a4,0(a5)
 762:	00e6e463          	bltu	a3,a4,76a <free+0x4c>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 766:	fee7eae3          	bltu	a5,a4,75a <free+0x3c>
  if(bp + bp->s.size == p->s.ptr){
 76a:	ff852583          	lw	a1,-8(a0)
 76e:	6390                	ld	a2,0(a5)
 770:	02059813          	slli	a6,a1,0x20
 774:	01c85713          	srli	a4,a6,0x1c
 778:	9736                	add	a4,a4,a3
 77a:	fae60de3          	beq	a2,a4,734 <free+0x16>
    bp->s.ptr = p->s.ptr->s.ptr;
 77e:	fec53823          	sd	a2,-16(a0)
  if(p + p->s.size == bp){
 782:	4790                	lw	a2,8(a5)
 784:	02061593          	slli	a1,a2,0x20
 788:	01c5d713          	srli	a4,a1,0x1c
 78c:	973e                	add	a4,a4,a5
 78e:	fae68ae3          	beq	a3,a4,742 <free+0x24>
    p->s.ptr = bp->s.ptr;
 792:	e394                	sd	a3,0(a5)
  } else
    p->s.ptr = bp;
  freep = p;
 794:	00001717          	auipc	a4,0x1
 798:	d6f73e23          	sd	a5,-644(a4) # 1510 <freep>
}
 79c:	60a2                	ld	ra,8(sp)
 79e:	6402                	ld	s0,0(sp)
 7a0:	0141                	addi	sp,sp,16
 7a2:	8082                	ret

00000000000007a4 <malloc>:
  return freep;
}

void*
malloc(uint nbytes)
{
 7a4:	7139                	addi	sp,sp,-64
 7a6:	fc06                	sd	ra,56(sp)
 7a8:	f822                	sd	s0,48(sp)
 7aa:	f04a                	sd	s2,32(sp)
 7ac:	ec4e                	sd	s3,24(sp)
 7ae:	0080                	addi	s0,sp,64
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 7b0:	02051993          	slli	s3,a0,0x20
 7b4:	0209d993          	srli	s3,s3,0x20
 7b8:	09bd                	addi	s3,s3,15
 7ba:	0049d993          	srli	s3,s3,0x4
 7be:	2985                	addiw	s3,s3,1
 7c0:	894e                	mv	s2,s3
  if((prevp = freep) == 0){
 7c2:	00001517          	auipc	a0,0x1
 7c6:	d4e53503          	ld	a0,-690(a0) # 1510 <freep>
 7ca:	c905                	beqz	a0,7fa <malloc+0x56>
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 7cc:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
 7ce:	4798                	lw	a4,8(a5)
 7d0:	09377a63          	bgeu	a4,s3,864 <malloc+0xc0>
 7d4:	f426                	sd	s1,40(sp)
 7d6:	e852                	sd	s4,16(sp)
 7d8:	e456                	sd	s5,8(sp)
 7da:	e05a                	sd	s6,0(sp)
  if(nu < 4096)
 7dc:	8a4e                	mv	s4,s3
 7de:	6705                	lui	a4,0x1
 7e0:	00e9f363          	bgeu	s3,a4,7e6 <malloc+0x42>
 7e4:	6a05                	lui	s4,0x1
 7e6:	000a0b1b          	sext.w	s6,s4
  p = sbrk(nu * sizeof(Header));
 7ea:	004a1a1b          	slliw	s4,s4,0x4
        p->s.size = nunits;
      }
      freep = prevp;
      return (void*)(p + 1);
    }
    if(p == freep)
 7ee:	00001497          	auipc	s1,0x1
 7f2:	d2248493          	addi	s1,s1,-734 # 1510 <freep>
  if(p == (char*)-1)
 7f6:	5afd                	li	s5,-1
 7f8:	a089                	j	83a <malloc+0x96>
 7fa:	f426                	sd	s1,40(sp)
 7fc:	e852                	sd	s4,16(sp)
 7fe:	e456                	sd	s5,8(sp)
 800:	e05a                	sd	s6,0(sp)
    base.s.ptr = freep = prevp = &base;
 802:	00001797          	auipc	a5,0x1
 806:	d2e78793          	addi	a5,a5,-722 # 1530 <base>
 80a:	00001717          	auipc	a4,0x1
 80e:	d0f73323          	sd	a5,-762(a4) # 1510 <freep>
 812:	e39c                	sd	a5,0(a5)
    base.s.size = 0;
 814:	0007a423          	sw	zero,8(a5)
    if(p->s.size >= nunits){
 818:	b7d1                	j	7dc <malloc+0x38>
        prevp->s.ptr = p->s.ptr;
 81a:	6398                	ld	a4,0(a5)
 81c:	e118                	sd	a4,0(a0)
 81e:	a8b9                	j	87c <malloc+0xd8>
  hp->s.size = nu;
 820:	01652423          	sw	s6,8(a0)
  free((void*)(hp + 1));
 824:	0541                	addi	a0,a0,16
 826:	00000097          	auipc	ra,0x0
 82a:	ef8080e7          	jalr	-264(ra) # 71e <free>
  return freep;
 82e:	6088                	ld	a0,0(s1)
      if((p = morecore(nunits)) == 0)
 830:	c135                	beqz	a0,894 <malloc+0xf0>
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 832:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
 834:	4798                	lw	a4,8(a5)
 836:	03277363          	bgeu	a4,s2,85c <malloc+0xb8>
    if(p == freep)
 83a:	6098                	ld	a4,0(s1)
 83c:	853e                	mv	a0,a5
 83e:	fef71ae3          	bne	a4,a5,832 <malloc+0x8e>
  p = sbrk(nu * sizeof(Header));
 842:	8552                	mv	a0,s4
 844:	00000097          	auipc	ra,0x0
 848:	b8e080e7          	jalr	-1138(ra) # 3d2 <sbrk>
  if(p == (char*)-1)
 84c:	fd551ae3          	bne	a0,s5,820 <malloc+0x7c>
        return 0;
 850:	4501                	li	a0,0
 852:	74a2                	ld	s1,40(sp)
 854:	6a42                	ld	s4,16(sp)
 856:	6aa2                	ld	s5,8(sp)
 858:	6b02                	ld	s6,0(sp)
 85a:	a03d                	j	888 <malloc+0xe4>
 85c:	74a2                	ld	s1,40(sp)
 85e:	6a42                	ld	s4,16(sp)
 860:	6aa2                	ld	s5,8(sp)
 862:	6b02                	ld	s6,0(sp)
      if(p->s.size == nunits)
 864:	fae90be3          	beq	s2,a4,81a <malloc+0x76>
        p->s.size -= nunits;
 868:	4137073b          	subw	a4,a4,s3
 86c:	c798                	sw	a4,8(a5)
        p += p->s.size;
 86e:	02071693          	slli	a3,a4,0x20
 872:	01c6d713          	srli	a4,a3,0x1c
 876:	97ba                	add	a5,a5,a4
        p->s.size = nunits;
 878:	0137a423          	sw	s3,8(a5)
      freep = prevp;
 87c:	00001717          	auipc	a4,0x1
 880:	c8a73a23          	sd	a0,-876(a4) # 1510 <freep>
      return (void*)(p + 1);
 884:	01078513          	addi	a0,a5,16
  }
}
 888:	70e2                	ld	ra,56(sp)
 88a:	7442                	ld	s0,48(sp)
 88c:	7902                	ld	s2,32(sp)
 88e:	69e2                	ld	s3,24(sp)
 890:	6121                	addi	sp,sp,64
 892:	8082                	ret
 894:	74a2                	ld	s1,40(sp)
 896:	6a42                	ld	s4,16(sp)
 898:	6aa2                	ld	s5,8(sp)
 89a:	6b02                	ld	s6,0(sp)
 89c:	b7f5                	j	888 <malloc+0xe4>

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
 8a6:	2501                	sext.w	a0,a0
 8a8:	00000097          	auipc	ra,0x0
 8ac:	b5a080e7          	jalr	-1190(ra) # 402 <thread_exit>
}
 8b0:	60a2                	ld	ra,8(sp)
 8b2:	6402                	ld	s0,0(sp)
 8b4:	0141                	addi	sp,sp,16
 8b6:	8082                	ret

00000000000008b8 <free_stacks>:
int free_stacks() {
 8b8:	7179                	addi	sp,sp,-48
 8ba:	f406                	sd	ra,40(sp)
 8bc:	f022                	sd	s0,32(sp)
 8be:	ec26                	sd	s1,24(sp)
 8c0:	1800                	addi	s0,sp,48
  for (int i = 0; i < num_threads; i++) {
 8c2:	00001797          	auipc	a5,0x1
 8c6:	c5e7a783          	lw	a5,-930(a5) # 1520 <num_threads>
 8ca:	04f05063          	blez	a5,90a <free_stacks+0x52>
 8ce:	e84a                	sd	s2,16(sp)
 8d0:	e44e                	sd	s3,8(sp)
 8d2:	4481                	li	s1,0
    free(stacks[i]);
 8d4:	00001997          	auipc	s3,0x1
 8d8:	c4498993          	addi	s3,s3,-956 # 1518 <stacks>
  for (int i = 0; i < num_threads; i++) {
 8dc:	00001917          	auipc	s2,0x1
 8e0:	c4490913          	addi	s2,s2,-956 # 1520 <num_threads>
    free(stacks[i]);
 8e4:	0009b783          	ld	a5,0(s3)
 8e8:	00349713          	slli	a4,s1,0x3
 8ec:	97ba                	add	a5,a5,a4
 8ee:	6388                	ld	a0,0(a5)
 8f0:	00000097          	auipc	ra,0x0
 8f4:	e2e080e7          	jalr	-466(ra) # 71e <free>
  for (int i = 0; i < num_threads; i++) {
 8f8:	0485                	addi	s1,s1,1
 8fa:	00092703          	lw	a4,0(s2)
 8fe:	0004879b          	sext.w	a5,s1
 902:	fee7c1e3          	blt	a5,a4,8e4 <free_stacks+0x2c>
 906:	6942                	ld	s2,16(sp)
 908:	69a2                	ld	s3,8(sp)
  free(stacks);
 90a:	00001497          	auipc	s1,0x1
 90e:	c0e48493          	addi	s1,s1,-1010 # 1518 <stacks>
 912:	6088                	ld	a0,0(s1)
 914:	00000097          	auipc	ra,0x0
 918:	e0a080e7          	jalr	-502(ra) # 71e <free>
  stacks = 0;
 91c:	0004b023          	sd	zero,0(s1)
  num_threads = 0;
 920:	00001797          	auipc	a5,0x1
 924:	c007a023          	sw	zero,-1024(a5) # 1520 <num_threads>
  max_stacks = INIT_MAX_STACKS;
 928:	47a1                	li	a5,8
 92a:	00001717          	auipc	a4,0x1
 92e:	bcf72b23          	sw	a5,-1066(a4) # 1500 <max_stacks>
  threads_done = 0;
 932:	00001797          	auipc	a5,0x1
 936:	be07a923          	sw	zero,-1038(a5) # 1524 <threads_done>
}
 93a:	4501                	li	a0,0
 93c:	70a2                	ld	ra,40(sp)
 93e:	7402                	ld	s0,32(sp)
 940:	64e2                	ld	s1,24(sp)
 942:	6145                	addi	sp,sp,48
 944:	8082                	ret

0000000000000946 <expand_num_threads>:
int expand_num_threads() {
 946:	1101                	addi	sp,sp,-32
 948:	ec06                	sd	ra,24(sp)
 94a:	e822                	sd	s0,16(sp)
 94c:	e426                	sd	s1,8(sp)
 94e:	e04a                	sd	s2,0(sp)
 950:	1000                	addi	s0,sp,32
  max_stacks *= 2;
 952:	00001797          	auipc	a5,0x1
 956:	bae78793          	addi	a5,a5,-1106 # 1500 <max_stacks>
 95a:	4388                	lw	a0,0(a5)
 95c:	0015151b          	slliw	a0,a0,0x1
 960:	c388                	sw	a0,0(a5)
  void **new_stacks = malloc(max_stacks*sizeof(char*));
 962:	0035151b          	slliw	a0,a0,0x3
 966:	00000097          	auipc	ra,0x0
 96a:	e3e080e7          	jalr	-450(ra) # 7a4 <malloc>
 96e:	892a                	mv	s2,a0
  memmove(new_stacks, stacks, num_threads*sizeof(char*));
 970:	00001617          	auipc	a2,0x1
 974:	bb062603          	lw	a2,-1104(a2) # 1520 <num_threads>
 978:	00001497          	auipc	s1,0x1
 97c:	ba048493          	addi	s1,s1,-1120 # 1518 <stacks>
 980:	0036161b          	slliw	a2,a2,0x3
 984:	608c                	ld	a1,0(s1)
 986:	00000097          	auipc	ra,0x0
 98a:	90a080e7          	jalr	-1782(ra) # 290 <memmove>
  free(stacks);
 98e:	6088                	ld	a0,0(s1)
 990:	00000097          	auipc	ra,0x0
 994:	d8e080e7          	jalr	-626(ra) # 71e <free>
  stacks = new_stacks;
 998:	0124b023          	sd	s2,0(s1)
}
 99c:	4501                	li	a0,0
 99e:	60e2                	ld	ra,24(sp)
 9a0:	6442                	ld	s0,16(sp)
 9a2:	64a2                	ld	s1,8(sp)
 9a4:	6902                	ld	s2,0(sp)
 9a6:	6105                	addi	sp,sp,32
 9a8:	8082                	ret

00000000000009aa <ithread_create>:

int ithread_create(void* (*fn_ptr)(void *), void *args) {
 9aa:	7179                	addi	sp,sp,-48
 9ac:	f406                	sd	ra,40(sp)
 9ae:	f022                	sd	s0,32(sp)
 9b0:	e84a                	sd	s2,16(sp)
 9b2:	e44e                	sd	s3,8(sp)
 9b4:	1800                	addi	s0,sp,48
 9b6:	892a                	mv	s2,a0
 9b8:	89ae                	mv	s3,a1
  if (stacks == 0) {
 9ba:	00001797          	auipc	a5,0x1
 9be:	b5e7b783          	ld	a5,-1186(a5) # 1518 <stacks>
 9c2:	c3d9                	beqz	a5,a48 <ithread_create+0x9e>
    stacks = malloc(max_stacks*sizeof(char*));
  }
  if (num_threads == max_stacks) {
 9c4:	00001797          	auipc	a5,0x1
 9c8:	b3c7a783          	lw	a5,-1220(a5) # 1500 <max_stacks>
 9cc:	00001717          	auipc	a4,0x1
 9d0:	b5472703          	lw	a4,-1196(a4) # 1520 <num_threads>
 9d4:	0af71363          	bne	a4,a5,a7a <ithread_create+0xd0>
    if (max_stacks == MAX_THREADS) {
 9d8:	04000713          	li	a4,64
 9dc:	08e78563          	beq	a5,a4,a66 <ithread_create+0xbc>
 9e0:	ec26                	sd	s1,24(sp)
      printf("ERROR: Thread capacity has been reached\n");
      return -1;
    }
    expand_num_threads();
 9e2:	00000097          	auipc	ra,0x0
 9e6:	f64080e7          	jalr	-156(ra) # 946 <expand_num_threads>
  }

  void *stack_ptr = malloc(PGSIZE);
 9ea:	6505                	lui	a0,0x1
 9ec:	00000097          	auipc	ra,0x0
 9f0:	db8080e7          	jalr	-584(ra) # 7a4 <malloc>
 9f4:	84aa                	mv	s1,a0
  stacks[num_threads] = stack_ptr;
 9f6:	00001717          	auipc	a4,0x1
 9fa:	b2a72703          	lw	a4,-1238(a4) # 1520 <num_threads>
 9fe:	070e                	slli	a4,a4,0x3
 a00:	00001797          	auipc	a5,0x1
 a04:	b187b783          	ld	a5,-1256(a5) # 1518 <stacks>
 a08:	97ba                	add	a5,a5,a4
 a0a:	e388                	sd	a0,0(a5)
  int res = create_thread(fn_ptr, args, stack_ptr, &ithread_exit);
 a0c:	00000697          	auipc	a3,0x0
 a10:	e9268693          	addi	a3,a3,-366 # 89e <ithread_exit>
 a14:	862a                	mv	a2,a0
 a16:	85ce                	mv	a1,s3
 a18:	854a                	mv	a0,s2
 a1a:	00000097          	auipc	ra,0x0
 a1e:	9d8080e7          	jalr	-1576(ra) # 3f2 <create_thread>
 a22:	892a                	mv	s2,a0
  if (res != -1) {
 a24:	57fd                	li	a5,-1
 a26:	04f50c63          	beq	a0,a5,a7e <ithread_create+0xd4>
    num_threads++;
 a2a:	00001717          	auipc	a4,0x1
 a2e:	af670713          	addi	a4,a4,-1290 # 1520 <num_threads>
 a32:	431c                	lw	a5,0(a4)
 a34:	2785                	addiw	a5,a5,1
 a36:	c31c                	sw	a5,0(a4)
 a38:	64e2                	ld	s1,24(sp)
  } else {
    free(stack_ptr);
    stacks[num_threads] = 0;
  }
  return res;
}
 a3a:	854a                	mv	a0,s2
 a3c:	70a2                	ld	ra,40(sp)
 a3e:	7402                	ld	s0,32(sp)
 a40:	6942                	ld	s2,16(sp)
 a42:	69a2                	ld	s3,8(sp)
 a44:	6145                	addi	sp,sp,48
 a46:	8082                	ret
    stacks = malloc(max_stacks*sizeof(char*));
 a48:	00001517          	auipc	a0,0x1
 a4c:	ab852503          	lw	a0,-1352(a0) # 1500 <max_stacks>
 a50:	0035151b          	slliw	a0,a0,0x3
 a54:	00000097          	auipc	ra,0x0
 a58:	d50080e7          	jalr	-688(ra) # 7a4 <malloc>
 a5c:	00001797          	auipc	a5,0x1
 a60:	aaa7be23          	sd	a0,-1348(a5) # 1518 <stacks>
 a64:	b785                	j	9c4 <ithread_create+0x1a>
      printf("ERROR: Thread capacity has been reached\n");
 a66:	00000517          	auipc	a0,0x0
 a6a:	0a250513          	addi	a0,a0,162 # b08 <ithread_join+0x64>
 a6e:	00000097          	auipc	ra,0x0
 a72:	c7a080e7          	jalr	-902(ra) # 6e8 <printf>
      return -1;
 a76:	597d                	li	s2,-1
 a78:	b7c9                	j	a3a <ithread_create+0x90>
 a7a:	ec26                	sd	s1,24(sp)
 a7c:	b7bd                	j	9ea <ithread_create+0x40>
    free(stack_ptr);
 a7e:	8526                	mv	a0,s1
 a80:	00000097          	auipc	ra,0x0
 a84:	c9e080e7          	jalr	-866(ra) # 71e <free>
    stacks[num_threads] = 0;
 a88:	00001717          	auipc	a4,0x1
 a8c:	a9872703          	lw	a4,-1384(a4) # 1520 <num_threads>
 a90:	070e                	slli	a4,a4,0x3
 a92:	00001797          	auipc	a5,0x1
 a96:	a867b783          	ld	a5,-1402(a5) # 1518 <stacks>
 a9a:	97ba                	add	a5,a5,a4
 a9c:	0007b023          	sd	zero,0(a5)
 aa0:	64e2                	ld	s1,24(sp)
 aa2:	bf61                	j	a3a <ithread_create+0x90>

0000000000000aa4 <ithread_join>:

int ithread_join(int thread_id) {
 aa4:	1101                	addi	sp,sp,-32
 aa6:	ec06                	sd	ra,24(sp)
 aa8:	e822                	sd	s0,16(sp)
 aaa:	1000                	addi	s0,sp,32
  int status;
  join_thread(thread_id, (uint64)&status);
 aac:	ff040793          	addi	a5,s0,-16
 ab0:	ffc7859b          	addiw	a1,a5,-4
 ab4:	00000097          	auipc	ra,0x0
 ab8:	946080e7          	jalr	-1722(ra) # 3fa <join_thread>
  threads_done++;
 abc:	00001717          	auipc	a4,0x1
 ac0:	a6870713          	addi	a4,a4,-1432 # 1524 <threads_done>
 ac4:	431c                	lw	a5,0(a4)
 ac6:	2785                	addiw	a5,a5,1
 ac8:	c31c                	sw	a5,0(a4)
  if (threads_done == num_threads) {
 aca:	00001717          	auipc	a4,0x1
 ace:	a5672703          	lw	a4,-1450(a4) # 1520 <num_threads>
 ad2:	00f70863          	beq	a4,a5,ae2 <ithread_join+0x3e>
    free_stacks();
  }
  return status;
}
 ad6:	fec42503          	lw	a0,-20(s0)
 ada:	60e2                	ld	ra,24(sp)
 adc:	6442                	ld	s0,16(sp)
 ade:	6105                	addi	sp,sp,32
 ae0:	8082                	ret
    free_stacks();
 ae2:	00000097          	auipc	ra,0x0
 ae6:	dd6080e7          	jalr	-554(ra) # 8b8 <free_stacks>
 aea:	b7f5                	j	ad6 <ithread_join+0x32>
