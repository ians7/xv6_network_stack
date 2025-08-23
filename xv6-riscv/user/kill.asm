
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
  50:	a8458593          	addi	a1,a1,-1404 # ad0 <ithread_join+0x54>
  54:	4509                	li	a0,2
  56:	00000097          	auipc	ra,0x0
  5a:	63c080e7          	jalr	1596(ra) # 692 <fprintf>
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

000000000000040a <putc>:

static char digits[] = "0123456789ABCDEF";

static void
putc(int fd, char c)
{
 40a:	1101                	addi	sp,sp,-32
 40c:	ec06                	sd	ra,24(sp)
 40e:	e822                	sd	s0,16(sp)
 410:	1000                	addi	s0,sp,32
 412:	feb407a3          	sb	a1,-17(s0)
  write(fd, &c, 1);
 416:	4605                	li	a2,1
 418:	fef40593          	addi	a1,s0,-17
 41c:	00000097          	auipc	ra,0x0
 420:	f26080e7          	jalr	-218(ra) # 342 <write>
}
 424:	60e2                	ld	ra,24(sp)
 426:	6442                	ld	s0,16(sp)
 428:	6105                	addi	sp,sp,32
 42a:	8082                	ret

000000000000042c <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
 42c:	7139                	addi	sp,sp,-64
 42e:	fc06                	sd	ra,56(sp)
 430:	f822                	sd	s0,48(sp)
 432:	f426                	sd	s1,40(sp)
 434:	f04a                	sd	s2,32(sp)
 436:	ec4e                	sd	s3,24(sp)
 438:	0080                	addi	s0,sp,64
 43a:	892a                	mv	s2,a0
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
  if(sgn && xx < 0){
 43c:	c299                	beqz	a3,442 <printint+0x16>
 43e:	0805c063          	bltz	a1,4be <printint+0x92>
  neg = 0;
 442:	4e01                	li	t3,0
    x = -xx;
  } else {
    x = xx;
  }

  i = 0;
 444:	fc040313          	addi	t1,s0,-64
  neg = 0;
 448:	869a                	mv	a3,t1
  i = 0;
 44a:	4781                	li	a5,0
  do{
    buf[i++] = digits[x % base];
 44c:	00000817          	auipc	a6,0x0
 450:	72c80813          	addi	a6,a6,1836 # b78 <digits>
 454:	88be                	mv	a7,a5
 456:	0017851b          	addiw	a0,a5,1
 45a:	87aa                	mv	a5,a0
 45c:	02c5f73b          	remuw	a4,a1,a2
 460:	1702                	slli	a4,a4,0x20
 462:	9301                	srli	a4,a4,0x20
 464:	9742                	add	a4,a4,a6
 466:	00074703          	lbu	a4,0(a4)
 46a:	00e68023          	sb	a4,0(a3)
  }while((x /= base) != 0);
 46e:	872e                	mv	a4,a1
 470:	02c5d5bb          	divuw	a1,a1,a2
 474:	0685                	addi	a3,a3,1
 476:	fcc77fe3          	bgeu	a4,a2,454 <printint+0x28>
  if(neg)
 47a:	000e0c63          	beqz	t3,492 <printint+0x66>
    buf[i++] = '-';
 47e:	fd050793          	addi	a5,a0,-48
 482:	00878533          	add	a0,a5,s0
 486:	02d00793          	li	a5,45
 48a:	fef50823          	sb	a5,-16(a0)
 48e:	0028879b          	addiw	a5,a7,2

  while(--i >= 0)
 492:	fff7899b          	addiw	s3,a5,-1
 496:	006784b3          	add	s1,a5,t1
    putc(fd, buf[i]);
 49a:	fff4c583          	lbu	a1,-1(s1)
 49e:	854a                	mv	a0,s2
 4a0:	00000097          	auipc	ra,0x0
 4a4:	f6a080e7          	jalr	-150(ra) # 40a <putc>
  while(--i >= 0)
 4a8:	39fd                	addiw	s3,s3,-1
 4aa:	14fd                	addi	s1,s1,-1
 4ac:	fe09d7e3          	bgez	s3,49a <printint+0x6e>
}
 4b0:	70e2                	ld	ra,56(sp)
 4b2:	7442                	ld	s0,48(sp)
 4b4:	74a2                	ld	s1,40(sp)
 4b6:	7902                	ld	s2,32(sp)
 4b8:	69e2                	ld	s3,24(sp)
 4ba:	6121                	addi	sp,sp,64
 4bc:	8082                	ret
    x = -xx;
 4be:	40b005bb          	negw	a1,a1
    neg = 1;
 4c2:	4e05                	li	t3,1
    x = -xx;
 4c4:	b741                	j	444 <printint+0x18>

00000000000004c6 <vprintf>:
}

// Print to the given fd. Only understands %d, %x, %p, %s.
void
vprintf(int fd, const char *fmt, va_list ap)
{
 4c6:	715d                	addi	sp,sp,-80
 4c8:	e486                	sd	ra,72(sp)
 4ca:	e0a2                	sd	s0,64(sp)
 4cc:	f84a                	sd	s2,48(sp)
 4ce:	0880                	addi	s0,sp,80
  char *s;
  int c, i, state;

  state = 0;
  for(i = 0; fmt[i]; i++){
 4d0:	0005c903          	lbu	s2,0(a1)
 4d4:	1a090a63          	beqz	s2,688 <vprintf+0x1c2>
 4d8:	fc26                	sd	s1,56(sp)
 4da:	f44e                	sd	s3,40(sp)
 4dc:	f052                	sd	s4,32(sp)
 4de:	ec56                	sd	s5,24(sp)
 4e0:	e85a                	sd	s6,16(sp)
 4e2:	e45e                	sd	s7,8(sp)
 4e4:	8aaa                	mv	s5,a0
 4e6:	8bb2                	mv	s7,a2
 4e8:	00158493          	addi	s1,a1,1
  state = 0;
 4ec:	4981                	li	s3,0
      if(c == '%'){
        state = '%';
      } else {
        putc(fd, c);
      }
    } else if(state == '%'){
 4ee:	02500a13          	li	s4,37
 4f2:	4b55                	li	s6,21
 4f4:	a839                	j	512 <vprintf+0x4c>
        putc(fd, c);
 4f6:	85ca                	mv	a1,s2
 4f8:	8556                	mv	a0,s5
 4fa:	00000097          	auipc	ra,0x0
 4fe:	f10080e7          	jalr	-240(ra) # 40a <putc>
 502:	a019                	j	508 <vprintf+0x42>
    } else if(state == '%'){
 504:	01498d63          	beq	s3,s4,51e <vprintf+0x58>
  for(i = 0; fmt[i]; i++){
 508:	0485                	addi	s1,s1,1
 50a:	fff4c903          	lbu	s2,-1(s1)
 50e:	16090763          	beqz	s2,67c <vprintf+0x1b6>
    if(state == 0){
 512:	fe0999e3          	bnez	s3,504 <vprintf+0x3e>
      if(c == '%'){
 516:	ff4910e3          	bne	s2,s4,4f6 <vprintf+0x30>
        state = '%';
 51a:	89d2                	mv	s3,s4
 51c:	b7f5                	j	508 <vprintf+0x42>
      if(c == 'd'){
 51e:	13490463          	beq	s2,s4,646 <vprintf+0x180>
 522:	f9d9079b          	addiw	a5,s2,-99
 526:	0ff7f793          	zext.b	a5,a5
 52a:	12fb6763          	bltu	s6,a5,658 <vprintf+0x192>
 52e:	f9d9079b          	addiw	a5,s2,-99
 532:	0ff7f713          	zext.b	a4,a5
 536:	12eb6163          	bltu	s6,a4,658 <vprintf+0x192>
 53a:	00271793          	slli	a5,a4,0x2
 53e:	00000717          	auipc	a4,0x0
 542:	5e270713          	addi	a4,a4,1506 # b20 <ithread_join+0xa4>
 546:	97ba                	add	a5,a5,a4
 548:	439c                	lw	a5,0(a5)
 54a:	97ba                	add	a5,a5,a4
 54c:	8782                	jr	a5
        printint(fd, va_arg(ap, int), 10, 1);
 54e:	008b8913          	addi	s2,s7,8
 552:	4685                	li	a3,1
 554:	4629                	li	a2,10
 556:	000ba583          	lw	a1,0(s7)
 55a:	8556                	mv	a0,s5
 55c:	00000097          	auipc	ra,0x0
 560:	ed0080e7          	jalr	-304(ra) # 42c <printint>
 564:	8bca                	mv	s7,s2
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
        putc(fd, c);
      }
      state = 0;
 566:	4981                	li	s3,0
 568:	b745                	j	508 <vprintf+0x42>
        printint(fd, va_arg(ap, uint64), 10, 0);
 56a:	008b8913          	addi	s2,s7,8
 56e:	4681                	li	a3,0
 570:	4629                	li	a2,10
 572:	000ba583          	lw	a1,0(s7)
 576:	8556                	mv	a0,s5
 578:	00000097          	auipc	ra,0x0
 57c:	eb4080e7          	jalr	-332(ra) # 42c <printint>
 580:	8bca                	mv	s7,s2
      state = 0;
 582:	4981                	li	s3,0
 584:	b751                	j	508 <vprintf+0x42>
        printint(fd, va_arg(ap, int), 16, 0);
 586:	008b8913          	addi	s2,s7,8
 58a:	4681                	li	a3,0
 58c:	4641                	li	a2,16
 58e:	000ba583          	lw	a1,0(s7)
 592:	8556                	mv	a0,s5
 594:	00000097          	auipc	ra,0x0
 598:	e98080e7          	jalr	-360(ra) # 42c <printint>
 59c:	8bca                	mv	s7,s2
      state = 0;
 59e:	4981                	li	s3,0
 5a0:	b7a5                	j	508 <vprintf+0x42>
 5a2:	e062                	sd	s8,0(sp)
        printptr(fd, va_arg(ap, uint64));
 5a4:	008b8c13          	addi	s8,s7,8
 5a8:	000bb983          	ld	s3,0(s7)
  putc(fd, '0');
 5ac:	03000593          	li	a1,48
 5b0:	8556                	mv	a0,s5
 5b2:	00000097          	auipc	ra,0x0
 5b6:	e58080e7          	jalr	-424(ra) # 40a <putc>
  putc(fd, 'x');
 5ba:	07800593          	li	a1,120
 5be:	8556                	mv	a0,s5
 5c0:	00000097          	auipc	ra,0x0
 5c4:	e4a080e7          	jalr	-438(ra) # 40a <putc>
 5c8:	4941                	li	s2,16
    putc(fd, digits[x >> (sizeof(uint64) * 8 - 4)]);
 5ca:	00000b97          	auipc	s7,0x0
 5ce:	5aeb8b93          	addi	s7,s7,1454 # b78 <digits>
 5d2:	03c9d793          	srli	a5,s3,0x3c
 5d6:	97de                	add	a5,a5,s7
 5d8:	0007c583          	lbu	a1,0(a5)
 5dc:	8556                	mv	a0,s5
 5de:	00000097          	auipc	ra,0x0
 5e2:	e2c080e7          	jalr	-468(ra) # 40a <putc>
  for (i = 0; i < (sizeof(uint64) * 2); i++, x <<= 4)
 5e6:	0992                	slli	s3,s3,0x4
 5e8:	397d                	addiw	s2,s2,-1
 5ea:	fe0914e3          	bnez	s2,5d2 <vprintf+0x10c>
        printptr(fd, va_arg(ap, uint64));
 5ee:	8be2                	mv	s7,s8
      state = 0;
 5f0:	4981                	li	s3,0
 5f2:	6c02                	ld	s8,0(sp)
 5f4:	bf11                	j	508 <vprintf+0x42>
        s = va_arg(ap, char*);
 5f6:	008b8993          	addi	s3,s7,8
 5fa:	000bb903          	ld	s2,0(s7)
        if(s == 0)
 5fe:	02090163          	beqz	s2,620 <vprintf+0x15a>
        while(*s != 0){
 602:	00094583          	lbu	a1,0(s2)
 606:	c9a5                	beqz	a1,676 <vprintf+0x1b0>
          putc(fd, *s);
 608:	8556                	mv	a0,s5
 60a:	00000097          	auipc	ra,0x0
 60e:	e00080e7          	jalr	-512(ra) # 40a <putc>
          s++;
 612:	0905                	addi	s2,s2,1
        while(*s != 0){
 614:	00094583          	lbu	a1,0(s2)
 618:	f9e5                	bnez	a1,608 <vprintf+0x142>
        s = va_arg(ap, char*);
 61a:	8bce                	mv	s7,s3
      state = 0;
 61c:	4981                	li	s3,0
 61e:	b5ed                	j	508 <vprintf+0x42>
          s = "(null)";
 620:	00000917          	auipc	s2,0x0
 624:	4c890913          	addi	s2,s2,1224 # ae8 <ithread_join+0x6c>
        while(*s != 0){
 628:	02800593          	li	a1,40
 62c:	bff1                	j	608 <vprintf+0x142>
        putc(fd, va_arg(ap, uint));
 62e:	008b8913          	addi	s2,s7,8
 632:	000bc583          	lbu	a1,0(s7)
 636:	8556                	mv	a0,s5
 638:	00000097          	auipc	ra,0x0
 63c:	dd2080e7          	jalr	-558(ra) # 40a <putc>
 640:	8bca                	mv	s7,s2
      state = 0;
 642:	4981                	li	s3,0
 644:	b5d1                	j	508 <vprintf+0x42>
        putc(fd, c);
 646:	02500593          	li	a1,37
 64a:	8556                	mv	a0,s5
 64c:	00000097          	auipc	ra,0x0
 650:	dbe080e7          	jalr	-578(ra) # 40a <putc>
      state = 0;
 654:	4981                	li	s3,0
 656:	bd4d                	j	508 <vprintf+0x42>
        putc(fd, '%');
 658:	02500593          	li	a1,37
 65c:	8556                	mv	a0,s5
 65e:	00000097          	auipc	ra,0x0
 662:	dac080e7          	jalr	-596(ra) # 40a <putc>
        putc(fd, c);
 666:	85ca                	mv	a1,s2
 668:	8556                	mv	a0,s5
 66a:	00000097          	auipc	ra,0x0
 66e:	da0080e7          	jalr	-608(ra) # 40a <putc>
      state = 0;
 672:	4981                	li	s3,0
 674:	bd51                	j	508 <vprintf+0x42>
        s = va_arg(ap, char*);
 676:	8bce                	mv	s7,s3
      state = 0;
 678:	4981                	li	s3,0
 67a:	b579                	j	508 <vprintf+0x42>
 67c:	74e2                	ld	s1,56(sp)
 67e:	79a2                	ld	s3,40(sp)
 680:	7a02                	ld	s4,32(sp)
 682:	6ae2                	ld	s5,24(sp)
 684:	6b42                	ld	s6,16(sp)
 686:	6ba2                	ld	s7,8(sp)
    }
  }
}
 688:	60a6                	ld	ra,72(sp)
 68a:	6406                	ld	s0,64(sp)
 68c:	7942                	ld	s2,48(sp)
 68e:	6161                	addi	sp,sp,80
 690:	8082                	ret

0000000000000692 <fprintf>:

void
fprintf(int fd, const char *fmt, ...)
{
 692:	715d                	addi	sp,sp,-80
 694:	ec06                	sd	ra,24(sp)
 696:	e822                	sd	s0,16(sp)
 698:	1000                	addi	s0,sp,32
 69a:	e010                	sd	a2,0(s0)
 69c:	e414                	sd	a3,8(s0)
 69e:	e818                	sd	a4,16(s0)
 6a0:	ec1c                	sd	a5,24(s0)
 6a2:	03043023          	sd	a6,32(s0)
 6a6:	03143423          	sd	a7,40(s0)
  va_list ap;

  va_start(ap, fmt);
 6aa:	8622                	mv	a2,s0
 6ac:	fe843423          	sd	s0,-24(s0)
  vprintf(fd, fmt, ap);
 6b0:	00000097          	auipc	ra,0x0
 6b4:	e16080e7          	jalr	-490(ra) # 4c6 <vprintf>
}
 6b8:	60e2                	ld	ra,24(sp)
 6ba:	6442                	ld	s0,16(sp)
 6bc:	6161                	addi	sp,sp,80
 6be:	8082                	ret

00000000000006c0 <printf>:

void
printf(const char *fmt, ...)
{
 6c0:	711d                	addi	sp,sp,-96
 6c2:	ec06                	sd	ra,24(sp)
 6c4:	e822                	sd	s0,16(sp)
 6c6:	1000                	addi	s0,sp,32
 6c8:	e40c                	sd	a1,8(s0)
 6ca:	e810                	sd	a2,16(s0)
 6cc:	ec14                	sd	a3,24(s0)
 6ce:	f018                	sd	a4,32(s0)
 6d0:	f41c                	sd	a5,40(s0)
 6d2:	03043823          	sd	a6,48(s0)
 6d6:	03143c23          	sd	a7,56(s0)
  va_list ap;

  va_start(ap, fmt);
 6da:	00840613          	addi	a2,s0,8
 6de:	fec43423          	sd	a2,-24(s0)
  vprintf(1, fmt, ap);
 6e2:	85aa                	mv	a1,a0
 6e4:	4505                	li	a0,1
 6e6:	00000097          	auipc	ra,0x0
 6ea:	de0080e7          	jalr	-544(ra) # 4c6 <vprintf>
}
 6ee:	60e2                	ld	ra,24(sp)
 6f0:	6442                	ld	s0,16(sp)
 6f2:	6125                	addi	sp,sp,96
 6f4:	8082                	ret

00000000000006f6 <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 6f6:	1141                	addi	sp,sp,-16
 6f8:	e406                	sd	ra,8(sp)
 6fa:	e022                	sd	s0,0(sp)
 6fc:	0800                	addi	s0,sp,16
  Header *bp, *p;

  bp = (Header*)ap - 1;
 6fe:	ff050693          	addi	a3,a0,-16
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 702:	00001797          	auipc	a5,0x1
 706:	e0e7b783          	ld	a5,-498(a5) # 1510 <freep>
 70a:	a02d                	j	734 <free+0x3e>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
      break;
  if(bp + bp->s.size == p->s.ptr){
    bp->s.size += p->s.ptr->s.size;
 70c:	4618                	lw	a4,8(a2)
 70e:	9f2d                	addw	a4,a4,a1
 710:	fee52c23          	sw	a4,-8(a0)
    bp->s.ptr = p->s.ptr->s.ptr;
 714:	6398                	ld	a4,0(a5)
 716:	6310                	ld	a2,0(a4)
 718:	a83d                	j	756 <free+0x60>
  } else
    bp->s.ptr = p->s.ptr;
  if(p + p->s.size == bp){
    p->s.size += bp->s.size;
 71a:	ff852703          	lw	a4,-8(a0)
 71e:	9f31                	addw	a4,a4,a2
 720:	c798                	sw	a4,8(a5)
    p->s.ptr = bp->s.ptr;
 722:	ff053683          	ld	a3,-16(a0)
 726:	a091                	j	76a <free+0x74>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 728:	6398                	ld	a4,0(a5)
 72a:	00e7e463          	bltu	a5,a4,732 <free+0x3c>
 72e:	00e6ea63          	bltu	a3,a4,742 <free+0x4c>
{
 732:	87ba                	mv	a5,a4
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 734:	fed7fae3          	bgeu	a5,a3,728 <free+0x32>
 738:	6398                	ld	a4,0(a5)
 73a:	00e6e463          	bltu	a3,a4,742 <free+0x4c>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 73e:	fee7eae3          	bltu	a5,a4,732 <free+0x3c>
  if(bp + bp->s.size == p->s.ptr){
 742:	ff852583          	lw	a1,-8(a0)
 746:	6390                	ld	a2,0(a5)
 748:	02059813          	slli	a6,a1,0x20
 74c:	01c85713          	srli	a4,a6,0x1c
 750:	9736                	add	a4,a4,a3
 752:	fae60de3          	beq	a2,a4,70c <free+0x16>
    bp->s.ptr = p->s.ptr->s.ptr;
 756:	fec53823          	sd	a2,-16(a0)
  if(p + p->s.size == bp){
 75a:	4790                	lw	a2,8(a5)
 75c:	02061593          	slli	a1,a2,0x20
 760:	01c5d713          	srli	a4,a1,0x1c
 764:	973e                	add	a4,a4,a5
 766:	fae68ae3          	beq	a3,a4,71a <free+0x24>
    p->s.ptr = bp->s.ptr;
 76a:	e394                	sd	a3,0(a5)
  } else
    p->s.ptr = bp;
  freep = p;
 76c:	00001717          	auipc	a4,0x1
 770:	daf73223          	sd	a5,-604(a4) # 1510 <freep>
}
 774:	60a2                	ld	ra,8(sp)
 776:	6402                	ld	s0,0(sp)
 778:	0141                	addi	sp,sp,16
 77a:	8082                	ret

000000000000077c <malloc>:
  return freep;
}

void*
malloc(uint nbytes)
{
 77c:	7139                	addi	sp,sp,-64
 77e:	fc06                	sd	ra,56(sp)
 780:	f822                	sd	s0,48(sp)
 782:	f04a                	sd	s2,32(sp)
 784:	ec4e                	sd	s3,24(sp)
 786:	0080                	addi	s0,sp,64
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 788:	02051993          	slli	s3,a0,0x20
 78c:	0209d993          	srli	s3,s3,0x20
 790:	09bd                	addi	s3,s3,15
 792:	0049d993          	srli	s3,s3,0x4
 796:	2985                	addiw	s3,s3,1
 798:	894e                	mv	s2,s3
  if((prevp = freep) == 0){
 79a:	00001517          	auipc	a0,0x1
 79e:	d7653503          	ld	a0,-650(a0) # 1510 <freep>
 7a2:	c905                	beqz	a0,7d2 <malloc+0x56>
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 7a4:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
 7a6:	4798                	lw	a4,8(a5)
 7a8:	09377a63          	bgeu	a4,s3,83c <malloc+0xc0>
 7ac:	f426                	sd	s1,40(sp)
 7ae:	e852                	sd	s4,16(sp)
 7b0:	e456                	sd	s5,8(sp)
 7b2:	e05a                	sd	s6,0(sp)
  if(nu < 4096)
 7b4:	8a4e                	mv	s4,s3
 7b6:	6705                	lui	a4,0x1
 7b8:	00e9f363          	bgeu	s3,a4,7be <malloc+0x42>
 7bc:	6a05                	lui	s4,0x1
 7be:	000a0b1b          	sext.w	s6,s4
  p = sbrk(nu * sizeof(Header));
 7c2:	004a1a1b          	slliw	s4,s4,0x4
        p->s.size = nunits;
      }
      freep = prevp;
      return (void*)(p + 1);
    }
    if(p == freep)
 7c6:	00001497          	auipc	s1,0x1
 7ca:	d4a48493          	addi	s1,s1,-694 # 1510 <freep>
  if(p == (char*)-1)
 7ce:	5afd                	li	s5,-1
 7d0:	a089                	j	812 <malloc+0x96>
 7d2:	f426                	sd	s1,40(sp)
 7d4:	e852                	sd	s4,16(sp)
 7d6:	e456                	sd	s5,8(sp)
 7d8:	e05a                	sd	s6,0(sp)
    base.s.ptr = freep = prevp = &base;
 7da:	00001797          	auipc	a5,0x1
 7de:	d5678793          	addi	a5,a5,-682 # 1530 <base>
 7e2:	00001717          	auipc	a4,0x1
 7e6:	d2f73723          	sd	a5,-722(a4) # 1510 <freep>
 7ea:	e39c                	sd	a5,0(a5)
    base.s.size = 0;
 7ec:	0007a423          	sw	zero,8(a5)
    if(p->s.size >= nunits){
 7f0:	b7d1                	j	7b4 <malloc+0x38>
        prevp->s.ptr = p->s.ptr;
 7f2:	6398                	ld	a4,0(a5)
 7f4:	e118                	sd	a4,0(a0)
 7f6:	a8b9                	j	854 <malloc+0xd8>
  hp->s.size = nu;
 7f8:	01652423          	sw	s6,8(a0)
  free((void*)(hp + 1));
 7fc:	0541                	addi	a0,a0,16
 7fe:	00000097          	auipc	ra,0x0
 802:	ef8080e7          	jalr	-264(ra) # 6f6 <free>
  return freep;
 806:	6088                	ld	a0,0(s1)
      if((p = morecore(nunits)) == 0)
 808:	c135                	beqz	a0,86c <malloc+0xf0>
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 80a:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
 80c:	4798                	lw	a4,8(a5)
 80e:	03277363          	bgeu	a4,s2,834 <malloc+0xb8>
    if(p == freep)
 812:	6098                	ld	a4,0(s1)
 814:	853e                	mv	a0,a5
 816:	fef71ae3          	bne	a4,a5,80a <malloc+0x8e>
  p = sbrk(nu * sizeof(Header));
 81a:	8552                	mv	a0,s4
 81c:	00000097          	auipc	ra,0x0
 820:	b8e080e7          	jalr	-1138(ra) # 3aa <sbrk>
  if(p == (char*)-1)
 824:	fd551ae3          	bne	a0,s5,7f8 <malloc+0x7c>
        return 0;
 828:	4501                	li	a0,0
 82a:	74a2                	ld	s1,40(sp)
 82c:	6a42                	ld	s4,16(sp)
 82e:	6aa2                	ld	s5,8(sp)
 830:	6b02                	ld	s6,0(sp)
 832:	a03d                	j	860 <malloc+0xe4>
 834:	74a2                	ld	s1,40(sp)
 836:	6a42                	ld	s4,16(sp)
 838:	6aa2                	ld	s5,8(sp)
 83a:	6b02                	ld	s6,0(sp)
      if(p->s.size == nunits)
 83c:	fae90be3          	beq	s2,a4,7f2 <malloc+0x76>
        p->s.size -= nunits;
 840:	4137073b          	subw	a4,a4,s3
 844:	c798                	sw	a4,8(a5)
        p += p->s.size;
 846:	02071693          	slli	a3,a4,0x20
 84a:	01c6d713          	srli	a4,a3,0x1c
 84e:	97ba                	add	a5,a5,a4
        p->s.size = nunits;
 850:	0137a423          	sw	s3,8(a5)
      freep = prevp;
 854:	00001717          	auipc	a4,0x1
 858:	caa73e23          	sd	a0,-836(a4) # 1510 <freep>
      return (void*)(p + 1);
 85c:	01078513          	addi	a0,a5,16
  }
}
 860:	70e2                	ld	ra,56(sp)
 862:	7442                	ld	s0,48(sp)
 864:	7902                	ld	s2,32(sp)
 866:	69e2                	ld	s3,24(sp)
 868:	6121                	addi	sp,sp,64
 86a:	8082                	ret
 86c:	74a2                	ld	s1,40(sp)
 86e:	6a42                	ld	s4,16(sp)
 870:	6aa2                	ld	s5,8(sp)
 872:	6b02                	ld	s6,0(sp)
 874:	b7f5                	j	860 <malloc+0xe4>

0000000000000876 <ithread_exit>:
  free(stacks);
  stacks = new_stacks;
  return 0;
}

void ithread_exit(uint64 status) {
 876:	1141                	addi	sp,sp,-16
 878:	e406                	sd	ra,8(sp)
 87a:	e022                	sd	s0,0(sp)
 87c:	0800                	addi	s0,sp,16
  thread_exit(status);
 87e:	2501                	sext.w	a0,a0
 880:	00000097          	auipc	ra,0x0
 884:	b5a080e7          	jalr	-1190(ra) # 3da <thread_exit>
}
 888:	60a2                	ld	ra,8(sp)
 88a:	6402                	ld	s0,0(sp)
 88c:	0141                	addi	sp,sp,16
 88e:	8082                	ret

0000000000000890 <free_stacks>:
int free_stacks() {
 890:	7179                	addi	sp,sp,-48
 892:	f406                	sd	ra,40(sp)
 894:	f022                	sd	s0,32(sp)
 896:	ec26                	sd	s1,24(sp)
 898:	1800                	addi	s0,sp,48
  for (int i = 0; i < num_threads; i++) {
 89a:	00001797          	auipc	a5,0x1
 89e:	c867a783          	lw	a5,-890(a5) # 1520 <num_threads>
 8a2:	04f05063          	blez	a5,8e2 <free_stacks+0x52>
 8a6:	e84a                	sd	s2,16(sp)
 8a8:	e44e                	sd	s3,8(sp)
 8aa:	4481                	li	s1,0
    free(stacks[i]);
 8ac:	00001997          	auipc	s3,0x1
 8b0:	c6c98993          	addi	s3,s3,-916 # 1518 <stacks>
  for (int i = 0; i < num_threads; i++) {
 8b4:	00001917          	auipc	s2,0x1
 8b8:	c6c90913          	addi	s2,s2,-916 # 1520 <num_threads>
    free(stacks[i]);
 8bc:	0009b783          	ld	a5,0(s3)
 8c0:	00349713          	slli	a4,s1,0x3
 8c4:	97ba                	add	a5,a5,a4
 8c6:	6388                	ld	a0,0(a5)
 8c8:	00000097          	auipc	ra,0x0
 8cc:	e2e080e7          	jalr	-466(ra) # 6f6 <free>
  for (int i = 0; i < num_threads; i++) {
 8d0:	0485                	addi	s1,s1,1
 8d2:	00092703          	lw	a4,0(s2)
 8d6:	0004879b          	sext.w	a5,s1
 8da:	fee7c1e3          	blt	a5,a4,8bc <free_stacks+0x2c>
 8de:	6942                	ld	s2,16(sp)
 8e0:	69a2                	ld	s3,8(sp)
  free(stacks);
 8e2:	00001497          	auipc	s1,0x1
 8e6:	c3648493          	addi	s1,s1,-970 # 1518 <stacks>
 8ea:	6088                	ld	a0,0(s1)
 8ec:	00000097          	auipc	ra,0x0
 8f0:	e0a080e7          	jalr	-502(ra) # 6f6 <free>
  stacks = 0;
 8f4:	0004b023          	sd	zero,0(s1)
  num_threads = 0;
 8f8:	00001797          	auipc	a5,0x1
 8fc:	c207a423          	sw	zero,-984(a5) # 1520 <num_threads>
  max_stacks = INIT_MAX_STACKS;
 900:	47a1                	li	a5,8
 902:	00001717          	auipc	a4,0x1
 906:	bef72f23          	sw	a5,-1026(a4) # 1500 <max_stacks>
  threads_done = 0;
 90a:	00001797          	auipc	a5,0x1
 90e:	c007ad23          	sw	zero,-998(a5) # 1524 <threads_done>
}
 912:	4501                	li	a0,0
 914:	70a2                	ld	ra,40(sp)
 916:	7402                	ld	s0,32(sp)
 918:	64e2                	ld	s1,24(sp)
 91a:	6145                	addi	sp,sp,48
 91c:	8082                	ret

000000000000091e <expand_num_threads>:
int expand_num_threads() {
 91e:	1101                	addi	sp,sp,-32
 920:	ec06                	sd	ra,24(sp)
 922:	e822                	sd	s0,16(sp)
 924:	e426                	sd	s1,8(sp)
 926:	e04a                	sd	s2,0(sp)
 928:	1000                	addi	s0,sp,32
  max_stacks *= 2;
 92a:	00001797          	auipc	a5,0x1
 92e:	bd678793          	addi	a5,a5,-1066 # 1500 <max_stacks>
 932:	4388                	lw	a0,0(a5)
 934:	0015151b          	slliw	a0,a0,0x1
 938:	c388                	sw	a0,0(a5)
  void **new_stacks = malloc(max_stacks*sizeof(char*));
 93a:	0035151b          	slliw	a0,a0,0x3
 93e:	00000097          	auipc	ra,0x0
 942:	e3e080e7          	jalr	-450(ra) # 77c <malloc>
 946:	892a                	mv	s2,a0
  memmove(new_stacks, stacks, num_threads*sizeof(char*));
 948:	00001617          	auipc	a2,0x1
 94c:	bd862603          	lw	a2,-1064(a2) # 1520 <num_threads>
 950:	00001497          	auipc	s1,0x1
 954:	bc848493          	addi	s1,s1,-1080 # 1518 <stacks>
 958:	0036161b          	slliw	a2,a2,0x3
 95c:	608c                	ld	a1,0(s1)
 95e:	00000097          	auipc	ra,0x0
 962:	90a080e7          	jalr	-1782(ra) # 268 <memmove>
  free(stacks);
 966:	6088                	ld	a0,0(s1)
 968:	00000097          	auipc	ra,0x0
 96c:	d8e080e7          	jalr	-626(ra) # 6f6 <free>
  stacks = new_stacks;
 970:	0124b023          	sd	s2,0(s1)
}
 974:	4501                	li	a0,0
 976:	60e2                	ld	ra,24(sp)
 978:	6442                	ld	s0,16(sp)
 97a:	64a2                	ld	s1,8(sp)
 97c:	6902                	ld	s2,0(sp)
 97e:	6105                	addi	sp,sp,32
 980:	8082                	ret

0000000000000982 <ithread_create>:

int ithread_create(void* (*fn_ptr)(void *), void *args) {
 982:	7179                	addi	sp,sp,-48
 984:	f406                	sd	ra,40(sp)
 986:	f022                	sd	s0,32(sp)
 988:	e84a                	sd	s2,16(sp)
 98a:	e44e                	sd	s3,8(sp)
 98c:	1800                	addi	s0,sp,48
 98e:	892a                	mv	s2,a0
 990:	89ae                	mv	s3,a1
  if (stacks == 0) {
 992:	00001797          	auipc	a5,0x1
 996:	b867b783          	ld	a5,-1146(a5) # 1518 <stacks>
 99a:	c3d9                	beqz	a5,a20 <ithread_create+0x9e>
    stacks = malloc(max_stacks*sizeof(char*));
  }
  if (num_threads == max_stacks) {
 99c:	00001797          	auipc	a5,0x1
 9a0:	b647a783          	lw	a5,-1180(a5) # 1500 <max_stacks>
 9a4:	00001717          	auipc	a4,0x1
 9a8:	b7c72703          	lw	a4,-1156(a4) # 1520 <num_threads>
 9ac:	0af71363          	bne	a4,a5,a52 <ithread_create+0xd0>
    if (max_stacks == MAX_THREADS) {
 9b0:	04000713          	li	a4,64
 9b4:	08e78563          	beq	a5,a4,a3e <ithread_create+0xbc>
 9b8:	ec26                	sd	s1,24(sp)
      printf("ERROR: Thread capacity has been reached\n");
      return -1;
    }
    expand_num_threads();
 9ba:	00000097          	auipc	ra,0x0
 9be:	f64080e7          	jalr	-156(ra) # 91e <expand_num_threads>
  }

  void *stack_ptr = malloc(PGSIZE);
 9c2:	6505                	lui	a0,0x1
 9c4:	00000097          	auipc	ra,0x0
 9c8:	db8080e7          	jalr	-584(ra) # 77c <malloc>
 9cc:	84aa                	mv	s1,a0
  stacks[num_threads] = stack_ptr;
 9ce:	00001717          	auipc	a4,0x1
 9d2:	b5272703          	lw	a4,-1198(a4) # 1520 <num_threads>
 9d6:	070e                	slli	a4,a4,0x3
 9d8:	00001797          	auipc	a5,0x1
 9dc:	b407b783          	ld	a5,-1216(a5) # 1518 <stacks>
 9e0:	97ba                	add	a5,a5,a4
 9e2:	e388                	sd	a0,0(a5)
  int res = create_thread(fn_ptr, args, stack_ptr, &ithread_exit);
 9e4:	00000697          	auipc	a3,0x0
 9e8:	e9268693          	addi	a3,a3,-366 # 876 <ithread_exit>
 9ec:	862a                	mv	a2,a0
 9ee:	85ce                	mv	a1,s3
 9f0:	854a                	mv	a0,s2
 9f2:	00000097          	auipc	ra,0x0
 9f6:	9d8080e7          	jalr	-1576(ra) # 3ca <create_thread>
 9fa:	892a                	mv	s2,a0
  if (res != -1) {
 9fc:	57fd                	li	a5,-1
 9fe:	04f50c63          	beq	a0,a5,a56 <ithread_create+0xd4>
    num_threads++;
 a02:	00001717          	auipc	a4,0x1
 a06:	b1e70713          	addi	a4,a4,-1250 # 1520 <num_threads>
 a0a:	431c                	lw	a5,0(a4)
 a0c:	2785                	addiw	a5,a5,1
 a0e:	c31c                	sw	a5,0(a4)
 a10:	64e2                	ld	s1,24(sp)
  } else {
    free(stack_ptr);
    stacks[num_threads] = 0;
  }
  return res;
}
 a12:	854a                	mv	a0,s2
 a14:	70a2                	ld	ra,40(sp)
 a16:	7402                	ld	s0,32(sp)
 a18:	6942                	ld	s2,16(sp)
 a1a:	69a2                	ld	s3,8(sp)
 a1c:	6145                	addi	sp,sp,48
 a1e:	8082                	ret
    stacks = malloc(max_stacks*sizeof(char*));
 a20:	00001517          	auipc	a0,0x1
 a24:	ae052503          	lw	a0,-1312(a0) # 1500 <max_stacks>
 a28:	0035151b          	slliw	a0,a0,0x3
 a2c:	00000097          	auipc	ra,0x0
 a30:	d50080e7          	jalr	-688(ra) # 77c <malloc>
 a34:	00001797          	auipc	a5,0x1
 a38:	aea7b223          	sd	a0,-1308(a5) # 1518 <stacks>
 a3c:	b785                	j	99c <ithread_create+0x1a>
      printf("ERROR: Thread capacity has been reached\n");
 a3e:	00000517          	auipc	a0,0x0
 a42:	0b250513          	addi	a0,a0,178 # af0 <ithread_join+0x74>
 a46:	00000097          	auipc	ra,0x0
 a4a:	c7a080e7          	jalr	-902(ra) # 6c0 <printf>
      return -1;
 a4e:	597d                	li	s2,-1
 a50:	b7c9                	j	a12 <ithread_create+0x90>
 a52:	ec26                	sd	s1,24(sp)
 a54:	b7bd                	j	9c2 <ithread_create+0x40>
    free(stack_ptr);
 a56:	8526                	mv	a0,s1
 a58:	00000097          	auipc	ra,0x0
 a5c:	c9e080e7          	jalr	-866(ra) # 6f6 <free>
    stacks[num_threads] = 0;
 a60:	00001717          	auipc	a4,0x1
 a64:	ac072703          	lw	a4,-1344(a4) # 1520 <num_threads>
 a68:	070e                	slli	a4,a4,0x3
 a6a:	00001797          	auipc	a5,0x1
 a6e:	aae7b783          	ld	a5,-1362(a5) # 1518 <stacks>
 a72:	97ba                	add	a5,a5,a4
 a74:	0007b023          	sd	zero,0(a5)
 a78:	64e2                	ld	s1,24(sp)
 a7a:	bf61                	j	a12 <ithread_create+0x90>

0000000000000a7c <ithread_join>:

int ithread_join(int thread_id) {
 a7c:	1101                	addi	sp,sp,-32
 a7e:	ec06                	sd	ra,24(sp)
 a80:	e822                	sd	s0,16(sp)
 a82:	1000                	addi	s0,sp,32
  int status;
  join_thread(thread_id, (uint64)&status);
 a84:	ff040793          	addi	a5,s0,-16
 a88:	ffc7859b          	addiw	a1,a5,-4
 a8c:	00000097          	auipc	ra,0x0
 a90:	946080e7          	jalr	-1722(ra) # 3d2 <join_thread>
  threads_done++;
 a94:	00001717          	auipc	a4,0x1
 a98:	a9070713          	addi	a4,a4,-1392 # 1524 <threads_done>
 a9c:	431c                	lw	a5,0(a4)
 a9e:	2785                	addiw	a5,a5,1
 aa0:	c31c                	sw	a5,0(a4)
  if (threads_done == num_threads) {
 aa2:	00001717          	auipc	a4,0x1
 aa6:	a7e72703          	lw	a4,-1410(a4) # 1520 <num_threads>
 aaa:	00f70863          	beq	a4,a5,aba <ithread_join+0x3e>
    free_stacks();
  }
  return status;
}
 aae:	fec42503          	lw	a0,-20(s0)
 ab2:	60e2                	ld	ra,24(sp)
 ab4:	6442                	ld	s0,16(sp)
 ab6:	6105                	addi	sp,sp,32
 ab8:	8082                	ret
    free_stacks();
 aba:	00000097          	auipc	ra,0x0
 abe:	dd6080e7          	jalr	-554(ra) # 890 <free_stacks>
 ac2:	b7f5                	j	aae <ithread_join+0x32>
