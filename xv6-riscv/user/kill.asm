
user/_kill:     file format elf64-littleriscv


Disassembly of section .text:

0000000000000000 <main>:
#include "kernel/stat.h"
#include "user/user.h"

int
main(int argc, char **argv)
{
   0:	1101                	addi	sp,sp,-32
   2:	ec06                	sd	ra,24(sp)
   4:	e822                	sd	s0,16(sp)
   6:	1000                	addi	s0,sp,32
  int i;

  if(argc < 2){
   8:	4785                	li	a5,1
   a:	02a7df63          	bge	a5,a0,48 <main+0x48>
   e:	e426                	sd	s1,8(sp)
  10:	e04a                	sd	s2,0(sp)
  12:	00858493          	addi	s1,a1,8
  16:	ffe5091b          	addiw	s2,a0,-2
  1a:	02091793          	slli	a5,s2,0x20
  1e:	01d7d913          	srli	s2,a5,0x1d
  22:	05c1                	addi	a1,a1,16
  24:	992e                	add	s2,s2,a1
    fprintf(2, "usage: kill pid...\n");
    exit(1);
  }
  for(i=1; i<argc; i++)
    kill(atoi(argv[i]));
  26:	6088                	ld	a0,0(s1)
  28:	00000097          	auipc	ra,0x0
  2c:	1f4080e7          	jalr	500(ra) # 21c <atoi>
  30:	00000097          	auipc	ra,0x0
  34:	322080e7          	jalr	802(ra) # 352 <kill>
  for(i=1; i<argc; i++)
  38:	04a1                	addi	s1,s1,8
  3a:	ff2496e3          	bne	s1,s2,26 <main+0x26>
  exit(0);
  3e:	4501                	li	a0,0
  40:	00000097          	auipc	ra,0x0
  44:	2e2080e7          	jalr	738(ra) # 322 <exit>
  48:	e426                	sd	s1,8(sp)
  4a:	e04a                	sd	s2,0(sp)
    fprintf(2, "usage: kill pid...\n");
  4c:	00001597          	auipc	a1,0x1
  50:	aa458593          	addi	a1,a1,-1372 # af0 <ithread_join+0x4e>
  54:	4509                	li	a0,2
  56:	00000097          	auipc	ra,0x0
  5a:	662080e7          	jalr	1634(ra) # 6b8 <fprintf>
    exit(1);
  5e:	4505                	li	a0,1
  60:	00000097          	auipc	ra,0x0
  64:	2c2080e7          	jalr	706(ra) # 322 <exit>

0000000000000068 <_main>:
//
// wrapper so that it's OK if main() does not call exit().
//
void
_main()
{
  68:	1141                	addi	sp,sp,-16
  6a:	e406                	sd	ra,8(sp)
  6c:	e022                	sd	s0,0(sp)
  6e:	0800                	addi	s0,sp,16
  extern int main();
  main();
  70:	00000097          	auipc	ra,0x0
  74:	f90080e7          	jalr	-112(ra) # 0 <main>
  exit(0);
  78:	4501                	li	a0,0
  7a:	00000097          	auipc	ra,0x0
  7e:	2a8080e7          	jalr	680(ra) # 322 <exit>

0000000000000082 <strcpy>:
}

char*
strcpy(char *s, const char *t)
{
  82:	1141                	addi	sp,sp,-16
  84:	e406                	sd	ra,8(sp)
  86:	e022                	sd	s0,0(sp)
  88:	0800                	addi	s0,sp,16
  char *os;

  os = s;
  while((*s++ = *t++) != 0)
  8a:	87aa                	mv	a5,a0
  8c:	0585                	addi	a1,a1,1
  8e:	0785                	addi	a5,a5,1
  90:	fff5c703          	lbu	a4,-1(a1)
  94:	fee78fa3          	sb	a4,-1(a5)
  98:	fb75                	bnez	a4,8c <strcpy+0xa>
    ;
  return os;
}
  9a:	60a2                	ld	ra,8(sp)
  9c:	6402                	ld	s0,0(sp)
  9e:	0141                	addi	sp,sp,16
  a0:	8082                	ret

00000000000000a2 <strcmp>:

int
strcmp(const char *p, const char *q)
{
  a2:	1141                	addi	sp,sp,-16
  a4:	e406                	sd	ra,8(sp)
  a6:	e022                	sd	s0,0(sp)
  a8:	0800                	addi	s0,sp,16
  while(*p && *p == *q)
  aa:	00054783          	lbu	a5,0(a0)
  ae:	cb91                	beqz	a5,c2 <strcmp+0x20>
  b0:	0005c703          	lbu	a4,0(a1)
  b4:	00f71763          	bne	a4,a5,c2 <strcmp+0x20>
    p++, q++;
  b8:	0505                	addi	a0,a0,1
  ba:	0585                	addi	a1,a1,1
  while(*p && *p == *q)
  bc:	00054783          	lbu	a5,0(a0)
  c0:	fbe5                	bnez	a5,b0 <strcmp+0xe>
  return (uchar)*p - (uchar)*q;
  c2:	0005c503          	lbu	a0,0(a1)
}
  c6:	40a7853b          	subw	a0,a5,a0
  ca:	60a2                	ld	ra,8(sp)
  cc:	6402                	ld	s0,0(sp)
  ce:	0141                	addi	sp,sp,16
  d0:	8082                	ret

00000000000000d2 <strlen>:

uint
strlen(const char *s)
{
  d2:	1141                	addi	sp,sp,-16
  d4:	e406                	sd	ra,8(sp)
  d6:	e022                	sd	s0,0(sp)
  d8:	0800                	addi	s0,sp,16
  int n;

  for(n = 0; s[n]; n++)
  da:	00054783          	lbu	a5,0(a0)
  de:	cf99                	beqz	a5,fc <strlen+0x2a>
  e0:	0505                	addi	a0,a0,1
  e2:	87aa                	mv	a5,a0
  e4:	86be                	mv	a3,a5
  e6:	0785                	addi	a5,a5,1
  e8:	fff7c703          	lbu	a4,-1(a5)
  ec:	ff65                	bnez	a4,e4 <strlen+0x12>
  ee:	40a6853b          	subw	a0,a3,a0
  f2:	2505                	addiw	a0,a0,1
    ;
  return n;
}
  f4:	60a2                	ld	ra,8(sp)
  f6:	6402                	ld	s0,0(sp)
  f8:	0141                	addi	sp,sp,16
  fa:	8082                	ret
  for(n = 0; s[n]; n++)
  fc:	4501                	li	a0,0
  fe:	bfdd                	j	f4 <strlen+0x22>

0000000000000100 <memset>:

void*
memset(void *dst, int c, uint n)
{
 100:	1141                	addi	sp,sp,-16
 102:	e406                	sd	ra,8(sp)
 104:	e022                	sd	s0,0(sp)
 106:	0800                	addi	s0,sp,16
  char *cdst = (char *) dst;
  int i;
  for(i = 0; i < n; i++){
 108:	ca19                	beqz	a2,11e <memset+0x1e>
 10a:	87aa                	mv	a5,a0
 10c:	1602                	slli	a2,a2,0x20
 10e:	9201                	srli	a2,a2,0x20
 110:	00a60733          	add	a4,a2,a0
    cdst[i] = c;
 114:	00b78023          	sb	a1,0(a5)
  for(i = 0; i < n; i++){
 118:	0785                	addi	a5,a5,1
 11a:	fee79de3          	bne	a5,a4,114 <memset+0x14>
  }
  return dst;
}
 11e:	60a2                	ld	ra,8(sp)
 120:	6402                	ld	s0,0(sp)
 122:	0141                	addi	sp,sp,16
 124:	8082                	ret

0000000000000126 <strchr>:

char*
strchr(const char *s, char c)
{
 126:	1141                	addi	sp,sp,-16
 128:	e406                	sd	ra,8(sp)
 12a:	e022                	sd	s0,0(sp)
 12c:	0800                	addi	s0,sp,16
  for(; *s; s++)
 12e:	00054783          	lbu	a5,0(a0)
 132:	cf81                	beqz	a5,14a <strchr+0x24>
    if(*s == c)
 134:	00f58763          	beq	a1,a5,142 <strchr+0x1c>
  for(; *s; s++)
 138:	0505                	addi	a0,a0,1
 13a:	00054783          	lbu	a5,0(a0)
 13e:	fbfd                	bnez	a5,134 <strchr+0xe>
      return (char*)s;
  return 0;
 140:	4501                	li	a0,0
}
 142:	60a2                	ld	ra,8(sp)
 144:	6402                	ld	s0,0(sp)
 146:	0141                	addi	sp,sp,16
 148:	8082                	ret
  return 0;
 14a:	4501                	li	a0,0
 14c:	bfdd                	j	142 <strchr+0x1c>

000000000000014e <gets>:

char*
gets(char *buf, int max)
{
 14e:	7159                	addi	sp,sp,-112
 150:	f486                	sd	ra,104(sp)
 152:	f0a2                	sd	s0,96(sp)
 154:	eca6                	sd	s1,88(sp)
 156:	e8ca                	sd	s2,80(sp)
 158:	e4ce                	sd	s3,72(sp)
 15a:	e0d2                	sd	s4,64(sp)
 15c:	fc56                	sd	s5,56(sp)
 15e:	f85a                	sd	s6,48(sp)
 160:	f45e                	sd	s7,40(sp)
 162:	f062                	sd	s8,32(sp)
 164:	ec66                	sd	s9,24(sp)
 166:	e86a                	sd	s10,16(sp)
 168:	1880                	addi	s0,sp,112
 16a:	8caa                	mv	s9,a0
 16c:	8a2e                	mv	s4,a1
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 16e:	892a                	mv	s2,a0
 170:	4481                	li	s1,0
    cc = read(0, &c, 1);
 172:	f9f40b13          	addi	s6,s0,-97
 176:	4a85                	li	s5,1
    if(cc < 1)
      break;
    buf[i++] = c;
    if(c == '\n' || c == '\r')
 178:	4ba9                	li	s7,10
 17a:	4c35                	li	s8,13
  for(i=0; i+1 < max; ){
 17c:	8d26                	mv	s10,s1
 17e:	0014899b          	addiw	s3,s1,1
 182:	84ce                	mv	s1,s3
 184:	0349d763          	bge	s3,s4,1b2 <gets+0x64>
    cc = read(0, &c, 1);
 188:	8656                	mv	a2,s5
 18a:	85da                	mv	a1,s6
 18c:	4501                	li	a0,0
 18e:	00000097          	auipc	ra,0x0
 192:	1ac080e7          	jalr	428(ra) # 33a <read>
    if(cc < 1)
 196:	00a05e63          	blez	a0,1b2 <gets+0x64>
    buf[i++] = c;
 19a:	f9f44783          	lbu	a5,-97(s0)
 19e:	00f90023          	sb	a5,0(s2)
    if(c == '\n' || c == '\r')
 1a2:	01778763          	beq	a5,s7,1b0 <gets+0x62>
 1a6:	0905                	addi	s2,s2,1
 1a8:	fd879ae3          	bne	a5,s8,17c <gets+0x2e>
    buf[i++] = c;
 1ac:	8d4e                	mv	s10,s3
 1ae:	a011                	j	1b2 <gets+0x64>
 1b0:	8d4e                	mv	s10,s3
      break;
  }
  buf[i] = '\0';
 1b2:	9d66                	add	s10,s10,s9
 1b4:	000d0023          	sb	zero,0(s10)
  return buf;
}
 1b8:	8566                	mv	a0,s9
 1ba:	70a6                	ld	ra,104(sp)
 1bc:	7406                	ld	s0,96(sp)
 1be:	64e6                	ld	s1,88(sp)
 1c0:	6946                	ld	s2,80(sp)
 1c2:	69a6                	ld	s3,72(sp)
 1c4:	6a06                	ld	s4,64(sp)
 1c6:	7ae2                	ld	s5,56(sp)
 1c8:	7b42                	ld	s6,48(sp)
 1ca:	7ba2                	ld	s7,40(sp)
 1cc:	7c02                	ld	s8,32(sp)
 1ce:	6ce2                	ld	s9,24(sp)
 1d0:	6d42                	ld	s10,16(sp)
 1d2:	6165                	addi	sp,sp,112
 1d4:	8082                	ret

00000000000001d6 <stat>:

int
stat(const char *n, struct stat *st)
{
 1d6:	1101                	addi	sp,sp,-32
 1d8:	ec06                	sd	ra,24(sp)
 1da:	e822                	sd	s0,16(sp)
 1dc:	e04a                	sd	s2,0(sp)
 1de:	1000                	addi	s0,sp,32
 1e0:	892e                	mv	s2,a1
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 1e2:	4581                	li	a1,0
 1e4:	00000097          	auipc	ra,0x0
 1e8:	17e080e7          	jalr	382(ra) # 362 <open>
  if(fd < 0)
 1ec:	02054663          	bltz	a0,218 <stat+0x42>
 1f0:	e426                	sd	s1,8(sp)
 1f2:	84aa                	mv	s1,a0
    return -1;
  r = fstat(fd, st);
 1f4:	85ca                	mv	a1,s2
 1f6:	00000097          	auipc	ra,0x0
 1fa:	184080e7          	jalr	388(ra) # 37a <fstat>
 1fe:	892a                	mv	s2,a0
  close(fd);
 200:	8526                	mv	a0,s1
 202:	00000097          	auipc	ra,0x0
 206:	148080e7          	jalr	328(ra) # 34a <close>
  return r;
 20a:	64a2                	ld	s1,8(sp)
}
 20c:	854a                	mv	a0,s2
 20e:	60e2                	ld	ra,24(sp)
 210:	6442                	ld	s0,16(sp)
 212:	6902                	ld	s2,0(sp)
 214:	6105                	addi	sp,sp,32
 216:	8082                	ret
    return -1;
 218:	597d                	li	s2,-1
 21a:	bfcd                	j	20c <stat+0x36>

000000000000021c <atoi>:

int
atoi(const char *s)
{
 21c:	1141                	addi	sp,sp,-16
 21e:	e406                	sd	ra,8(sp)
 220:	e022                	sd	s0,0(sp)
 222:	0800                	addi	s0,sp,16
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
 224:	00054683          	lbu	a3,0(a0)
 228:	fd06879b          	addiw	a5,a3,-48
 22c:	0ff7f793          	zext.b	a5,a5
 230:	4625                	li	a2,9
 232:	02f66963          	bltu	a2,a5,264 <atoi+0x48>
 236:	872a                	mv	a4,a0
  n = 0;
 238:	4501                	li	a0,0
    n = n*10 + *s++ - '0';
 23a:	0705                	addi	a4,a4,1
 23c:	0025179b          	slliw	a5,a0,0x2
 240:	9fa9                	addw	a5,a5,a0
 242:	0017979b          	slliw	a5,a5,0x1
 246:	9fb5                	addw	a5,a5,a3
 248:	fd07851b          	addiw	a0,a5,-48
  while('0' <= *s && *s <= '9')
 24c:	00074683          	lbu	a3,0(a4)
 250:	fd06879b          	addiw	a5,a3,-48
 254:	0ff7f793          	zext.b	a5,a5
 258:	fef671e3          	bgeu	a2,a5,23a <atoi+0x1e>
  return n;
}
 25c:	60a2                	ld	ra,8(sp)
 25e:	6402                	ld	s0,0(sp)
 260:	0141                	addi	sp,sp,16
 262:	8082                	ret
  n = 0;
 264:	4501                	li	a0,0
 266:	bfdd                	j	25c <atoi+0x40>

0000000000000268 <memmove>:

void*
memmove(void *vdst, const void *vsrc, int n)
{
 268:	1141                	addi	sp,sp,-16
 26a:	e406                	sd	ra,8(sp)
 26c:	e022                	sd	s0,0(sp)
 26e:	0800                	addi	s0,sp,16
  char *dst;
  const char *src;

  dst = vdst;
  src = vsrc;
  if (src > dst) {
 270:	02b57563          	bgeu	a0,a1,29a <memmove+0x32>
    while(n-- > 0)
 274:	00c05f63          	blez	a2,292 <memmove+0x2a>
 278:	1602                	slli	a2,a2,0x20
 27a:	9201                	srli	a2,a2,0x20
 27c:	00c507b3          	add	a5,a0,a2
  dst = vdst;
 280:	872a                	mv	a4,a0
      *dst++ = *src++;
 282:	0585                	addi	a1,a1,1
 284:	0705                	addi	a4,a4,1
 286:	fff5c683          	lbu	a3,-1(a1)
 28a:	fed70fa3          	sb	a3,-1(a4)
    while(n-- > 0)
 28e:	fee79ae3          	bne	a5,a4,282 <memmove+0x1a>
    src += n;
    while(n-- > 0)
      *--dst = *--src;
  }
  return vdst;
}
 292:	60a2                	ld	ra,8(sp)
 294:	6402                	ld	s0,0(sp)
 296:	0141                	addi	sp,sp,16
 298:	8082                	ret
    dst += n;
 29a:	00c50733          	add	a4,a0,a2
    src += n;
 29e:	95b2                	add	a1,a1,a2
    while(n-- > 0)
 2a0:	fec059e3          	blez	a2,292 <memmove+0x2a>
 2a4:	fff6079b          	addiw	a5,a2,-1
 2a8:	1782                	slli	a5,a5,0x20
 2aa:	9381                	srli	a5,a5,0x20
 2ac:	fff7c793          	not	a5,a5
 2b0:	97ba                	add	a5,a5,a4
      *--dst = *--src;
 2b2:	15fd                	addi	a1,a1,-1
 2b4:	177d                	addi	a4,a4,-1
 2b6:	0005c683          	lbu	a3,0(a1)
 2ba:	00d70023          	sb	a3,0(a4)
    while(n-- > 0)
 2be:	fef71ae3          	bne	a4,a5,2b2 <memmove+0x4a>
 2c2:	bfc1                	j	292 <memmove+0x2a>

00000000000002c4 <memcmp>:

int
memcmp(const void *s1, const void *s2, uint n)
{
 2c4:	1141                	addi	sp,sp,-16
 2c6:	e406                	sd	ra,8(sp)
 2c8:	e022                	sd	s0,0(sp)
 2ca:	0800                	addi	s0,sp,16
  const char *p1 = s1, *p2 = s2;
  while (n-- > 0) {
 2cc:	ca0d                	beqz	a2,2fe <memcmp+0x3a>
 2ce:	fff6069b          	addiw	a3,a2,-1
 2d2:	1682                	slli	a3,a3,0x20
 2d4:	9281                	srli	a3,a3,0x20
 2d6:	0685                	addi	a3,a3,1
 2d8:	96aa                	add	a3,a3,a0
    if (*p1 != *p2) {
 2da:	00054783          	lbu	a5,0(a0)
 2de:	0005c703          	lbu	a4,0(a1)
 2e2:	00e79863          	bne	a5,a4,2f2 <memcmp+0x2e>
      return *p1 - *p2;
    }
    p1++;
 2e6:	0505                	addi	a0,a0,1
    p2++;
 2e8:	0585                	addi	a1,a1,1
  while (n-- > 0) {
 2ea:	fed518e3          	bne	a0,a3,2da <memcmp+0x16>
  }
  return 0;
 2ee:	4501                	li	a0,0
 2f0:	a019                	j	2f6 <memcmp+0x32>
      return *p1 - *p2;
 2f2:	40e7853b          	subw	a0,a5,a4
}
 2f6:	60a2                	ld	ra,8(sp)
 2f8:	6402                	ld	s0,0(sp)
 2fa:	0141                	addi	sp,sp,16
 2fc:	8082                	ret
  return 0;
 2fe:	4501                	li	a0,0
 300:	bfdd                	j	2f6 <memcmp+0x32>

0000000000000302 <memcpy>:

void *
memcpy(void *dst, const void *src, uint n)
{
 302:	1141                	addi	sp,sp,-16
 304:	e406                	sd	ra,8(sp)
 306:	e022                	sd	s0,0(sp)
 308:	0800                	addi	s0,sp,16
  return memmove(dst, src, n);
 30a:	00000097          	auipc	ra,0x0
 30e:	f5e080e7          	jalr	-162(ra) # 268 <memmove>
}
 312:	60a2                	ld	ra,8(sp)
 314:	6402                	ld	s0,0(sp)
 316:	0141                	addi	sp,sp,16
 318:	8082                	ret

000000000000031a <fork>:
# generated by usys.pl - do not edit
#include "kernel/syscall.h"
.global fork
fork:
 li a7, SYS_fork
 31a:	4885                	li	a7,1
 ecall
 31c:	00000073          	ecall
 ret
 320:	8082                	ret

0000000000000322 <exit>:
.global exit
exit:
 li a7, SYS_exit
 322:	4889                	li	a7,2
 ecall
 324:	00000073          	ecall
 ret
 328:	8082                	ret

000000000000032a <wait>:
.global wait
wait:
 li a7, SYS_wait
 32a:	488d                	li	a7,3
 ecall
 32c:	00000073          	ecall
 ret
 330:	8082                	ret

0000000000000332 <pipe>:
.global pipe
pipe:
 li a7, SYS_pipe
 332:	4891                	li	a7,4
 ecall
 334:	00000073          	ecall
 ret
 338:	8082                	ret

000000000000033a <read>:
.global read
read:
 li a7, SYS_read
 33a:	4895                	li	a7,5
 ecall
 33c:	00000073          	ecall
 ret
 340:	8082                	ret

0000000000000342 <write>:
.global write
write:
 li a7, SYS_write
 342:	48c1                	li	a7,16
 ecall
 344:	00000073          	ecall
 ret
 348:	8082                	ret

000000000000034a <close>:
.global close
close:
 li a7, SYS_close
 34a:	48d5                	li	a7,21
 ecall
 34c:	00000073          	ecall
 ret
 350:	8082                	ret

0000000000000352 <kill>:
.global kill
kill:
 li a7, SYS_kill
 352:	4899                	li	a7,6
 ecall
 354:	00000073          	ecall
 ret
 358:	8082                	ret

000000000000035a <exec>:
.global exec
exec:
 li a7, SYS_exec
 35a:	489d                	li	a7,7
 ecall
 35c:	00000073          	ecall
 ret
 360:	8082                	ret

0000000000000362 <open>:
.global open
open:
 li a7, SYS_open
 362:	48bd                	li	a7,15
 ecall
 364:	00000073          	ecall
 ret
 368:	8082                	ret

000000000000036a <mknod>:
.global mknod
mknod:
 li a7, SYS_mknod
 36a:	48c5                	li	a7,17
 ecall
 36c:	00000073          	ecall
 ret
 370:	8082                	ret

0000000000000372 <unlink>:
.global unlink
unlink:
 li a7, SYS_unlink
 372:	48c9                	li	a7,18
 ecall
 374:	00000073          	ecall
 ret
 378:	8082                	ret

000000000000037a <fstat>:
.global fstat
fstat:
 li a7, SYS_fstat
 37a:	48a1                	li	a7,8
 ecall
 37c:	00000073          	ecall
 ret
 380:	8082                	ret

0000000000000382 <link>:
.global link
link:
 li a7, SYS_link
 382:	48cd                	li	a7,19
 ecall
 384:	00000073          	ecall
 ret
 388:	8082                	ret

000000000000038a <mkdir>:
.global mkdir
mkdir:
 li a7, SYS_mkdir
 38a:	48d1                	li	a7,20
 ecall
 38c:	00000073          	ecall
 ret
 390:	8082                	ret

0000000000000392 <chdir>:
.global chdir
chdir:
 li a7, SYS_chdir
 392:	48a5                	li	a7,9
 ecall
 394:	00000073          	ecall
 ret
 398:	8082                	ret

000000000000039a <dup>:
.global dup
dup:
 li a7, SYS_dup
 39a:	48a9                	li	a7,10
 ecall
 39c:	00000073          	ecall
 ret
 3a0:	8082                	ret

00000000000003a2 <getpid>:
.global getpid
getpid:
 li a7, SYS_getpid
 3a2:	48ad                	li	a7,11
 ecall
 3a4:	00000073          	ecall
 ret
 3a8:	8082                	ret

00000000000003aa <sbrk>:
.global sbrk
sbrk:
 li a7, SYS_sbrk
 3aa:	48b1                	li	a7,12
 ecall
 3ac:	00000073          	ecall
 ret
 3b0:	8082                	ret

00000000000003b2 <sleep>:
.global sleep
sleep:
 li a7, SYS_sleep
 3b2:	48b5                	li	a7,13
 ecall
 3b4:	00000073          	ecall
 ret
 3b8:	8082                	ret

00000000000003ba <uptime>:
.global uptime
uptime:
 li a7, SYS_uptime
 3ba:	48b9                	li	a7,14
 ecall
 3bc:	00000073          	ecall
 ret
 3c0:	8082                	ret

00000000000003c2 <spoon>:
.global spoon
spoon:
 li a7, SYS_spoon
 3c2:	48d9                	li	a7,22
 ecall
 3c4:	00000073          	ecall
 ret
 3c8:	8082                	ret

00000000000003ca <create_thread>:
.global create_thread
create_thread:
 li a7, SYS_create_thread
 3ca:	48dd                	li	a7,23
 ecall
 3cc:	00000073          	ecall
 ret
 3d0:	8082                	ret

00000000000003d2 <join_thread>:
.global join_thread
join_thread:
 li a7, SYS_join_thread
 3d2:	48e1                	li	a7,24
 ecall
 3d4:	00000073          	ecall
 ret
 3d8:	8082                	ret

00000000000003da <thread_exit>:
.global thread_exit
thread_exit:
 li a7, SYS_thread_exit
 3da:	48e5                	li	a7,25
 ecall
 3dc:	00000073          	ecall
 ret
 3e0:	8082                	ret

00000000000003e2 <socket>:
.global socket
socket:
 li a7, SYS_socket
 3e2:	48e9                	li	a7,26
 ecall
 3e4:	00000073          	ecall
 ret
 3e8:	8082                	ret

00000000000003ea <bind>:
.global bind
bind:
 li a7, SYS_bind
 3ea:	48ed                	li	a7,27
 ecall
 3ec:	00000073          	ecall
 ret
 3f0:	8082                	ret

00000000000003f2 <accept>:
.global accept
accept:
 li a7, SYS_accept
 3f2:	48f5                	li	a7,29
 ecall
 3f4:	00000073          	ecall
 ret
 3f8:	8082                	ret

00000000000003fa <listen>:
.global listen
listen:
 li a7, SYS_listen
 3fa:	48f1                	li	a7,28
 ecall
 3fc:	00000073          	ecall
 ret
 400:	8082                	ret

0000000000000402 <connect>:
.global connect
connect:
 li a7, SYS_connect
 402:	48f9                	li	a7,30
 ecall
 404:	00000073          	ecall
 ret
 408:	8082                	ret

000000000000040a <send>:
.global send
send:
 li a7, SYS_send
 40a:	48fd                	li	a7,31
 ecall
 40c:	00000073          	ecall
 ret
 410:	8082                	ret

0000000000000412 <recv>:
.global recv
recv:
 li a7, SYS_recv
 412:	02000893          	li	a7,32
 ecall
 416:	00000073          	ecall
 ret
 41a:	8082                	ret

000000000000041c <sendto>:
.global sendto
sendto:
 li a7, SYS_sendto
 41c:	02100893          	li	a7,33
 ecall
 420:	00000073          	ecall
 ret
 424:	8082                	ret

0000000000000426 <recvfrom>:
.global recvfrom
recvfrom:
 li a7, SYS_recvfrom
 426:	02200893          	li	a7,34
 ecall
 42a:	00000073          	ecall
 ret
 42e:	8082                	ret

0000000000000430 <putc>:

static char digits[] = "0123456789ABCDEF";

static void
putc(int fd, char c)
{
 430:	1101                	addi	sp,sp,-32
 432:	ec06                	sd	ra,24(sp)
 434:	e822                	sd	s0,16(sp)
 436:	1000                	addi	s0,sp,32
 438:	feb407a3          	sb	a1,-17(s0)
  write(fd, &c, 1);
 43c:	4605                	li	a2,1
 43e:	fef40593          	addi	a1,s0,-17
 442:	00000097          	auipc	ra,0x0
 446:	f00080e7          	jalr	-256(ra) # 342 <write>
}
 44a:	60e2                	ld	ra,24(sp)
 44c:	6442                	ld	s0,16(sp)
 44e:	6105                	addi	sp,sp,32
 450:	8082                	ret

0000000000000452 <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
 452:	7139                	addi	sp,sp,-64
 454:	fc06                	sd	ra,56(sp)
 456:	f822                	sd	s0,48(sp)
 458:	f426                	sd	s1,40(sp)
 45a:	f04a                	sd	s2,32(sp)
 45c:	ec4e                	sd	s3,24(sp)
 45e:	0080                	addi	s0,sp,64
 460:	892a                	mv	s2,a0
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
  if(sgn && xx < 0){
 462:	c299                	beqz	a3,468 <printint+0x16>
 464:	0805c063          	bltz	a1,4e4 <printint+0x92>
  neg = 0;
 468:	4e01                	li	t3,0
    x = -xx;
  } else {
    x = xx;
  }

  i = 0;
 46a:	fc040313          	addi	t1,s0,-64
  neg = 0;
 46e:	869a                	mv	a3,t1
  i = 0;
 470:	4781                	li	a5,0
  do{
    buf[i++] = digits[x % base];
 472:	00000817          	auipc	a6,0x0
 476:	72680813          	addi	a6,a6,1830 # b98 <digits>
 47a:	88be                	mv	a7,a5
 47c:	0017851b          	addiw	a0,a5,1
 480:	87aa                	mv	a5,a0
 482:	02c5f73b          	remuw	a4,a1,a2
 486:	1702                	slli	a4,a4,0x20
 488:	9301                	srli	a4,a4,0x20
 48a:	9742                	add	a4,a4,a6
 48c:	00074703          	lbu	a4,0(a4)
 490:	00e68023          	sb	a4,0(a3)
  }while((x /= base) != 0);
 494:	872e                	mv	a4,a1
 496:	02c5d5bb          	divuw	a1,a1,a2
 49a:	0685                	addi	a3,a3,1
 49c:	fcc77fe3          	bgeu	a4,a2,47a <printint+0x28>
  if(neg)
 4a0:	000e0c63          	beqz	t3,4b8 <printint+0x66>
    buf[i++] = '-';
 4a4:	fd050793          	addi	a5,a0,-48
 4a8:	00878533          	add	a0,a5,s0
 4ac:	02d00793          	li	a5,45
 4b0:	fef50823          	sb	a5,-16(a0)
 4b4:	0028879b          	addiw	a5,a7,2

  while(--i >= 0)
 4b8:	fff7899b          	addiw	s3,a5,-1
 4bc:	006784b3          	add	s1,a5,t1
    putc(fd, buf[i]);
 4c0:	fff4c583          	lbu	a1,-1(s1)
 4c4:	854a                	mv	a0,s2
 4c6:	00000097          	auipc	ra,0x0
 4ca:	f6a080e7          	jalr	-150(ra) # 430 <putc>
  while(--i >= 0)
 4ce:	39fd                	addiw	s3,s3,-1
 4d0:	14fd                	addi	s1,s1,-1
 4d2:	fe09d7e3          	bgez	s3,4c0 <printint+0x6e>
}
 4d6:	70e2                	ld	ra,56(sp)
 4d8:	7442                	ld	s0,48(sp)
 4da:	74a2                	ld	s1,40(sp)
 4dc:	7902                	ld	s2,32(sp)
 4de:	69e2                	ld	s3,24(sp)
 4e0:	6121                	addi	sp,sp,64
 4e2:	8082                	ret
    x = -xx;
 4e4:	40b005bb          	negw	a1,a1
    neg = 1;
 4e8:	4e05                	li	t3,1
    x = -xx;
 4ea:	b741                	j	46a <printint+0x18>

00000000000004ec <vprintf>:
}

// Print to the given fd. Only understands %d, %x, %p, %s.
void
vprintf(int fd, const char *fmt, va_list ap)
{
 4ec:	715d                	addi	sp,sp,-80
 4ee:	e486                	sd	ra,72(sp)
 4f0:	e0a2                	sd	s0,64(sp)
 4f2:	f84a                	sd	s2,48(sp)
 4f4:	0880                	addi	s0,sp,80
  char *s;
  int c, i, state;

  state = 0;
  for(i = 0; fmt[i]; i++){
 4f6:	0005c903          	lbu	s2,0(a1)
 4fa:	1a090a63          	beqz	s2,6ae <vprintf+0x1c2>
 4fe:	fc26                	sd	s1,56(sp)
 500:	f44e                	sd	s3,40(sp)
 502:	f052                	sd	s4,32(sp)
 504:	ec56                	sd	s5,24(sp)
 506:	e85a                	sd	s6,16(sp)
 508:	e45e                	sd	s7,8(sp)
 50a:	8aaa                	mv	s5,a0
 50c:	8bb2                	mv	s7,a2
 50e:	00158493          	addi	s1,a1,1
  state = 0;
 512:	4981                	li	s3,0
      if(c == '%'){
        state = '%';
      } else {
        putc(fd, c);
      }
    } else if(state == '%'){
 514:	02500a13          	li	s4,37
 518:	4b55                	li	s6,21
 51a:	a839                	j	538 <vprintf+0x4c>
        putc(fd, c);
 51c:	85ca                	mv	a1,s2
 51e:	8556                	mv	a0,s5
 520:	00000097          	auipc	ra,0x0
 524:	f10080e7          	jalr	-240(ra) # 430 <putc>
 528:	a019                	j	52e <vprintf+0x42>
    } else if(state == '%'){
 52a:	01498d63          	beq	s3,s4,544 <vprintf+0x58>
  for(i = 0; fmt[i]; i++){
 52e:	0485                	addi	s1,s1,1
 530:	fff4c903          	lbu	s2,-1(s1)
 534:	16090763          	beqz	s2,6a2 <vprintf+0x1b6>
    if(state == 0){
 538:	fe0999e3          	bnez	s3,52a <vprintf+0x3e>
      if(c == '%'){
 53c:	ff4910e3          	bne	s2,s4,51c <vprintf+0x30>
        state = '%';
 540:	89d2                	mv	s3,s4
 542:	b7f5                	j	52e <vprintf+0x42>
      if(c == 'd'){
 544:	13490463          	beq	s2,s4,66c <vprintf+0x180>
 548:	f9d9079b          	addiw	a5,s2,-99
 54c:	0ff7f793          	zext.b	a5,a5
 550:	12fb6763          	bltu	s6,a5,67e <vprintf+0x192>
 554:	f9d9079b          	addiw	a5,s2,-99
 558:	0ff7f713          	zext.b	a4,a5
 55c:	12eb6163          	bltu	s6,a4,67e <vprintf+0x192>
 560:	00271793          	slli	a5,a4,0x2
 564:	00000717          	auipc	a4,0x0
 568:	5dc70713          	addi	a4,a4,1500 # b40 <ithread_join+0x9e>
 56c:	97ba                	add	a5,a5,a4
 56e:	439c                	lw	a5,0(a5)
 570:	97ba                	add	a5,a5,a4
 572:	8782                	jr	a5
        printint(fd, va_arg(ap, int), 10, 1);
 574:	008b8913          	addi	s2,s7,8
 578:	4685                	li	a3,1
 57a:	4629                	li	a2,10
 57c:	000ba583          	lw	a1,0(s7)
 580:	8556                	mv	a0,s5
 582:	00000097          	auipc	ra,0x0
 586:	ed0080e7          	jalr	-304(ra) # 452 <printint>
 58a:	8bca                	mv	s7,s2
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
        putc(fd, c);
      }
      state = 0;
 58c:	4981                	li	s3,0
 58e:	b745                	j	52e <vprintf+0x42>
        printint(fd, va_arg(ap, uint64), 10, 0);
 590:	008b8913          	addi	s2,s7,8
 594:	4681                	li	a3,0
 596:	4629                	li	a2,10
 598:	000ba583          	lw	a1,0(s7)
 59c:	8556                	mv	a0,s5
 59e:	00000097          	auipc	ra,0x0
 5a2:	eb4080e7          	jalr	-332(ra) # 452 <printint>
 5a6:	8bca                	mv	s7,s2
      state = 0;
 5a8:	4981                	li	s3,0
 5aa:	b751                	j	52e <vprintf+0x42>
        printint(fd, va_arg(ap, int), 16, 0);
 5ac:	008b8913          	addi	s2,s7,8
 5b0:	4681                	li	a3,0
 5b2:	4641                	li	a2,16
 5b4:	000ba583          	lw	a1,0(s7)
 5b8:	8556                	mv	a0,s5
 5ba:	00000097          	auipc	ra,0x0
 5be:	e98080e7          	jalr	-360(ra) # 452 <printint>
 5c2:	8bca                	mv	s7,s2
      state = 0;
 5c4:	4981                	li	s3,0
 5c6:	b7a5                	j	52e <vprintf+0x42>
 5c8:	e062                	sd	s8,0(sp)
        printptr(fd, va_arg(ap, uint64));
 5ca:	008b8c13          	addi	s8,s7,8
 5ce:	000bb983          	ld	s3,0(s7)
  putc(fd, '0');
 5d2:	03000593          	li	a1,48
 5d6:	8556                	mv	a0,s5
 5d8:	00000097          	auipc	ra,0x0
 5dc:	e58080e7          	jalr	-424(ra) # 430 <putc>
  putc(fd, 'x');
 5e0:	07800593          	li	a1,120
 5e4:	8556                	mv	a0,s5
 5e6:	00000097          	auipc	ra,0x0
 5ea:	e4a080e7          	jalr	-438(ra) # 430 <putc>
 5ee:	4941                	li	s2,16
    putc(fd, digits[x >> (sizeof(uint64) * 8 - 4)]);
 5f0:	00000b97          	auipc	s7,0x0
 5f4:	5a8b8b93          	addi	s7,s7,1448 # b98 <digits>
 5f8:	03c9d793          	srli	a5,s3,0x3c
 5fc:	97de                	add	a5,a5,s7
 5fe:	0007c583          	lbu	a1,0(a5)
 602:	8556                	mv	a0,s5
 604:	00000097          	auipc	ra,0x0
 608:	e2c080e7          	jalr	-468(ra) # 430 <putc>
  for (i = 0; i < (sizeof(uint64) * 2); i++, x <<= 4)
 60c:	0992                	slli	s3,s3,0x4
 60e:	397d                	addiw	s2,s2,-1
 610:	fe0914e3          	bnez	s2,5f8 <vprintf+0x10c>
        printptr(fd, va_arg(ap, uint64));
 614:	8be2                	mv	s7,s8
      state = 0;
 616:	4981                	li	s3,0
 618:	6c02                	ld	s8,0(sp)
 61a:	bf11                	j	52e <vprintf+0x42>
        s = va_arg(ap, char*);
 61c:	008b8993          	addi	s3,s7,8
 620:	000bb903          	ld	s2,0(s7)
        if(s == 0)
 624:	02090163          	beqz	s2,646 <vprintf+0x15a>
        while(*s != 0){
 628:	00094583          	lbu	a1,0(s2)
 62c:	c9a5                	beqz	a1,69c <vprintf+0x1b0>
          putc(fd, *s);
 62e:	8556                	mv	a0,s5
 630:	00000097          	auipc	ra,0x0
 634:	e00080e7          	jalr	-512(ra) # 430 <putc>
          s++;
 638:	0905                	addi	s2,s2,1
        while(*s != 0){
 63a:	00094583          	lbu	a1,0(s2)
 63e:	f9e5                	bnez	a1,62e <vprintf+0x142>
        s = va_arg(ap, char*);
 640:	8bce                	mv	s7,s3
      state = 0;
 642:	4981                	li	s3,0
 644:	b5ed                	j	52e <vprintf+0x42>
          s = "(null)";
 646:	00000917          	auipc	s2,0x0
 64a:	4c290913          	addi	s2,s2,1218 # b08 <ithread_join+0x66>
        while(*s != 0){
 64e:	02800593          	li	a1,40
 652:	bff1                	j	62e <vprintf+0x142>
        putc(fd, va_arg(ap, uint));
 654:	008b8913          	addi	s2,s7,8
 658:	000bc583          	lbu	a1,0(s7)
 65c:	8556                	mv	a0,s5
 65e:	00000097          	auipc	ra,0x0
 662:	dd2080e7          	jalr	-558(ra) # 430 <putc>
 666:	8bca                	mv	s7,s2
      state = 0;
 668:	4981                	li	s3,0
 66a:	b5d1                	j	52e <vprintf+0x42>
        putc(fd, c);
 66c:	02500593          	li	a1,37
 670:	8556                	mv	a0,s5
 672:	00000097          	auipc	ra,0x0
 676:	dbe080e7          	jalr	-578(ra) # 430 <putc>
      state = 0;
 67a:	4981                	li	s3,0
 67c:	bd4d                	j	52e <vprintf+0x42>
        putc(fd, '%');
 67e:	02500593          	li	a1,37
 682:	8556                	mv	a0,s5
 684:	00000097          	auipc	ra,0x0
 688:	dac080e7          	jalr	-596(ra) # 430 <putc>
        putc(fd, c);
 68c:	85ca                	mv	a1,s2
 68e:	8556                	mv	a0,s5
 690:	00000097          	auipc	ra,0x0
 694:	da0080e7          	jalr	-608(ra) # 430 <putc>
      state = 0;
 698:	4981                	li	s3,0
 69a:	bd51                	j	52e <vprintf+0x42>
        s = va_arg(ap, char*);
 69c:	8bce                	mv	s7,s3
      state = 0;
 69e:	4981                	li	s3,0
 6a0:	b579                	j	52e <vprintf+0x42>
 6a2:	74e2                	ld	s1,56(sp)
 6a4:	79a2                	ld	s3,40(sp)
 6a6:	7a02                	ld	s4,32(sp)
 6a8:	6ae2                	ld	s5,24(sp)
 6aa:	6b42                	ld	s6,16(sp)
 6ac:	6ba2                	ld	s7,8(sp)
    }
  }
}
 6ae:	60a6                	ld	ra,72(sp)
 6b0:	6406                	ld	s0,64(sp)
 6b2:	7942                	ld	s2,48(sp)
 6b4:	6161                	addi	sp,sp,80
 6b6:	8082                	ret

00000000000006b8 <fprintf>:

void
fprintf(int fd, const char *fmt, ...)
{
 6b8:	715d                	addi	sp,sp,-80
 6ba:	ec06                	sd	ra,24(sp)
 6bc:	e822                	sd	s0,16(sp)
 6be:	1000                	addi	s0,sp,32
 6c0:	e010                	sd	a2,0(s0)
 6c2:	e414                	sd	a3,8(s0)
 6c4:	e818                	sd	a4,16(s0)
 6c6:	ec1c                	sd	a5,24(s0)
 6c8:	03043023          	sd	a6,32(s0)
 6cc:	03143423          	sd	a7,40(s0)
  va_list ap;

  va_start(ap, fmt);
 6d0:	8622                	mv	a2,s0
 6d2:	fe843423          	sd	s0,-24(s0)
  vprintf(fd, fmt, ap);
 6d6:	00000097          	auipc	ra,0x0
 6da:	e16080e7          	jalr	-490(ra) # 4ec <vprintf>
}
 6de:	60e2                	ld	ra,24(sp)
 6e0:	6442                	ld	s0,16(sp)
 6e2:	6161                	addi	sp,sp,80
 6e4:	8082                	ret

00000000000006e6 <printf>:

void
printf(const char *fmt, ...)
{
 6e6:	711d                	addi	sp,sp,-96
 6e8:	ec06                	sd	ra,24(sp)
 6ea:	e822                	sd	s0,16(sp)
 6ec:	1000                	addi	s0,sp,32
 6ee:	e40c                	sd	a1,8(s0)
 6f0:	e810                	sd	a2,16(s0)
 6f2:	ec14                	sd	a3,24(s0)
 6f4:	f018                	sd	a4,32(s0)
 6f6:	f41c                	sd	a5,40(s0)
 6f8:	03043823          	sd	a6,48(s0)
 6fc:	03143c23          	sd	a7,56(s0)
  va_list ap;

  va_start(ap, fmt);
 700:	00840613          	addi	a2,s0,8
 704:	fec43423          	sd	a2,-24(s0)
  vprintf(1, fmt, ap);
 708:	85aa                	mv	a1,a0
 70a:	4505                	li	a0,1
 70c:	00000097          	auipc	ra,0x0
 710:	de0080e7          	jalr	-544(ra) # 4ec <vprintf>
}
 714:	60e2                	ld	ra,24(sp)
 716:	6442                	ld	s0,16(sp)
 718:	6125                	addi	sp,sp,96
 71a:	8082                	ret

000000000000071c <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 71c:	1141                	addi	sp,sp,-16
 71e:	e406                	sd	ra,8(sp)
 720:	e022                	sd	s0,0(sp)
 722:	0800                	addi	s0,sp,16
  Header *bp, *p;

  bp = (Header*)ap - 1;
 724:	ff050693          	addi	a3,a0,-16
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 728:	00001797          	auipc	a5,0x1
 72c:	de87b783          	ld	a5,-536(a5) # 1510 <freep>
 730:	a02d                	j	75a <free+0x3e>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
      break;
  if(bp + bp->s.size == p->s.ptr){
    bp->s.size += p->s.ptr->s.size;
 732:	4618                	lw	a4,8(a2)
 734:	9f2d                	addw	a4,a4,a1
 736:	fee52c23          	sw	a4,-8(a0)
    bp->s.ptr = p->s.ptr->s.ptr;
 73a:	6398                	ld	a4,0(a5)
 73c:	6310                	ld	a2,0(a4)
 73e:	a83d                	j	77c <free+0x60>
  } else
    bp->s.ptr = p->s.ptr;
  if(p + p->s.size == bp){
    p->s.size += bp->s.size;
 740:	ff852703          	lw	a4,-8(a0)
 744:	9f31                	addw	a4,a4,a2
 746:	c798                	sw	a4,8(a5)
    p->s.ptr = bp->s.ptr;
 748:	ff053683          	ld	a3,-16(a0)
 74c:	a091                	j	790 <free+0x74>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 74e:	6398                	ld	a4,0(a5)
 750:	00e7e463          	bltu	a5,a4,758 <free+0x3c>
 754:	00e6ea63          	bltu	a3,a4,768 <free+0x4c>
{
 758:	87ba                	mv	a5,a4
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 75a:	fed7fae3          	bgeu	a5,a3,74e <free+0x32>
 75e:	6398                	ld	a4,0(a5)
 760:	00e6e463          	bltu	a3,a4,768 <free+0x4c>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 764:	fee7eae3          	bltu	a5,a4,758 <free+0x3c>
  if(bp + bp->s.size == p->s.ptr){
 768:	ff852583          	lw	a1,-8(a0)
 76c:	6390                	ld	a2,0(a5)
 76e:	02059813          	slli	a6,a1,0x20
 772:	01c85713          	srli	a4,a6,0x1c
 776:	9736                	add	a4,a4,a3
 778:	fae60de3          	beq	a2,a4,732 <free+0x16>
    bp->s.ptr = p->s.ptr->s.ptr;
 77c:	fec53823          	sd	a2,-16(a0)
  if(p + p->s.size == bp){
 780:	4790                	lw	a2,8(a5)
 782:	02061593          	slli	a1,a2,0x20
 786:	01c5d713          	srli	a4,a1,0x1c
 78a:	973e                	add	a4,a4,a5
 78c:	fae68ae3          	beq	a3,a4,740 <free+0x24>
    p->s.ptr = bp->s.ptr;
 790:	e394                	sd	a3,0(a5)
  } else
    p->s.ptr = bp;
  freep = p;
 792:	00001717          	auipc	a4,0x1
 796:	d6f73f23          	sd	a5,-642(a4) # 1510 <freep>
}
 79a:	60a2                	ld	ra,8(sp)
 79c:	6402                	ld	s0,0(sp)
 79e:	0141                	addi	sp,sp,16
 7a0:	8082                	ret

00000000000007a2 <malloc>:
  return freep;
}

void*
malloc(uint nbytes)
{
 7a2:	7139                	addi	sp,sp,-64
 7a4:	fc06                	sd	ra,56(sp)
 7a6:	f822                	sd	s0,48(sp)
 7a8:	f04a                	sd	s2,32(sp)
 7aa:	ec4e                	sd	s3,24(sp)
 7ac:	0080                	addi	s0,sp,64
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 7ae:	02051993          	slli	s3,a0,0x20
 7b2:	0209d993          	srli	s3,s3,0x20
 7b6:	09bd                	addi	s3,s3,15
 7b8:	0049d993          	srli	s3,s3,0x4
 7bc:	2985                	addiw	s3,s3,1
 7be:	894e                	mv	s2,s3
  if((prevp = freep) == 0){
 7c0:	00001517          	auipc	a0,0x1
 7c4:	d5053503          	ld	a0,-688(a0) # 1510 <freep>
 7c8:	c905                	beqz	a0,7f8 <malloc+0x56>
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 7ca:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
 7cc:	4798                	lw	a4,8(a5)
 7ce:	09377a63          	bgeu	a4,s3,862 <malloc+0xc0>
 7d2:	f426                	sd	s1,40(sp)
 7d4:	e852                	sd	s4,16(sp)
 7d6:	e456                	sd	s5,8(sp)
 7d8:	e05a                	sd	s6,0(sp)
  if(nu < 4096)
 7da:	8a4e                	mv	s4,s3
 7dc:	6705                	lui	a4,0x1
 7de:	00e9f363          	bgeu	s3,a4,7e4 <malloc+0x42>
 7e2:	6a05                	lui	s4,0x1
 7e4:	000a0b1b          	sext.w	s6,s4
  p = sbrk(nu * sizeof(Header));
 7e8:	004a1a1b          	slliw	s4,s4,0x4
        p->s.size = nunits;
      }
      freep = prevp;
      return (void*)(p + 1);
    }
    if(p == freep)
 7ec:	00001497          	auipc	s1,0x1
 7f0:	d2448493          	addi	s1,s1,-732 # 1510 <freep>
  if(p == (char*)-1)
 7f4:	5afd                	li	s5,-1
 7f6:	a089                	j	838 <malloc+0x96>
 7f8:	f426                	sd	s1,40(sp)
 7fa:	e852                	sd	s4,16(sp)
 7fc:	e456                	sd	s5,8(sp)
 7fe:	e05a                	sd	s6,0(sp)
    base.s.ptr = freep = prevp = &base;
 800:	00001797          	auipc	a5,0x1
 804:	d3078793          	addi	a5,a5,-720 # 1530 <base>
 808:	00001717          	auipc	a4,0x1
 80c:	d0f73423          	sd	a5,-760(a4) # 1510 <freep>
 810:	e39c                	sd	a5,0(a5)
    base.s.size = 0;
 812:	0007a423          	sw	zero,8(a5)
    if(p->s.size >= nunits){
 816:	b7d1                	j	7da <malloc+0x38>
        prevp->s.ptr = p->s.ptr;
 818:	6398                	ld	a4,0(a5)
 81a:	e118                	sd	a4,0(a0)
 81c:	a8b9                	j	87a <malloc+0xd8>
  hp->s.size = nu;
 81e:	01652423          	sw	s6,8(a0)
  free((void*)(hp + 1));
 822:	0541                	addi	a0,a0,16
 824:	00000097          	auipc	ra,0x0
 828:	ef8080e7          	jalr	-264(ra) # 71c <free>
  return freep;
 82c:	6088                	ld	a0,0(s1)
      if((p = morecore(nunits)) == 0)
 82e:	c135                	beqz	a0,892 <malloc+0xf0>
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 830:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
 832:	4798                	lw	a4,8(a5)
 834:	03277363          	bgeu	a4,s2,85a <malloc+0xb8>
    if(p == freep)
 838:	6098                	ld	a4,0(s1)
 83a:	853e                	mv	a0,a5
 83c:	fef71ae3          	bne	a4,a5,830 <malloc+0x8e>
  p = sbrk(nu * sizeof(Header));
 840:	8552                	mv	a0,s4
 842:	00000097          	auipc	ra,0x0
 846:	b68080e7          	jalr	-1176(ra) # 3aa <sbrk>
  if(p == (char*)-1)
 84a:	fd551ae3          	bne	a0,s5,81e <malloc+0x7c>
        return 0;
 84e:	4501                	li	a0,0
 850:	74a2                	ld	s1,40(sp)
 852:	6a42                	ld	s4,16(sp)
 854:	6aa2                	ld	s5,8(sp)
 856:	6b02                	ld	s6,0(sp)
 858:	a03d                	j	886 <malloc+0xe4>
 85a:	74a2                	ld	s1,40(sp)
 85c:	6a42                	ld	s4,16(sp)
 85e:	6aa2                	ld	s5,8(sp)
 860:	6b02                	ld	s6,0(sp)
      if(p->s.size == nunits)
 862:	fae90be3          	beq	s2,a4,818 <malloc+0x76>
        p->s.size -= nunits;
 866:	4137073b          	subw	a4,a4,s3
 86a:	c798                	sw	a4,8(a5)
        p += p->s.size;
 86c:	02071693          	slli	a3,a4,0x20
 870:	01c6d713          	srli	a4,a3,0x1c
 874:	97ba                	add	a5,a5,a4
        p->s.size = nunits;
 876:	0137a423          	sw	s3,8(a5)
      freep = prevp;
 87a:	00001717          	auipc	a4,0x1
 87e:	c8a73b23          	sd	a0,-874(a4) # 1510 <freep>
      return (void*)(p + 1);
 882:	01078513          	addi	a0,a5,16
  }
}
 886:	70e2                	ld	ra,56(sp)
 888:	7442                	ld	s0,48(sp)
 88a:	7902                	ld	s2,32(sp)
 88c:	69e2                	ld	s3,24(sp)
 88e:	6121                	addi	sp,sp,64
 890:	8082                	ret
 892:	74a2                	ld	s1,40(sp)
 894:	6a42                	ld	s4,16(sp)
 896:	6aa2                	ld	s5,8(sp)
 898:	6b02                	ld	s6,0(sp)
 89a:	b7f5                	j	886 <malloc+0xe4>

000000000000089c <ithread_exit>:
  free(stacks);
  stacks = new_stacks;
  return 0;
}

void ithread_exit(uint64 status) {
 89c:	1141                	addi	sp,sp,-16
 89e:	e406                	sd	ra,8(sp)
 8a0:	e022                	sd	s0,0(sp)
 8a2:	0800                	addi	s0,sp,16
  thread_exit(status);
 8a4:	2501                	sext.w	a0,a0
 8a6:	00000097          	auipc	ra,0x0
 8aa:	b34080e7          	jalr	-1228(ra) # 3da <thread_exit>
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
 8be:	1800                	addi	s0,sp,48
  for (int i = 0; i < num_threads; i++) {
 8c0:	00001797          	auipc	a5,0x1
 8c4:	c607a783          	lw	a5,-928(a5) # 1520 <num_threads>
 8c8:	04f05063          	blez	a5,908 <free_stacks+0x52>
 8cc:	e84a                	sd	s2,16(sp)
 8ce:	e44e                	sd	s3,8(sp)
 8d0:	4481                	li	s1,0
    free(stacks[i]);
 8d2:	00001997          	auipc	s3,0x1
 8d6:	c4698993          	addi	s3,s3,-954 # 1518 <stacks>
  for (int i = 0; i < num_threads; i++) {
 8da:	00001917          	auipc	s2,0x1
 8de:	c4690913          	addi	s2,s2,-954 # 1520 <num_threads>
    free(stacks[i]);
 8e2:	0009b783          	ld	a5,0(s3)
 8e6:	00349713          	slli	a4,s1,0x3
 8ea:	97ba                	add	a5,a5,a4
 8ec:	6388                	ld	a0,0(a5)
 8ee:	00000097          	auipc	ra,0x0
 8f2:	e2e080e7          	jalr	-466(ra) # 71c <free>
  for (int i = 0; i < num_threads; i++) {
 8f6:	0485                	addi	s1,s1,1
 8f8:	00092703          	lw	a4,0(s2)
 8fc:	0004879b          	sext.w	a5,s1
 900:	fee7c1e3          	blt	a5,a4,8e2 <free_stacks+0x2c>
 904:	6942                	ld	s2,16(sp)
 906:	69a2                	ld	s3,8(sp)
  free(stacks);
 908:	00001497          	auipc	s1,0x1
 90c:	c1048493          	addi	s1,s1,-1008 # 1518 <stacks>
 910:	6088                	ld	a0,0(s1)
 912:	00000097          	auipc	ra,0x0
 916:	e0a080e7          	jalr	-502(ra) # 71c <free>
  stacks = 0;
 91a:	0004b023          	sd	zero,0(s1)
  num_threads = 0;
 91e:	00001797          	auipc	a5,0x1
 922:	c007a123          	sw	zero,-1022(a5) # 1520 <num_threads>
  max_stacks = INIT_MAX_STACKS;
 926:	47a1                	li	a5,8
 928:	00001717          	auipc	a4,0x1
 92c:	bcf72c23          	sw	a5,-1064(a4) # 1500 <max_stacks>
  threads_done = 0;
 930:	00001797          	auipc	a5,0x1
 934:	be07aa23          	sw	zero,-1036(a5) # 1524 <threads_done>
}
 938:	4501                	li	a0,0
 93a:	70a2                	ld	ra,40(sp)
 93c:	7402                	ld	s0,32(sp)
 93e:	64e2                	ld	s1,24(sp)
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
 950:	00001797          	auipc	a5,0x1
 954:	bb078793          	addi	a5,a5,-1104 # 1500 <max_stacks>
 958:	4388                	lw	a0,0(a5)
 95a:	0015151b          	slliw	a0,a0,0x1
 95e:	c388                	sw	a0,0(a5)
  void **new_stacks = malloc(max_stacks*sizeof(char*));
 960:	0035151b          	slliw	a0,a0,0x3
 964:	00000097          	auipc	ra,0x0
 968:	e3e080e7          	jalr	-450(ra) # 7a2 <malloc>
 96c:	892a                	mv	s2,a0
  memmove(new_stacks, stacks, num_threads*sizeof(char*));
 96e:	00001617          	auipc	a2,0x1
 972:	bb262603          	lw	a2,-1102(a2) # 1520 <num_threads>
 976:	00001497          	auipc	s1,0x1
 97a:	ba248493          	addi	s1,s1,-1118 # 1518 <stacks>
 97e:	0036161b          	slliw	a2,a2,0x3
 982:	608c                	ld	a1,0(s1)
 984:	00000097          	auipc	ra,0x0
 988:	8e4080e7          	jalr	-1820(ra) # 268 <memmove>
  free(stacks);
 98c:	6088                	ld	a0,0(s1)
 98e:	00000097          	auipc	ra,0x0
 992:	d8e080e7          	jalr	-626(ra) # 71c <free>
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
 9ae:	e84a                	sd	s2,16(sp)
 9b0:	e44e                	sd	s3,8(sp)
 9b2:	1800                	addi	s0,sp,48
 9b4:	892a                	mv	s2,a0
 9b6:	89ae                	mv	s3,a1
  if (stacks == 0) {
 9b8:	00001797          	auipc	a5,0x1
 9bc:	b607b783          	ld	a5,-1184(a5) # 1518 <stacks>
 9c0:	c3d9                	beqz	a5,a46 <ithread_create+0x9e>
    stacks = malloc(max_stacks*sizeof(char*));
  }
  if (num_threads == max_stacks) {
 9c2:	00001797          	auipc	a5,0x1
 9c6:	b3e7a783          	lw	a5,-1218(a5) # 1500 <max_stacks>
 9ca:	00001717          	auipc	a4,0x1
 9ce:	b5672703          	lw	a4,-1194(a4) # 1520 <num_threads>
 9d2:	0af71363          	bne	a4,a5,a78 <ithread_create+0xd0>
    if (max_stacks == MAX_THREADS) {
 9d6:	04000713          	li	a4,64
 9da:	08e78563          	beq	a5,a4,a64 <ithread_create+0xbc>
 9de:	ec26                	sd	s1,24(sp)
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
 9ee:	db8080e7          	jalr	-584(ra) # 7a2 <malloc>
 9f2:	84aa                	mv	s1,a0
  stacks[num_threads] = stack_ptr;
 9f4:	00001717          	auipc	a4,0x1
 9f8:	b2c72703          	lw	a4,-1236(a4) # 1520 <num_threads>
 9fc:	070e                	slli	a4,a4,0x3
 9fe:	00001797          	auipc	a5,0x1
 a02:	b1a7b783          	ld	a5,-1254(a5) # 1518 <stacks>
 a06:	97ba                	add	a5,a5,a4
 a08:	e388                	sd	a0,0(a5)
  int res = create_thread(fn_ptr, args, stack_ptr, &ithread_exit);
 a0a:	00000697          	auipc	a3,0x0
 a0e:	e9268693          	addi	a3,a3,-366 # 89c <ithread_exit>
 a12:	862a                	mv	a2,a0
 a14:	85ce                	mv	a1,s3
 a16:	854a                	mv	a0,s2
 a18:	00000097          	auipc	ra,0x0
 a1c:	9b2080e7          	jalr	-1614(ra) # 3ca <create_thread>
 a20:	892a                	mv	s2,a0
  if (res != -1) {
 a22:	57fd                	li	a5,-1
 a24:	04f50c63          	beq	a0,a5,a7c <ithread_create+0xd4>
    num_threads++;
 a28:	00001717          	auipc	a4,0x1
 a2c:	af870713          	addi	a4,a4,-1288 # 1520 <num_threads>
 a30:	431c                	lw	a5,0(a4)
 a32:	2785                	addiw	a5,a5,1
 a34:	c31c                	sw	a5,0(a4)
 a36:	64e2                	ld	s1,24(sp)
  } else {
    free(stack_ptr);
    stacks[num_threads] = 0;
  }
  return res;
}
 a38:	854a                	mv	a0,s2
 a3a:	70a2                	ld	ra,40(sp)
 a3c:	7402                	ld	s0,32(sp)
 a3e:	6942                	ld	s2,16(sp)
 a40:	69a2                	ld	s3,8(sp)
 a42:	6145                	addi	sp,sp,48
 a44:	8082                	ret
    stacks = malloc(max_stacks*sizeof(char*));
 a46:	00001517          	auipc	a0,0x1
 a4a:	aba52503          	lw	a0,-1350(a0) # 1500 <max_stacks>
 a4e:	0035151b          	slliw	a0,a0,0x3
 a52:	00000097          	auipc	ra,0x0
 a56:	d50080e7          	jalr	-688(ra) # 7a2 <malloc>
 a5a:	00001797          	auipc	a5,0x1
 a5e:	aaa7bf23          	sd	a0,-1346(a5) # 1518 <stacks>
 a62:	b785                	j	9c2 <ithread_create+0x1a>
      printf("ERROR: Thread capacity has been reached\n");
 a64:	00000517          	auipc	a0,0x0
 a68:	0ac50513          	addi	a0,a0,172 # b10 <ithread_join+0x6e>
 a6c:	00000097          	auipc	ra,0x0
 a70:	c7a080e7          	jalr	-902(ra) # 6e6 <printf>
      return -1;
 a74:	597d                	li	s2,-1
 a76:	b7c9                	j	a38 <ithread_create+0x90>
 a78:	ec26                	sd	s1,24(sp)
 a7a:	b7bd                	j	9e8 <ithread_create+0x40>
    free(stack_ptr);
 a7c:	8526                	mv	a0,s1
 a7e:	00000097          	auipc	ra,0x0
 a82:	c9e080e7          	jalr	-866(ra) # 71c <free>
    stacks[num_threads] = 0;
 a86:	00001717          	auipc	a4,0x1
 a8a:	a9a72703          	lw	a4,-1382(a4) # 1520 <num_threads>
 a8e:	070e                	slli	a4,a4,0x3
 a90:	00001797          	auipc	a5,0x1
 a94:	a887b783          	ld	a5,-1400(a5) # 1518 <stacks>
 a98:	97ba                	add	a5,a5,a4
 a9a:	0007b023          	sd	zero,0(a5)
 a9e:	64e2                	ld	s1,24(sp)
 aa0:	bf61                	j	a38 <ithread_create+0x90>

0000000000000aa2 <ithread_join>:

int ithread_join(int thread_id) {
 aa2:	1101                	addi	sp,sp,-32
 aa4:	ec06                	sd	ra,24(sp)
 aa6:	e822                	sd	s0,16(sp)
 aa8:	1000                	addi	s0,sp,32
  int status;
  join_thread(thread_id, (uint64)&status);
 aaa:	ff040793          	addi	a5,s0,-16
 aae:	ffc7859b          	addiw	a1,a5,-4
 ab2:	00000097          	auipc	ra,0x0
 ab6:	920080e7          	jalr	-1760(ra) # 3d2 <join_thread>
  threads_done++;
 aba:	00001717          	auipc	a4,0x1
 abe:	a6a70713          	addi	a4,a4,-1430 # 1524 <threads_done>
 ac2:	431c                	lw	a5,0(a4)
 ac4:	2785                	addiw	a5,a5,1
 ac6:	c31c                	sw	a5,0(a4)
  if (threads_done == num_threads) {
 ac8:	00001717          	auipc	a4,0x1
 acc:	a5872703          	lw	a4,-1448(a4) # 1520 <num_threads>
 ad0:	00f70863          	beq	a4,a5,ae0 <ithread_join+0x3e>
    free_stacks();
  }
  return status;
}
 ad4:	fec42503          	lw	a0,-20(s0)
 ad8:	60e2                	ld	ra,24(sp)
 ada:	6442                	ld	s0,16(sp)
 adc:	6105                	addi	sp,sp,32
 ade:	8082                	ret
    free_stacks();
 ae0:	00000097          	auipc	ra,0x0
 ae4:	dd6080e7          	jalr	-554(ra) # 8b6 <free_stacks>
 ae8:	b7f5                	j	ad4 <ithread_join+0x32>
