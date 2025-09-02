
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
  38:	aecb0b13          	addi	s6,s6,-1300 # b20 <ithread_join+0x56>
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
  78:	ab458593          	addi	a1,a1,-1356 # b28 <ithread_join+0x5e>
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

0000000000000432 <send>:
.global send
send:
 li a7, SYS_send
 432:	48fd                	li	a7,31
 ecall
 434:	00000073          	ecall
 ret
 438:	8082                	ret

000000000000043a <recv>:
.global recv
recv:
 li a7, SYS_recv
 43a:	02000893          	li	a7,32
 ecall
 43e:	00000073          	ecall
 ret
 442:	8082                	ret

0000000000000444 <sendto>:
.global sendto
sendto:
 li a7, SYS_sendto
 444:	02100893          	li	a7,33
 ecall
 448:	00000073          	ecall
 ret
 44c:	8082                	ret

000000000000044e <recvfrom>:
.global recvfrom
recvfrom:
 li a7, SYS_recvfrom
 44e:	02200893          	li	a7,34
 ecall
 452:	00000073          	ecall
 ret
 456:	8082                	ret

0000000000000458 <putc>:

static char digits[] = "0123456789ABCDEF";

static void
putc(int fd, char c)
{
 458:	1101                	addi	sp,sp,-32
 45a:	ec06                	sd	ra,24(sp)
 45c:	e822                	sd	s0,16(sp)
 45e:	1000                	addi	s0,sp,32
 460:	feb407a3          	sb	a1,-17(s0)
  write(fd, &c, 1);
 464:	4605                	li	a2,1
 466:	fef40593          	addi	a1,s0,-17
 46a:	00000097          	auipc	ra,0x0
 46e:	f00080e7          	jalr	-256(ra) # 36a <write>
}
 472:	60e2                	ld	ra,24(sp)
 474:	6442                	ld	s0,16(sp)
 476:	6105                	addi	sp,sp,32
 478:	8082                	ret

000000000000047a <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
 47a:	7139                	addi	sp,sp,-64
 47c:	fc06                	sd	ra,56(sp)
 47e:	f822                	sd	s0,48(sp)
 480:	f426                	sd	s1,40(sp)
 482:	f04a                	sd	s2,32(sp)
 484:	ec4e                	sd	s3,24(sp)
 486:	0080                	addi	s0,sp,64
 488:	892a                	mv	s2,a0
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
  if(sgn && xx < 0){
 48a:	c299                	beqz	a3,490 <printint+0x16>
 48c:	0805c063          	bltz	a1,50c <printint+0x92>
  neg = 0;
 490:	4e01                	li	t3,0
    x = -xx;
  } else {
    x = xx;
  }

  i = 0;
 492:	fc040313          	addi	t1,s0,-64
  neg = 0;
 496:	869a                	mv	a3,t1
  i = 0;
 498:	4781                	li	a5,0
  do{
    buf[i++] = digits[x % base];
 49a:	00000817          	auipc	a6,0x0
 49e:	72680813          	addi	a6,a6,1830 # bc0 <digits>
 4a2:	88be                	mv	a7,a5
 4a4:	0017851b          	addiw	a0,a5,1
 4a8:	87aa                	mv	a5,a0
 4aa:	02c5f73b          	remuw	a4,a1,a2
 4ae:	1702                	slli	a4,a4,0x20
 4b0:	9301                	srli	a4,a4,0x20
 4b2:	9742                	add	a4,a4,a6
 4b4:	00074703          	lbu	a4,0(a4)
 4b8:	00e68023          	sb	a4,0(a3)
  }while((x /= base) != 0);
 4bc:	872e                	mv	a4,a1
 4be:	02c5d5bb          	divuw	a1,a1,a2
 4c2:	0685                	addi	a3,a3,1
 4c4:	fcc77fe3          	bgeu	a4,a2,4a2 <printint+0x28>
  if(neg)
 4c8:	000e0c63          	beqz	t3,4e0 <printint+0x66>
    buf[i++] = '-';
 4cc:	fd050793          	addi	a5,a0,-48
 4d0:	00878533          	add	a0,a5,s0
 4d4:	02d00793          	li	a5,45
 4d8:	fef50823          	sb	a5,-16(a0)
 4dc:	0028879b          	addiw	a5,a7,2

  while(--i >= 0)
 4e0:	fff7899b          	addiw	s3,a5,-1
 4e4:	006784b3          	add	s1,a5,t1
    putc(fd, buf[i]);
 4e8:	fff4c583          	lbu	a1,-1(s1)
 4ec:	854a                	mv	a0,s2
 4ee:	00000097          	auipc	ra,0x0
 4f2:	f6a080e7          	jalr	-150(ra) # 458 <putc>
  while(--i >= 0)
 4f6:	39fd                	addiw	s3,s3,-1
 4f8:	14fd                	addi	s1,s1,-1
 4fa:	fe09d7e3          	bgez	s3,4e8 <printint+0x6e>
}
 4fe:	70e2                	ld	ra,56(sp)
 500:	7442                	ld	s0,48(sp)
 502:	74a2                	ld	s1,40(sp)
 504:	7902                	ld	s2,32(sp)
 506:	69e2                	ld	s3,24(sp)
 508:	6121                	addi	sp,sp,64
 50a:	8082                	ret
    x = -xx;
 50c:	40b005bb          	negw	a1,a1
    neg = 1;
 510:	4e05                	li	t3,1
    x = -xx;
 512:	b741                	j	492 <printint+0x18>

0000000000000514 <vprintf>:
}

// Print to the given fd. Only understands %d, %x, %p, %s.
void
vprintf(int fd, const char *fmt, va_list ap)
{
 514:	715d                	addi	sp,sp,-80
 516:	e486                	sd	ra,72(sp)
 518:	e0a2                	sd	s0,64(sp)
 51a:	f84a                	sd	s2,48(sp)
 51c:	0880                	addi	s0,sp,80
  char *s;
  int c, i, state;

  state = 0;
  for(i = 0; fmt[i]; i++){
 51e:	0005c903          	lbu	s2,0(a1)
 522:	1a090a63          	beqz	s2,6d6 <vprintf+0x1c2>
 526:	fc26                	sd	s1,56(sp)
 528:	f44e                	sd	s3,40(sp)
 52a:	f052                	sd	s4,32(sp)
 52c:	ec56                	sd	s5,24(sp)
 52e:	e85a                	sd	s6,16(sp)
 530:	e45e                	sd	s7,8(sp)
 532:	8aaa                	mv	s5,a0
 534:	8bb2                	mv	s7,a2
 536:	00158493          	addi	s1,a1,1
  state = 0;
 53a:	4981                	li	s3,0
      if(c == '%'){
        state = '%';
      } else {
        putc(fd, c);
      }
    } else if(state == '%'){
 53c:	02500a13          	li	s4,37
 540:	4b55                	li	s6,21
 542:	a839                	j	560 <vprintf+0x4c>
        putc(fd, c);
 544:	85ca                	mv	a1,s2
 546:	8556                	mv	a0,s5
 548:	00000097          	auipc	ra,0x0
 54c:	f10080e7          	jalr	-240(ra) # 458 <putc>
 550:	a019                	j	556 <vprintf+0x42>
    } else if(state == '%'){
 552:	01498d63          	beq	s3,s4,56c <vprintf+0x58>
  for(i = 0; fmt[i]; i++){
 556:	0485                	addi	s1,s1,1
 558:	fff4c903          	lbu	s2,-1(s1)
 55c:	16090763          	beqz	s2,6ca <vprintf+0x1b6>
    if(state == 0){
 560:	fe0999e3          	bnez	s3,552 <vprintf+0x3e>
      if(c == '%'){
 564:	ff4910e3          	bne	s2,s4,544 <vprintf+0x30>
        state = '%';
 568:	89d2                	mv	s3,s4
 56a:	b7f5                	j	556 <vprintf+0x42>
      if(c == 'd'){
 56c:	13490463          	beq	s2,s4,694 <vprintf+0x180>
 570:	f9d9079b          	addiw	a5,s2,-99
 574:	0ff7f793          	zext.b	a5,a5
 578:	12fb6763          	bltu	s6,a5,6a6 <vprintf+0x192>
 57c:	f9d9079b          	addiw	a5,s2,-99
 580:	0ff7f713          	zext.b	a4,a5
 584:	12eb6163          	bltu	s6,a4,6a6 <vprintf+0x192>
 588:	00271793          	slli	a5,a4,0x2
 58c:	00000717          	auipc	a4,0x0
 590:	5dc70713          	addi	a4,a4,1500 # b68 <ithread_join+0x9e>
 594:	97ba                	add	a5,a5,a4
 596:	439c                	lw	a5,0(a5)
 598:	97ba                	add	a5,a5,a4
 59a:	8782                	jr	a5
        printint(fd, va_arg(ap, int), 10, 1);
 59c:	008b8913          	addi	s2,s7,8
 5a0:	4685                	li	a3,1
 5a2:	4629                	li	a2,10
 5a4:	000ba583          	lw	a1,0(s7)
 5a8:	8556                	mv	a0,s5
 5aa:	00000097          	auipc	ra,0x0
 5ae:	ed0080e7          	jalr	-304(ra) # 47a <printint>
 5b2:	8bca                	mv	s7,s2
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
        putc(fd, c);
      }
      state = 0;
 5b4:	4981                	li	s3,0
 5b6:	b745                	j	556 <vprintf+0x42>
        printint(fd, va_arg(ap, uint64), 10, 0);
 5b8:	008b8913          	addi	s2,s7,8
 5bc:	4681                	li	a3,0
 5be:	4629                	li	a2,10
 5c0:	000ba583          	lw	a1,0(s7)
 5c4:	8556                	mv	a0,s5
 5c6:	00000097          	auipc	ra,0x0
 5ca:	eb4080e7          	jalr	-332(ra) # 47a <printint>
 5ce:	8bca                	mv	s7,s2
      state = 0;
 5d0:	4981                	li	s3,0
 5d2:	b751                	j	556 <vprintf+0x42>
        printint(fd, va_arg(ap, int), 16, 0);
 5d4:	008b8913          	addi	s2,s7,8
 5d8:	4681                	li	a3,0
 5da:	4641                	li	a2,16
 5dc:	000ba583          	lw	a1,0(s7)
 5e0:	8556                	mv	a0,s5
 5e2:	00000097          	auipc	ra,0x0
 5e6:	e98080e7          	jalr	-360(ra) # 47a <printint>
 5ea:	8bca                	mv	s7,s2
      state = 0;
 5ec:	4981                	li	s3,0
 5ee:	b7a5                	j	556 <vprintf+0x42>
 5f0:	e062                	sd	s8,0(sp)
        printptr(fd, va_arg(ap, uint64));
 5f2:	008b8c13          	addi	s8,s7,8
 5f6:	000bb983          	ld	s3,0(s7)
  putc(fd, '0');
 5fa:	03000593          	li	a1,48
 5fe:	8556                	mv	a0,s5
 600:	00000097          	auipc	ra,0x0
 604:	e58080e7          	jalr	-424(ra) # 458 <putc>
  putc(fd, 'x');
 608:	07800593          	li	a1,120
 60c:	8556                	mv	a0,s5
 60e:	00000097          	auipc	ra,0x0
 612:	e4a080e7          	jalr	-438(ra) # 458 <putc>
 616:	4941                	li	s2,16
    putc(fd, digits[x >> (sizeof(uint64) * 8 - 4)]);
 618:	00000b97          	auipc	s7,0x0
 61c:	5a8b8b93          	addi	s7,s7,1448 # bc0 <digits>
 620:	03c9d793          	srli	a5,s3,0x3c
 624:	97de                	add	a5,a5,s7
 626:	0007c583          	lbu	a1,0(a5)
 62a:	8556                	mv	a0,s5
 62c:	00000097          	auipc	ra,0x0
 630:	e2c080e7          	jalr	-468(ra) # 458 <putc>
  for (i = 0; i < (sizeof(uint64) * 2); i++, x <<= 4)
 634:	0992                	slli	s3,s3,0x4
 636:	397d                	addiw	s2,s2,-1
 638:	fe0914e3          	bnez	s2,620 <vprintf+0x10c>
        printptr(fd, va_arg(ap, uint64));
 63c:	8be2                	mv	s7,s8
      state = 0;
 63e:	4981                	li	s3,0
 640:	6c02                	ld	s8,0(sp)
 642:	bf11                	j	556 <vprintf+0x42>
        s = va_arg(ap, char*);
 644:	008b8993          	addi	s3,s7,8
 648:	000bb903          	ld	s2,0(s7)
        if(s == 0)
 64c:	02090163          	beqz	s2,66e <vprintf+0x15a>
        while(*s != 0){
 650:	00094583          	lbu	a1,0(s2)
 654:	c9a5                	beqz	a1,6c4 <vprintf+0x1b0>
          putc(fd, *s);
 656:	8556                	mv	a0,s5
 658:	00000097          	auipc	ra,0x0
 65c:	e00080e7          	jalr	-512(ra) # 458 <putc>
          s++;
 660:	0905                	addi	s2,s2,1
        while(*s != 0){
 662:	00094583          	lbu	a1,0(s2)
 666:	f9e5                	bnez	a1,656 <vprintf+0x142>
        s = va_arg(ap, char*);
 668:	8bce                	mv	s7,s3
      state = 0;
 66a:	4981                	li	s3,0
 66c:	b5ed                	j	556 <vprintf+0x42>
          s = "(null)";
 66e:	00000917          	auipc	s2,0x0
 672:	4c290913          	addi	s2,s2,1218 # b30 <ithread_join+0x66>
        while(*s != 0){
 676:	02800593          	li	a1,40
 67a:	bff1                	j	656 <vprintf+0x142>
        putc(fd, va_arg(ap, uint));
 67c:	008b8913          	addi	s2,s7,8
 680:	000bc583          	lbu	a1,0(s7)
 684:	8556                	mv	a0,s5
 686:	00000097          	auipc	ra,0x0
 68a:	dd2080e7          	jalr	-558(ra) # 458 <putc>
 68e:	8bca                	mv	s7,s2
      state = 0;
 690:	4981                	li	s3,0
 692:	b5d1                	j	556 <vprintf+0x42>
        putc(fd, c);
 694:	02500593          	li	a1,37
 698:	8556                	mv	a0,s5
 69a:	00000097          	auipc	ra,0x0
 69e:	dbe080e7          	jalr	-578(ra) # 458 <putc>
      state = 0;
 6a2:	4981                	li	s3,0
 6a4:	bd4d                	j	556 <vprintf+0x42>
        putc(fd, '%');
 6a6:	02500593          	li	a1,37
 6aa:	8556                	mv	a0,s5
 6ac:	00000097          	auipc	ra,0x0
 6b0:	dac080e7          	jalr	-596(ra) # 458 <putc>
        putc(fd, c);
 6b4:	85ca                	mv	a1,s2
 6b6:	8556                	mv	a0,s5
 6b8:	00000097          	auipc	ra,0x0
 6bc:	da0080e7          	jalr	-608(ra) # 458 <putc>
      state = 0;
 6c0:	4981                	li	s3,0
 6c2:	bd51                	j	556 <vprintf+0x42>
        s = va_arg(ap, char*);
 6c4:	8bce                	mv	s7,s3
      state = 0;
 6c6:	4981                	li	s3,0
 6c8:	b579                	j	556 <vprintf+0x42>
 6ca:	74e2                	ld	s1,56(sp)
 6cc:	79a2                	ld	s3,40(sp)
 6ce:	7a02                	ld	s4,32(sp)
 6d0:	6ae2                	ld	s5,24(sp)
 6d2:	6b42                	ld	s6,16(sp)
 6d4:	6ba2                	ld	s7,8(sp)
    }
  }
}
 6d6:	60a6                	ld	ra,72(sp)
 6d8:	6406                	ld	s0,64(sp)
 6da:	7942                	ld	s2,48(sp)
 6dc:	6161                	addi	sp,sp,80
 6de:	8082                	ret

00000000000006e0 <fprintf>:

void
fprintf(int fd, const char *fmt, ...)
{
 6e0:	715d                	addi	sp,sp,-80
 6e2:	ec06                	sd	ra,24(sp)
 6e4:	e822                	sd	s0,16(sp)
 6e6:	1000                	addi	s0,sp,32
 6e8:	e010                	sd	a2,0(s0)
 6ea:	e414                	sd	a3,8(s0)
 6ec:	e818                	sd	a4,16(s0)
 6ee:	ec1c                	sd	a5,24(s0)
 6f0:	03043023          	sd	a6,32(s0)
 6f4:	03143423          	sd	a7,40(s0)
  va_list ap;

  va_start(ap, fmt);
 6f8:	8622                	mv	a2,s0
 6fa:	fe843423          	sd	s0,-24(s0)
  vprintf(fd, fmt, ap);
 6fe:	00000097          	auipc	ra,0x0
 702:	e16080e7          	jalr	-490(ra) # 514 <vprintf>
}
 706:	60e2                	ld	ra,24(sp)
 708:	6442                	ld	s0,16(sp)
 70a:	6161                	addi	sp,sp,80
 70c:	8082                	ret

000000000000070e <printf>:

void
printf(const char *fmt, ...)
{
 70e:	711d                	addi	sp,sp,-96
 710:	ec06                	sd	ra,24(sp)
 712:	e822                	sd	s0,16(sp)
 714:	1000                	addi	s0,sp,32
 716:	e40c                	sd	a1,8(s0)
 718:	e810                	sd	a2,16(s0)
 71a:	ec14                	sd	a3,24(s0)
 71c:	f018                	sd	a4,32(s0)
 71e:	f41c                	sd	a5,40(s0)
 720:	03043823          	sd	a6,48(s0)
 724:	03143c23          	sd	a7,56(s0)
  va_list ap;

  va_start(ap, fmt);
 728:	00840613          	addi	a2,s0,8
 72c:	fec43423          	sd	a2,-24(s0)
  vprintf(1, fmt, ap);
 730:	85aa                	mv	a1,a0
 732:	4505                	li	a0,1
 734:	00000097          	auipc	ra,0x0
 738:	de0080e7          	jalr	-544(ra) # 514 <vprintf>
}
 73c:	60e2                	ld	ra,24(sp)
 73e:	6442                	ld	s0,16(sp)
 740:	6125                	addi	sp,sp,96
 742:	8082                	ret

0000000000000744 <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 744:	1141                	addi	sp,sp,-16
 746:	e406                	sd	ra,8(sp)
 748:	e022                	sd	s0,0(sp)
 74a:	0800                	addi	s0,sp,16
  Header *bp, *p;

  bp = (Header*)ap - 1;
 74c:	ff050693          	addi	a3,a0,-16
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 750:	00001797          	auipc	a5,0x1
 754:	dc07b783          	ld	a5,-576(a5) # 1510 <freep>
 758:	a02d                	j	782 <free+0x3e>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
      break;
  if(bp + bp->s.size == p->s.ptr){
    bp->s.size += p->s.ptr->s.size;
 75a:	4618                	lw	a4,8(a2)
 75c:	9f2d                	addw	a4,a4,a1
 75e:	fee52c23          	sw	a4,-8(a0)
    bp->s.ptr = p->s.ptr->s.ptr;
 762:	6398                	ld	a4,0(a5)
 764:	6310                	ld	a2,0(a4)
 766:	a83d                	j	7a4 <free+0x60>
  } else
    bp->s.ptr = p->s.ptr;
  if(p + p->s.size == bp){
    p->s.size += bp->s.size;
 768:	ff852703          	lw	a4,-8(a0)
 76c:	9f31                	addw	a4,a4,a2
 76e:	c798                	sw	a4,8(a5)
    p->s.ptr = bp->s.ptr;
 770:	ff053683          	ld	a3,-16(a0)
 774:	a091                	j	7b8 <free+0x74>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 776:	6398                	ld	a4,0(a5)
 778:	00e7e463          	bltu	a5,a4,780 <free+0x3c>
 77c:	00e6ea63          	bltu	a3,a4,790 <free+0x4c>
{
 780:	87ba                	mv	a5,a4
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 782:	fed7fae3          	bgeu	a5,a3,776 <free+0x32>
 786:	6398                	ld	a4,0(a5)
 788:	00e6e463          	bltu	a3,a4,790 <free+0x4c>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 78c:	fee7eae3          	bltu	a5,a4,780 <free+0x3c>
  if(bp + bp->s.size == p->s.ptr){
 790:	ff852583          	lw	a1,-8(a0)
 794:	6390                	ld	a2,0(a5)
 796:	02059813          	slli	a6,a1,0x20
 79a:	01c85713          	srli	a4,a6,0x1c
 79e:	9736                	add	a4,a4,a3
 7a0:	fae60de3          	beq	a2,a4,75a <free+0x16>
    bp->s.ptr = p->s.ptr->s.ptr;
 7a4:	fec53823          	sd	a2,-16(a0)
  if(p + p->s.size == bp){
 7a8:	4790                	lw	a2,8(a5)
 7aa:	02061593          	slli	a1,a2,0x20
 7ae:	01c5d713          	srli	a4,a1,0x1c
 7b2:	973e                	add	a4,a4,a5
 7b4:	fae68ae3          	beq	a3,a4,768 <free+0x24>
    p->s.ptr = bp->s.ptr;
 7b8:	e394                	sd	a3,0(a5)
  } else
    p->s.ptr = bp;
  freep = p;
 7ba:	00001717          	auipc	a4,0x1
 7be:	d4f73b23          	sd	a5,-682(a4) # 1510 <freep>
}
 7c2:	60a2                	ld	ra,8(sp)
 7c4:	6402                	ld	s0,0(sp)
 7c6:	0141                	addi	sp,sp,16
 7c8:	8082                	ret

00000000000007ca <malloc>:
  return freep;
}

void*
malloc(uint nbytes)
{
 7ca:	7139                	addi	sp,sp,-64
 7cc:	fc06                	sd	ra,56(sp)
 7ce:	f822                	sd	s0,48(sp)
 7d0:	f04a                	sd	s2,32(sp)
 7d2:	ec4e                	sd	s3,24(sp)
 7d4:	0080                	addi	s0,sp,64
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 7d6:	02051993          	slli	s3,a0,0x20
 7da:	0209d993          	srli	s3,s3,0x20
 7de:	09bd                	addi	s3,s3,15
 7e0:	0049d993          	srli	s3,s3,0x4
 7e4:	2985                	addiw	s3,s3,1
 7e6:	894e                	mv	s2,s3
  if((prevp = freep) == 0){
 7e8:	00001517          	auipc	a0,0x1
 7ec:	d2853503          	ld	a0,-728(a0) # 1510 <freep>
 7f0:	c905                	beqz	a0,820 <malloc+0x56>
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 7f2:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
 7f4:	4798                	lw	a4,8(a5)
 7f6:	09377a63          	bgeu	a4,s3,88a <malloc+0xc0>
 7fa:	f426                	sd	s1,40(sp)
 7fc:	e852                	sd	s4,16(sp)
 7fe:	e456                	sd	s5,8(sp)
 800:	e05a                	sd	s6,0(sp)
  if(nu < 4096)
 802:	8a4e                	mv	s4,s3
 804:	6705                	lui	a4,0x1
 806:	00e9f363          	bgeu	s3,a4,80c <malloc+0x42>
 80a:	6a05                	lui	s4,0x1
 80c:	000a0b1b          	sext.w	s6,s4
  p = sbrk(nu * sizeof(Header));
 810:	004a1a1b          	slliw	s4,s4,0x4
        p->s.size = nunits;
      }
      freep = prevp;
      return (void*)(p + 1);
    }
    if(p == freep)
 814:	00001497          	auipc	s1,0x1
 818:	cfc48493          	addi	s1,s1,-772 # 1510 <freep>
  if(p == (char*)-1)
 81c:	5afd                	li	s5,-1
 81e:	a089                	j	860 <malloc+0x96>
 820:	f426                	sd	s1,40(sp)
 822:	e852                	sd	s4,16(sp)
 824:	e456                	sd	s5,8(sp)
 826:	e05a                	sd	s6,0(sp)
    base.s.ptr = freep = prevp = &base;
 828:	00001797          	auipc	a5,0x1
 82c:	d0878793          	addi	a5,a5,-760 # 1530 <base>
 830:	00001717          	auipc	a4,0x1
 834:	cef73023          	sd	a5,-800(a4) # 1510 <freep>
 838:	e39c                	sd	a5,0(a5)
    base.s.size = 0;
 83a:	0007a423          	sw	zero,8(a5)
    if(p->s.size >= nunits){
 83e:	b7d1                	j	802 <malloc+0x38>
        prevp->s.ptr = p->s.ptr;
 840:	6398                	ld	a4,0(a5)
 842:	e118                	sd	a4,0(a0)
 844:	a8b9                	j	8a2 <malloc+0xd8>
  hp->s.size = nu;
 846:	01652423          	sw	s6,8(a0)
  free((void*)(hp + 1));
 84a:	0541                	addi	a0,a0,16
 84c:	00000097          	auipc	ra,0x0
 850:	ef8080e7          	jalr	-264(ra) # 744 <free>
  return freep;
 854:	6088                	ld	a0,0(s1)
      if((p = morecore(nunits)) == 0)
 856:	c135                	beqz	a0,8ba <malloc+0xf0>
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 858:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
 85a:	4798                	lw	a4,8(a5)
 85c:	03277363          	bgeu	a4,s2,882 <malloc+0xb8>
    if(p == freep)
 860:	6098                	ld	a4,0(s1)
 862:	853e                	mv	a0,a5
 864:	fef71ae3          	bne	a4,a5,858 <malloc+0x8e>
  p = sbrk(nu * sizeof(Header));
 868:	8552                	mv	a0,s4
 86a:	00000097          	auipc	ra,0x0
 86e:	b68080e7          	jalr	-1176(ra) # 3d2 <sbrk>
  if(p == (char*)-1)
 872:	fd551ae3          	bne	a0,s5,846 <malloc+0x7c>
        return 0;
 876:	4501                	li	a0,0
 878:	74a2                	ld	s1,40(sp)
 87a:	6a42                	ld	s4,16(sp)
 87c:	6aa2                	ld	s5,8(sp)
 87e:	6b02                	ld	s6,0(sp)
 880:	a03d                	j	8ae <malloc+0xe4>
 882:	74a2                	ld	s1,40(sp)
 884:	6a42                	ld	s4,16(sp)
 886:	6aa2                	ld	s5,8(sp)
 888:	6b02                	ld	s6,0(sp)
      if(p->s.size == nunits)
 88a:	fae90be3          	beq	s2,a4,840 <malloc+0x76>
        p->s.size -= nunits;
 88e:	4137073b          	subw	a4,a4,s3
 892:	c798                	sw	a4,8(a5)
        p += p->s.size;
 894:	02071693          	slli	a3,a4,0x20
 898:	01c6d713          	srli	a4,a3,0x1c
 89c:	97ba                	add	a5,a5,a4
        p->s.size = nunits;
 89e:	0137a423          	sw	s3,8(a5)
      freep = prevp;
 8a2:	00001717          	auipc	a4,0x1
 8a6:	c6a73723          	sd	a0,-914(a4) # 1510 <freep>
      return (void*)(p + 1);
 8aa:	01078513          	addi	a0,a5,16
  }
}
 8ae:	70e2                	ld	ra,56(sp)
 8b0:	7442                	ld	s0,48(sp)
 8b2:	7902                	ld	s2,32(sp)
 8b4:	69e2                	ld	s3,24(sp)
 8b6:	6121                	addi	sp,sp,64
 8b8:	8082                	ret
 8ba:	74a2                	ld	s1,40(sp)
 8bc:	6a42                	ld	s4,16(sp)
 8be:	6aa2                	ld	s5,8(sp)
 8c0:	6b02                	ld	s6,0(sp)
 8c2:	b7f5                	j	8ae <malloc+0xe4>

00000000000008c4 <ithread_exit>:
  free(stacks);
  stacks = new_stacks;
  return 0;
}

void ithread_exit(uint64 status) {
 8c4:	1141                	addi	sp,sp,-16
 8c6:	e406                	sd	ra,8(sp)
 8c8:	e022                	sd	s0,0(sp)
 8ca:	0800                	addi	s0,sp,16
  thread_exit(status);
 8cc:	2501                	sext.w	a0,a0
 8ce:	00000097          	auipc	ra,0x0
 8d2:	b34080e7          	jalr	-1228(ra) # 402 <thread_exit>
}
 8d6:	60a2                	ld	ra,8(sp)
 8d8:	6402                	ld	s0,0(sp)
 8da:	0141                	addi	sp,sp,16
 8dc:	8082                	ret

00000000000008de <free_stacks>:
int free_stacks() {
 8de:	7179                	addi	sp,sp,-48
 8e0:	f406                	sd	ra,40(sp)
 8e2:	f022                	sd	s0,32(sp)
 8e4:	ec26                	sd	s1,24(sp)
 8e6:	1800                	addi	s0,sp,48
  for (int i = 0; i < num_threads; i++) {
 8e8:	00001797          	auipc	a5,0x1
 8ec:	c387a783          	lw	a5,-968(a5) # 1520 <num_threads>
 8f0:	04f05063          	blez	a5,930 <free_stacks+0x52>
 8f4:	e84a                	sd	s2,16(sp)
 8f6:	e44e                	sd	s3,8(sp)
 8f8:	4481                	li	s1,0
    free(stacks[i]);
 8fa:	00001997          	auipc	s3,0x1
 8fe:	c1e98993          	addi	s3,s3,-994 # 1518 <stacks>
  for (int i = 0; i < num_threads; i++) {
 902:	00001917          	auipc	s2,0x1
 906:	c1e90913          	addi	s2,s2,-994 # 1520 <num_threads>
    free(stacks[i]);
 90a:	0009b783          	ld	a5,0(s3)
 90e:	00349713          	slli	a4,s1,0x3
 912:	97ba                	add	a5,a5,a4
 914:	6388                	ld	a0,0(a5)
 916:	00000097          	auipc	ra,0x0
 91a:	e2e080e7          	jalr	-466(ra) # 744 <free>
  for (int i = 0; i < num_threads; i++) {
 91e:	0485                	addi	s1,s1,1
 920:	00092703          	lw	a4,0(s2)
 924:	0004879b          	sext.w	a5,s1
 928:	fee7c1e3          	blt	a5,a4,90a <free_stacks+0x2c>
 92c:	6942                	ld	s2,16(sp)
 92e:	69a2                	ld	s3,8(sp)
  free(stacks);
 930:	00001497          	auipc	s1,0x1
 934:	be848493          	addi	s1,s1,-1048 # 1518 <stacks>
 938:	6088                	ld	a0,0(s1)
 93a:	00000097          	auipc	ra,0x0
 93e:	e0a080e7          	jalr	-502(ra) # 744 <free>
  stacks = 0;
 942:	0004b023          	sd	zero,0(s1)
  num_threads = 0;
 946:	00001797          	auipc	a5,0x1
 94a:	bc07ad23          	sw	zero,-1062(a5) # 1520 <num_threads>
  max_stacks = INIT_MAX_STACKS;
 94e:	47a1                	li	a5,8
 950:	00001717          	auipc	a4,0x1
 954:	baf72823          	sw	a5,-1104(a4) # 1500 <max_stacks>
  threads_done = 0;
 958:	00001797          	auipc	a5,0x1
 95c:	bc07a623          	sw	zero,-1076(a5) # 1524 <threads_done>
}
 960:	4501                	li	a0,0
 962:	70a2                	ld	ra,40(sp)
 964:	7402                	ld	s0,32(sp)
 966:	64e2                	ld	s1,24(sp)
 968:	6145                	addi	sp,sp,48
 96a:	8082                	ret

000000000000096c <expand_num_threads>:
int expand_num_threads() {
 96c:	1101                	addi	sp,sp,-32
 96e:	ec06                	sd	ra,24(sp)
 970:	e822                	sd	s0,16(sp)
 972:	e426                	sd	s1,8(sp)
 974:	e04a                	sd	s2,0(sp)
 976:	1000                	addi	s0,sp,32
  max_stacks *= 2;
 978:	00001797          	auipc	a5,0x1
 97c:	b8878793          	addi	a5,a5,-1144 # 1500 <max_stacks>
 980:	4388                	lw	a0,0(a5)
 982:	0015151b          	slliw	a0,a0,0x1
 986:	c388                	sw	a0,0(a5)
  void **new_stacks = malloc(max_stacks*sizeof(char*));
 988:	0035151b          	slliw	a0,a0,0x3
 98c:	00000097          	auipc	ra,0x0
 990:	e3e080e7          	jalr	-450(ra) # 7ca <malloc>
 994:	892a                	mv	s2,a0
  memmove(new_stacks, stacks, num_threads*sizeof(char*));
 996:	00001617          	auipc	a2,0x1
 99a:	b8a62603          	lw	a2,-1142(a2) # 1520 <num_threads>
 99e:	00001497          	auipc	s1,0x1
 9a2:	b7a48493          	addi	s1,s1,-1158 # 1518 <stacks>
 9a6:	0036161b          	slliw	a2,a2,0x3
 9aa:	608c                	ld	a1,0(s1)
 9ac:	00000097          	auipc	ra,0x0
 9b0:	8e4080e7          	jalr	-1820(ra) # 290 <memmove>
  free(stacks);
 9b4:	6088                	ld	a0,0(s1)
 9b6:	00000097          	auipc	ra,0x0
 9ba:	d8e080e7          	jalr	-626(ra) # 744 <free>
  stacks = new_stacks;
 9be:	0124b023          	sd	s2,0(s1)
}
 9c2:	4501                	li	a0,0
 9c4:	60e2                	ld	ra,24(sp)
 9c6:	6442                	ld	s0,16(sp)
 9c8:	64a2                	ld	s1,8(sp)
 9ca:	6902                	ld	s2,0(sp)
 9cc:	6105                	addi	sp,sp,32
 9ce:	8082                	ret

00000000000009d0 <ithread_create>:

int ithread_create(void* (*fn_ptr)(void *), void *args) {
 9d0:	7179                	addi	sp,sp,-48
 9d2:	f406                	sd	ra,40(sp)
 9d4:	f022                	sd	s0,32(sp)
 9d6:	e84a                	sd	s2,16(sp)
 9d8:	e44e                	sd	s3,8(sp)
 9da:	1800                	addi	s0,sp,48
 9dc:	892a                	mv	s2,a0
 9de:	89ae                	mv	s3,a1
  if (stacks == 0) {
 9e0:	00001797          	auipc	a5,0x1
 9e4:	b387b783          	ld	a5,-1224(a5) # 1518 <stacks>
 9e8:	c3d9                	beqz	a5,a6e <ithread_create+0x9e>
    stacks = malloc(max_stacks*sizeof(char*));
  }
  if (num_threads == max_stacks) {
 9ea:	00001797          	auipc	a5,0x1
 9ee:	b167a783          	lw	a5,-1258(a5) # 1500 <max_stacks>
 9f2:	00001717          	auipc	a4,0x1
 9f6:	b2e72703          	lw	a4,-1234(a4) # 1520 <num_threads>
 9fa:	0af71363          	bne	a4,a5,aa0 <ithread_create+0xd0>
    if (max_stacks == MAX_THREADS) {
 9fe:	04000713          	li	a4,64
 a02:	08e78563          	beq	a5,a4,a8c <ithread_create+0xbc>
 a06:	ec26                	sd	s1,24(sp)
      printf("ERROR: Thread capacity has been reached\n");
      return -1;
    }
    expand_num_threads();
 a08:	00000097          	auipc	ra,0x0
 a0c:	f64080e7          	jalr	-156(ra) # 96c <expand_num_threads>
  }

  void *stack_ptr = malloc(PGSIZE);
 a10:	6505                	lui	a0,0x1
 a12:	00000097          	auipc	ra,0x0
 a16:	db8080e7          	jalr	-584(ra) # 7ca <malloc>
 a1a:	84aa                	mv	s1,a0
  stacks[num_threads] = stack_ptr;
 a1c:	00001717          	auipc	a4,0x1
 a20:	b0472703          	lw	a4,-1276(a4) # 1520 <num_threads>
 a24:	070e                	slli	a4,a4,0x3
 a26:	00001797          	auipc	a5,0x1
 a2a:	af27b783          	ld	a5,-1294(a5) # 1518 <stacks>
 a2e:	97ba                	add	a5,a5,a4
 a30:	e388                	sd	a0,0(a5)
  int res = create_thread(fn_ptr, args, stack_ptr, &ithread_exit);
 a32:	00000697          	auipc	a3,0x0
 a36:	e9268693          	addi	a3,a3,-366 # 8c4 <ithread_exit>
 a3a:	862a                	mv	a2,a0
 a3c:	85ce                	mv	a1,s3
 a3e:	854a                	mv	a0,s2
 a40:	00000097          	auipc	ra,0x0
 a44:	9b2080e7          	jalr	-1614(ra) # 3f2 <create_thread>
 a48:	892a                	mv	s2,a0
  if (res != -1) {
 a4a:	57fd                	li	a5,-1
 a4c:	04f50c63          	beq	a0,a5,aa4 <ithread_create+0xd4>
    num_threads++;
 a50:	00001717          	auipc	a4,0x1
 a54:	ad070713          	addi	a4,a4,-1328 # 1520 <num_threads>
 a58:	431c                	lw	a5,0(a4)
 a5a:	2785                	addiw	a5,a5,1
 a5c:	c31c                	sw	a5,0(a4)
 a5e:	64e2                	ld	s1,24(sp)
  } else {
    free(stack_ptr);
    stacks[num_threads] = 0;
  }
  return res;
}
 a60:	854a                	mv	a0,s2
 a62:	70a2                	ld	ra,40(sp)
 a64:	7402                	ld	s0,32(sp)
 a66:	6942                	ld	s2,16(sp)
 a68:	69a2                	ld	s3,8(sp)
 a6a:	6145                	addi	sp,sp,48
 a6c:	8082                	ret
    stacks = malloc(max_stacks*sizeof(char*));
 a6e:	00001517          	auipc	a0,0x1
 a72:	a9252503          	lw	a0,-1390(a0) # 1500 <max_stacks>
 a76:	0035151b          	slliw	a0,a0,0x3
 a7a:	00000097          	auipc	ra,0x0
 a7e:	d50080e7          	jalr	-688(ra) # 7ca <malloc>
 a82:	00001797          	auipc	a5,0x1
 a86:	a8a7bb23          	sd	a0,-1386(a5) # 1518 <stacks>
 a8a:	b785                	j	9ea <ithread_create+0x1a>
      printf("ERROR: Thread capacity has been reached\n");
 a8c:	00000517          	auipc	a0,0x0
 a90:	0ac50513          	addi	a0,a0,172 # b38 <ithread_join+0x6e>
 a94:	00000097          	auipc	ra,0x0
 a98:	c7a080e7          	jalr	-902(ra) # 70e <printf>
      return -1;
 a9c:	597d                	li	s2,-1
 a9e:	b7c9                	j	a60 <ithread_create+0x90>
 aa0:	ec26                	sd	s1,24(sp)
 aa2:	b7bd                	j	a10 <ithread_create+0x40>
    free(stack_ptr);
 aa4:	8526                	mv	a0,s1
 aa6:	00000097          	auipc	ra,0x0
 aaa:	c9e080e7          	jalr	-866(ra) # 744 <free>
    stacks[num_threads] = 0;
 aae:	00001717          	auipc	a4,0x1
 ab2:	a7272703          	lw	a4,-1422(a4) # 1520 <num_threads>
 ab6:	070e                	slli	a4,a4,0x3
 ab8:	00001797          	auipc	a5,0x1
 abc:	a607b783          	ld	a5,-1440(a5) # 1518 <stacks>
 ac0:	97ba                	add	a5,a5,a4
 ac2:	0007b023          	sd	zero,0(a5)
 ac6:	64e2                	ld	s1,24(sp)
 ac8:	bf61                	j	a60 <ithread_create+0x90>

0000000000000aca <ithread_join>:

int ithread_join(int thread_id) {
 aca:	1101                	addi	sp,sp,-32
 acc:	ec06                	sd	ra,24(sp)
 ace:	e822                	sd	s0,16(sp)
 ad0:	1000                	addi	s0,sp,32
  int status;
  join_thread(thread_id, (uint64)&status);
 ad2:	ff040793          	addi	a5,s0,-16
 ad6:	ffc7859b          	addiw	a1,a5,-4
 ada:	00000097          	auipc	ra,0x0
 ade:	920080e7          	jalr	-1760(ra) # 3fa <join_thread>
  threads_done++;
 ae2:	00001717          	auipc	a4,0x1
 ae6:	a4270713          	addi	a4,a4,-1470 # 1524 <threads_done>
 aea:	431c                	lw	a5,0(a4)
 aec:	2785                	addiw	a5,a5,1
 aee:	c31c                	sw	a5,0(a4)
  if (threads_done == num_threads) {
 af0:	00001717          	auipc	a4,0x1
 af4:	a3072703          	lw	a4,-1488(a4) # 1520 <num_threads>
 af8:	00f70863          	beq	a4,a5,b08 <ithread_join+0x3e>
    free_stacks();
  }
  return status;
}
 afc:	fec42503          	lw	a0,-20(s0)
 b00:	60e2                	ld	ra,24(sp)
 b02:	6442                	ld	s0,16(sp)
 b04:	6105                	addi	sp,sp,32
 b06:	8082                	ret
    free_stacks();
 b08:	00000097          	auipc	ra,0x0
 b0c:	dd6080e7          	jalr	-554(ra) # 8de <free_stacks>
 b10:	b7f5                	j	afc <ithread_join+0x32>
