
src/user/_kill:     file format elf64-littleriscv


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
  2c:	240080e7          	jalr	576(ra) # 268 <atoi>
  30:	00000097          	auipc	ra,0x0
  34:	3fa080e7          	jalr	1018(ra) # 42a <kill>
  for(i=1; i<argc; i++)
  38:	04a1                	addi	s1,s1,8
  3a:	ff2496e3          	bne	s1,s2,26 <main+0x26>
  exit(0);
  3e:	4501                	li	a0,0
  40:	00000097          	auipc	ra,0x0
  44:	3ba080e7          	jalr	954(ra) # 3fa <exit>
  48:	e426                	sd	s1,8(sp)
  4a:	e04a                	sd	s2,0(sp)
    fprintf(2, "usage: kill pid...\n");
  4c:	00001597          	auipc	a1,0x1
  50:	b9458593          	addi	a1,a1,-1132 # be0 <ithread_join+0x52>
  54:	4509                	li	a0,2
  56:	00000097          	auipc	ra,0x0
  5a:	74c080e7          	jalr	1868(ra) # 7a2 <fprintf>
    exit(1);
  5e:	4505                	li	a0,1
  60:	00000097          	auipc	ra,0x0
  64:	39a080e7          	jalr	922(ra) # 3fa <exit>

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
  7e:	380080e7          	jalr	896(ra) # 3fa <exit>

0000000000000082 <strcpy>:
}

char*
strcpy(char *s, const char *t)
{
  82:	1141                	addi	sp,sp,-16
  84:	e422                	sd	s0,8(sp)
  86:	0800                	addi	s0,sp,16
  char *os;

  os = s;
  while((*s++ = *t++) != 0)
  88:	87aa                	mv	a5,a0
  8a:	0585                	addi	a1,a1,1
  8c:	0785                	addi	a5,a5,1
  8e:	fff5c703          	lbu	a4,-1(a1)
  92:	fee78fa3          	sb	a4,-1(a5)
  96:	fb75                	bnez	a4,8a <strcpy+0x8>
    ;
  return os;
}
  98:	6422                	ld	s0,8(sp)
  9a:	0141                	addi	sp,sp,16
  9c:	8082                	ret

000000000000009e <strcmp>:

int
strcmp(const char *p, const char *q)
{
  9e:	1141                	addi	sp,sp,-16
  a0:	e422                	sd	s0,8(sp)
  a2:	0800                	addi	s0,sp,16
  while(*p && *p == *q)
  a4:	00054783          	lbu	a5,0(a0)
  a8:	cb91                	beqz	a5,bc <strcmp+0x1e>
  aa:	0005c703          	lbu	a4,0(a1)
  ae:	00f71763          	bne	a4,a5,bc <strcmp+0x1e>
    p++, q++;
  b2:	0505                	addi	a0,a0,1
  b4:	0585                	addi	a1,a1,1
  while(*p && *p == *q)
  b6:	00054783          	lbu	a5,0(a0)
  ba:	fbe5                	bnez	a5,aa <strcmp+0xc>
  return (uchar)*p - (uchar)*q;
  bc:	0005c503          	lbu	a0,0(a1)
}
  c0:	40a7853b          	subw	a0,a5,a0
  c4:	6422                	ld	s0,8(sp)
  c6:	0141                	addi	sp,sp,16
  c8:	8082                	ret

00000000000000ca <strlen>:

uint
strlen(const char *s)
{
  ca:	1141                	addi	sp,sp,-16
  cc:	e422                	sd	s0,8(sp)
  ce:	0800                	addi	s0,sp,16
  int n;

  for(n = 0; s[n]; n++)
  d0:	00054783          	lbu	a5,0(a0)
  d4:	cf91                	beqz	a5,f0 <strlen+0x26>
  d6:	0505                	addi	a0,a0,1
  d8:	87aa                	mv	a5,a0
  da:	86be                	mv	a3,a5
  dc:	0785                	addi	a5,a5,1
  de:	fff7c703          	lbu	a4,-1(a5)
  e2:	ff65                	bnez	a4,da <strlen+0x10>
  e4:	40a6853b          	subw	a0,a3,a0
  e8:	2505                	addiw	a0,a0,1
    ;
  return n;
}
  ea:	6422                	ld	s0,8(sp)
  ec:	0141                	addi	sp,sp,16
  ee:	8082                	ret
  for(n = 0; s[n]; n++)
  f0:	4501                	li	a0,0
  f2:	bfe5                	j	ea <strlen+0x20>

00000000000000f4 <memset>:

void*
memset(void *dst, int c, uint n)
{
  f4:	1141                	addi	sp,sp,-16
  f6:	e422                	sd	s0,8(sp)
  f8:	0800                	addi	s0,sp,16
  char *cdst = (char *) dst;
  int i;
  for(i = 0; i < n; i++){
  fa:	ca19                	beqz	a2,110 <memset+0x1c>
  fc:	87aa                	mv	a5,a0
  fe:	1602                	slli	a2,a2,0x20
 100:	9201                	srli	a2,a2,0x20
 102:	00a60733          	add	a4,a2,a0
    cdst[i] = c;
 106:	00b78023          	sb	a1,0(a5)
  for(i = 0; i < n; i++){
 10a:	0785                	addi	a5,a5,1
 10c:	fee79de3          	bne	a5,a4,106 <memset+0x12>
  }
  return dst;
}
 110:	6422                	ld	s0,8(sp)
 112:	0141                	addi	sp,sp,16
 114:	8082                	ret

0000000000000116 <strchr>:

char*
strchr(const char *s, char c)
{
 116:	1141                	addi	sp,sp,-16
 118:	e422                	sd	s0,8(sp)
 11a:	0800                	addi	s0,sp,16
  for(; *s; s++)
 11c:	00054783          	lbu	a5,0(a0)
 120:	cb99                	beqz	a5,136 <strchr+0x20>
    if(*s == c)
 122:	00f58763          	beq	a1,a5,130 <strchr+0x1a>
  for(; *s; s++)
 126:	0505                	addi	a0,a0,1
 128:	00054783          	lbu	a5,0(a0)
 12c:	fbfd                	bnez	a5,122 <strchr+0xc>
      return (char*)s;
  return 0;
 12e:	4501                	li	a0,0
}
 130:	6422                	ld	s0,8(sp)
 132:	0141                	addi	sp,sp,16
 134:	8082                	ret
  return 0;
 136:	4501                	li	a0,0
 138:	bfe5                	j	130 <strchr+0x1a>

000000000000013a <gets>:

char*
gets(char *buf, int max)
{
 13a:	711d                	addi	sp,sp,-96
 13c:	ec86                	sd	ra,88(sp)
 13e:	e8a2                	sd	s0,80(sp)
 140:	e4a6                	sd	s1,72(sp)
 142:	e0ca                	sd	s2,64(sp)
 144:	fc4e                	sd	s3,56(sp)
 146:	f852                	sd	s4,48(sp)
 148:	f456                	sd	s5,40(sp)
 14a:	f05a                	sd	s6,32(sp)
 14c:	ec5e                	sd	s7,24(sp)
 14e:	1080                	addi	s0,sp,96
 150:	8baa                	mv	s7,a0
 152:	8a2e                	mv	s4,a1
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 154:	892a                	mv	s2,a0
 156:	4481                	li	s1,0
    cc = read(0, &c, 1);
    if(cc < 1)
      break;
    buf[i++] = c;
    if(c == '\n' || c == '\r')
 158:	4aa9                	li	s5,10
 15a:	4b35                	li	s6,13
  for(i=0; i+1 < max; ){
 15c:	89a6                	mv	s3,s1
 15e:	2485                	addiw	s1,s1,1
 160:	0344d863          	bge	s1,s4,190 <gets+0x56>
    cc = read(0, &c, 1);
 164:	4605                	li	a2,1
 166:	faf40593          	addi	a1,s0,-81
 16a:	4501                	li	a0,0
 16c:	00000097          	auipc	ra,0x0
 170:	2a6080e7          	jalr	678(ra) # 412 <read>
    if(cc < 1)
 174:	00a05e63          	blez	a0,190 <gets+0x56>
    buf[i++] = c;
 178:	faf44783          	lbu	a5,-81(s0)
 17c:	00f90023          	sb	a5,0(s2)
    if(c == '\n' || c == '\r')
 180:	01578763          	beq	a5,s5,18e <gets+0x54>
 184:	0905                	addi	s2,s2,1
 186:	fd679be3          	bne	a5,s6,15c <gets+0x22>
    buf[i++] = c;
 18a:	89a6                	mv	s3,s1
 18c:	a011                	j	190 <gets+0x56>
 18e:	89a6                	mv	s3,s1
      break;
  }
  buf[i] = '\0';
 190:	99de                	add	s3,s3,s7
 192:	00098023          	sb	zero,0(s3)
  return buf;
}
 196:	855e                	mv	a0,s7
 198:	60e6                	ld	ra,88(sp)
 19a:	6446                	ld	s0,80(sp)
 19c:	64a6                	ld	s1,72(sp)
 19e:	6906                	ld	s2,64(sp)
 1a0:	79e2                	ld	s3,56(sp)
 1a2:	7a42                	ld	s4,48(sp)
 1a4:	7aa2                	ld	s5,40(sp)
 1a6:	7b02                	ld	s6,32(sp)
 1a8:	6be2                	ld	s7,24(sp)
 1aa:	6125                	addi	sp,sp,96
 1ac:	8082                	ret

00000000000001ae <fgetstdin>:

int
fgetstdin(char *buf, int size) {
 1ae:	711d                	addi	sp,sp,-96
 1b0:	ec86                	sd	ra,88(sp)
 1b2:	e8a2                	sd	s0,80(sp)
 1b4:	e4a6                	sd	s1,72(sp)
 1b6:	e0ca                	sd	s2,64(sp)
 1b8:	fc4e                	sd	s3,56(sp)
 1ba:	f852                	sd	s4,48(sp)
 1bc:	f456                	sd	s5,40(sp)
 1be:	f05a                	sd	s6,32(sp)
 1c0:	ec5e                	sd	s7,24(sp)
 1c2:	1080                	addi	s0,sp,96
 1c4:	8baa                	mv	s7,a0
 1c6:	89ae                	mv	s3,a1
  int i, cc;
  char c;

  for(i=0; i+1 < size; ){
 1c8:	892a                	mv	s2,a0
 1ca:	4481                	li	s1,0
    cc = read(0, &c, 1);
    if(cc < 1)
      break;
    buf[i++] = c;
    if(c == '\n' || c == '\r')
 1cc:	4aa9                	li	s5,10
 1ce:	4b35                	li	s6,13
  for(i=0; i+1 < size; ){
 1d0:	8a26                	mv	s4,s1
 1d2:	2485                	addiw	s1,s1,1
 1d4:	0334d863          	bge	s1,s3,204 <fgetstdin+0x56>
    cc = read(0, &c, 1);
 1d8:	4605                	li	a2,1
 1da:	faf40593          	addi	a1,s0,-81
 1de:	4501                	li	a0,0
 1e0:	00000097          	auipc	ra,0x0
 1e4:	232080e7          	jalr	562(ra) # 412 <read>
    if(cc < 1)
 1e8:	00a05e63          	blez	a0,204 <fgetstdin+0x56>
    buf[i++] = c;
 1ec:	faf44783          	lbu	a5,-81(s0)
 1f0:	00f90023          	sb	a5,0(s2)
    if(c == '\n' || c == '\r')
 1f4:	01578763          	beq	a5,s5,202 <fgetstdin+0x54>
 1f8:	0905                	addi	s2,s2,1
 1fa:	fd679be3          	bne	a5,s6,1d0 <fgetstdin+0x22>
    buf[i++] = c;
 1fe:	8a26                	mv	s4,s1
 200:	a011                	j	204 <fgetstdin+0x56>
 202:	8a26                	mv	s4,s1
      break;
  }
  buf[i] = '\0';
 204:	9bd2                	add	s7,s7,s4
 206:	000b8023          	sb	zero,0(s7)
  return i;
}
 20a:	8552                	mv	a0,s4
 20c:	60e6                	ld	ra,88(sp)
 20e:	6446                	ld	s0,80(sp)
 210:	64a6                	ld	s1,72(sp)
 212:	6906                	ld	s2,64(sp)
 214:	79e2                	ld	s3,56(sp)
 216:	7a42                	ld	s4,48(sp)
 218:	7aa2                	ld	s5,40(sp)
 21a:	7b02                	ld	s6,32(sp)
 21c:	6be2                	ld	s7,24(sp)
 21e:	6125                	addi	sp,sp,96
 220:	8082                	ret

0000000000000222 <stat>:

int
stat(const char *n, struct stat *st)
{
 222:	1101                	addi	sp,sp,-32
 224:	ec06                	sd	ra,24(sp)
 226:	e822                	sd	s0,16(sp)
 228:	e04a                	sd	s2,0(sp)
 22a:	1000                	addi	s0,sp,32
 22c:	892e                	mv	s2,a1
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 22e:	4581                	li	a1,0
 230:	00000097          	auipc	ra,0x0
 234:	20a080e7          	jalr	522(ra) # 43a <open>
  if(fd < 0)
 238:	02054663          	bltz	a0,264 <stat+0x42>
 23c:	e426                	sd	s1,8(sp)
 23e:	84aa                	mv	s1,a0
    return -1;
  r = fstat(fd, st);
 240:	85ca                	mv	a1,s2
 242:	00000097          	auipc	ra,0x0
 246:	210080e7          	jalr	528(ra) # 452 <fstat>
 24a:	892a                	mv	s2,a0
  close(fd);
 24c:	8526                	mv	a0,s1
 24e:	00000097          	auipc	ra,0x0
 252:	1d4080e7          	jalr	468(ra) # 422 <close>
  return r;
 256:	64a2                	ld	s1,8(sp)
}
 258:	854a                	mv	a0,s2
 25a:	60e2                	ld	ra,24(sp)
 25c:	6442                	ld	s0,16(sp)
 25e:	6902                	ld	s2,0(sp)
 260:	6105                	addi	sp,sp,32
 262:	8082                	ret
    return -1;
 264:	597d                	li	s2,-1
 266:	bfcd                	j	258 <stat+0x36>

0000000000000268 <atoi>:

int
atoi(const char *s)
{
 268:	1141                	addi	sp,sp,-16
 26a:	e422                	sd	s0,8(sp)
 26c:	0800                	addi	s0,sp,16
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
 26e:	00054683          	lbu	a3,0(a0)
 272:	fd06879b          	addiw	a5,a3,-48
 276:	0ff7f793          	zext.b	a5,a5
 27a:	4625                	li	a2,9
 27c:	02f66863          	bltu	a2,a5,2ac <atoi+0x44>
 280:	872a                	mv	a4,a0
  n = 0;
 282:	4501                	li	a0,0
    n = n*10 + *s++ - '0';
 284:	0705                	addi	a4,a4,1
 286:	0025179b          	slliw	a5,a0,0x2
 28a:	9fa9                	addw	a5,a5,a0
 28c:	0017979b          	slliw	a5,a5,0x1
 290:	9fb5                	addw	a5,a5,a3
 292:	fd07851b          	addiw	a0,a5,-48
  while('0' <= *s && *s <= '9')
 296:	00074683          	lbu	a3,0(a4)
 29a:	fd06879b          	addiw	a5,a3,-48
 29e:	0ff7f793          	zext.b	a5,a5
 2a2:	fef671e3          	bgeu	a2,a5,284 <atoi+0x1c>
  return n;
}
 2a6:	6422                	ld	s0,8(sp)
 2a8:	0141                	addi	sp,sp,16
 2aa:	8082                	ret
  n = 0;
 2ac:	4501                	li	a0,0
 2ae:	bfe5                	j	2a6 <atoi+0x3e>

00000000000002b0 <memmove>:

void*
memmove(void *vdst, const void *vsrc, int n)
{
 2b0:	1141                	addi	sp,sp,-16
 2b2:	e422                	sd	s0,8(sp)
 2b4:	0800                	addi	s0,sp,16
  char *dst;
  const char *src;

  dst = vdst;
  src = vsrc;
  if (src > dst) {
 2b6:	02b57463          	bgeu	a0,a1,2de <memmove+0x2e>
    while(n-- > 0)
 2ba:	00c05f63          	blez	a2,2d8 <memmove+0x28>
 2be:	1602                	slli	a2,a2,0x20
 2c0:	9201                	srli	a2,a2,0x20
 2c2:	00c507b3          	add	a5,a0,a2
  dst = vdst;
 2c6:	872a                	mv	a4,a0
      *dst++ = *src++;
 2c8:	0585                	addi	a1,a1,1
 2ca:	0705                	addi	a4,a4,1
 2cc:	fff5c683          	lbu	a3,-1(a1)
 2d0:	fed70fa3          	sb	a3,-1(a4)
    while(n-- > 0)
 2d4:	fef71ae3          	bne	a4,a5,2c8 <memmove+0x18>
    src += n;
    while(n-- > 0)
      *--dst = *--src;
  }
  return vdst;
}
 2d8:	6422                	ld	s0,8(sp)
 2da:	0141                	addi	sp,sp,16
 2dc:	8082                	ret
    dst += n;
 2de:	00c50733          	add	a4,a0,a2
    src += n;
 2e2:	95b2                	add	a1,a1,a2
    while(n-- > 0)
 2e4:	fec05ae3          	blez	a2,2d8 <memmove+0x28>
 2e8:	fff6079b          	addiw	a5,a2,-1
 2ec:	1782                	slli	a5,a5,0x20
 2ee:	9381                	srli	a5,a5,0x20
 2f0:	fff7c793          	not	a5,a5
 2f4:	97ba                	add	a5,a5,a4
      *--dst = *--src;
 2f6:	15fd                	addi	a1,a1,-1
 2f8:	177d                	addi	a4,a4,-1
 2fa:	0005c683          	lbu	a3,0(a1)
 2fe:	00d70023          	sb	a3,0(a4)
    while(n-- > 0)
 302:	fee79ae3          	bne	a5,a4,2f6 <memmove+0x46>
 306:	bfc9                	j	2d8 <memmove+0x28>

0000000000000308 <memcmp>:

int
memcmp(const void *s1, const void *s2, uint n)
{
 308:	1141                	addi	sp,sp,-16
 30a:	e422                	sd	s0,8(sp)
 30c:	0800                	addi	s0,sp,16
  const char *p1 = s1, *p2 = s2;
  while (n-- > 0) {
 30e:	ca05                	beqz	a2,33e <memcmp+0x36>
 310:	fff6069b          	addiw	a3,a2,-1
 314:	1682                	slli	a3,a3,0x20
 316:	9281                	srli	a3,a3,0x20
 318:	0685                	addi	a3,a3,1
 31a:	96aa                	add	a3,a3,a0
    if (*p1 != *p2) {
 31c:	00054783          	lbu	a5,0(a0)
 320:	0005c703          	lbu	a4,0(a1)
 324:	00e79863          	bne	a5,a4,334 <memcmp+0x2c>
      return *p1 - *p2;
    }
    p1++;
 328:	0505                	addi	a0,a0,1
    p2++;
 32a:	0585                	addi	a1,a1,1
  while (n-- > 0) {
 32c:	fed518e3          	bne	a0,a3,31c <memcmp+0x14>
  }
  return 0;
 330:	4501                	li	a0,0
 332:	a019                	j	338 <memcmp+0x30>
      return *p1 - *p2;
 334:	40e7853b          	subw	a0,a5,a4
}
 338:	6422                	ld	s0,8(sp)
 33a:	0141                	addi	sp,sp,16
 33c:	8082                	ret
  return 0;
 33e:	4501                	li	a0,0
 340:	bfe5                	j	338 <memcmp+0x30>

0000000000000342 <memcpy>:

void *
memcpy(void *dst, const void *src, uint n)
{
 342:	1141                	addi	sp,sp,-16
 344:	e406                	sd	ra,8(sp)
 346:	e022                	sd	s0,0(sp)
 348:	0800                	addi	s0,sp,16
  return memmove(dst, src, n);
 34a:	00000097          	auipc	ra,0x0
 34e:	f66080e7          	jalr	-154(ra) # 2b0 <memmove>
}
 352:	60a2                	ld	ra,8(sp)
 354:	6402                	ld	s0,0(sp)
 356:	0141                	addi	sp,sp,16
 358:	8082                	ret

000000000000035a <inet_addr>:

// Parse a dotted-decimal IPv4 string (e.g. "10.10.0.2") and return the
// address as a 32-bit integer in host byte order, or 0 on failure.
uint
inet_addr(const char *s)
{
 35a:	1141                	addi	sp,sp,-16
 35c:	e422                	sd	s0,8(sp)
 35e:	0800                	addi	s0,sp,16
  uint result = 0;
  int octet = 0;
  int digits = 0;
  int dots = 0;

  for (; *s; s++) {
 360:	00054783          	lbu	a5,0(a0)
 364:	cfbd                	beqz	a5,3e2 <inet_addr+0x88>
  int dots = 0;
 366:	4801                	li	a6,0
  int digits = 0;
 368:	4601                	li	a2,0
  int octet = 0;
 36a:	4681                	li	a3,0
  uint result = 0;
 36c:	4581                	li	a1,0
    if (*s >= '0' && *s <= '9') {
 36e:	48a5                	li	a7,9
      octet = octet * 10 + (*s - '0');
      digits++;
      if (octet > 255)
        return 0;
    } else if (*s == '.') {
 370:	02e00e93          	li	t4,46
      if (digits == 0 || dots == 3)
 374:	4f0d                	li	t5,3
        return 0;
      result = (result << 8) | (uint)octet;
      octet = 0;
      digits = 0;
 376:	4301                	li	t1,0
      if (octet > 255)
 378:	0ff00e13          	li	t3,255
 37c:	a015                	j	3a0 <inet_addr+0x46>
    } else if (*s == '.') {
 37e:	07d79463          	bne	a5,t4,3e6 <inet_addr+0x8c>
      if (digits == 0 || dots == 3)
 382:	c625                	beqz	a2,3ea <inet_addr+0x90>
 384:	07e80563          	beq	a6,t5,3ee <inet_addr+0x94>
      result = (result << 8) | (uint)octet;
 388:	0085959b          	slliw	a1,a1,0x8
 38c:	8ecd                	or	a3,a3,a1
 38e:	0006859b          	sext.w	a1,a3
      dots++;
 392:	2805                	addiw	a6,a6,1
      digits = 0;
 394:	861a                	mv	a2,t1
      octet = 0;
 396:	869a                	mv	a3,t1
  for (; *s; s++) {
 398:	0505                	addi	a0,a0,1
 39a:	00054783          	lbu	a5,0(a0)
 39e:	c79d                	beqz	a5,3cc <inet_addr+0x72>
    if (*s >= '0' && *s <= '9') {
 3a0:	fd07871b          	addiw	a4,a5,-48
 3a4:	0ff77713          	zext.b	a4,a4
 3a8:	fce8ebe3          	bltu	a7,a4,37e <inet_addr+0x24>
      octet = octet * 10 + (*s - '0');
 3ac:	0026971b          	slliw	a4,a3,0x2
 3b0:	9f35                	addw	a4,a4,a3
 3b2:	0017171b          	slliw	a4,a4,0x1
 3b6:	fd07879b          	addiw	a5,a5,-48
 3ba:	00e786bb          	addw	a3,a5,a4
      digits++;
 3be:	2605                	addiw	a2,a2,1
      if (octet > 255)
 3c0:	fcde5ce3          	bge	t3,a3,398 <inet_addr+0x3e>
        return 0;
 3c4:	4501                	li	a0,0
  if (digits == 0 || dots != 3)
    return 0;

  result = (result << 8) | (uint)octet;
  return result;
}
 3c6:	6422                	ld	s0,8(sp)
 3c8:	0141                	addi	sp,sp,16
 3ca:	8082                	ret
    return 0;
 3cc:	4501                	li	a0,0
  if (digits == 0 || dots != 3)
 3ce:	de65                	beqz	a2,3c6 <inet_addr+0x6c>
 3d0:	478d                	li	a5,3
 3d2:	fef81ae3          	bne	a6,a5,3c6 <inet_addr+0x6c>
  result = (result << 8) | (uint)octet;
 3d6:	0085959b          	slliw	a1,a1,0x8
 3da:	8ecd                	or	a3,a3,a1
 3dc:	0006851b          	sext.w	a0,a3
  return result;
 3e0:	b7dd                	j	3c6 <inet_addr+0x6c>
    return 0;
 3e2:	4501                	li	a0,0
 3e4:	b7cd                	j	3c6 <inet_addr+0x6c>
      return 0;
 3e6:	4501                	li	a0,0
 3e8:	bff9                	j	3c6 <inet_addr+0x6c>
        return 0;
 3ea:	4501                	li	a0,0
 3ec:	bfe9                	j	3c6 <inet_addr+0x6c>
 3ee:	4501                	li	a0,0
 3f0:	bfd9                	j	3c6 <inet_addr+0x6c>

00000000000003f2 <fork>:
# generated by usys.pl - do not edit
#include "kernel/syscall.h"
.global fork
fork:
 li a7, SYS_fork
 3f2:	4885                	li	a7,1
 ecall
 3f4:	00000073          	ecall
 ret
 3f8:	8082                	ret

00000000000003fa <exit>:
.global exit
exit:
 li a7, SYS_exit
 3fa:	4889                	li	a7,2
 ecall
 3fc:	00000073          	ecall
 ret
 400:	8082                	ret

0000000000000402 <wait>:
.global wait
wait:
 li a7, SYS_wait
 402:	488d                	li	a7,3
 ecall
 404:	00000073          	ecall
 ret
 408:	8082                	ret

000000000000040a <pipe>:
.global pipe
pipe:
 li a7, SYS_pipe
 40a:	4891                	li	a7,4
 ecall
 40c:	00000073          	ecall
 ret
 410:	8082                	ret

0000000000000412 <read>:
.global read
read:
 li a7, SYS_read
 412:	4895                	li	a7,5
 ecall
 414:	00000073          	ecall
 ret
 418:	8082                	ret

000000000000041a <write>:
.global write
write:
 li a7, SYS_write
 41a:	48c1                	li	a7,16
 ecall
 41c:	00000073          	ecall
 ret
 420:	8082                	ret

0000000000000422 <close>:
.global close
close:
 li a7, SYS_close
 422:	48d5                	li	a7,21
 ecall
 424:	00000073          	ecall
 ret
 428:	8082                	ret

000000000000042a <kill>:
.global kill
kill:
 li a7, SYS_kill
 42a:	4899                	li	a7,6
 ecall
 42c:	00000073          	ecall
 ret
 430:	8082                	ret

0000000000000432 <exec>:
.global exec
exec:
 li a7, SYS_exec
 432:	489d                	li	a7,7
 ecall
 434:	00000073          	ecall
 ret
 438:	8082                	ret

000000000000043a <open>:
.global open
open:
 li a7, SYS_open
 43a:	48bd                	li	a7,15
 ecall
 43c:	00000073          	ecall
 ret
 440:	8082                	ret

0000000000000442 <mknod>:
.global mknod
mknod:
 li a7, SYS_mknod
 442:	48c5                	li	a7,17
 ecall
 444:	00000073          	ecall
 ret
 448:	8082                	ret

000000000000044a <unlink>:
.global unlink
unlink:
 li a7, SYS_unlink
 44a:	48c9                	li	a7,18
 ecall
 44c:	00000073          	ecall
 ret
 450:	8082                	ret

0000000000000452 <fstat>:
.global fstat
fstat:
 li a7, SYS_fstat
 452:	48a1                	li	a7,8
 ecall
 454:	00000073          	ecall
 ret
 458:	8082                	ret

000000000000045a <link>:
.global link
link:
 li a7, SYS_link
 45a:	48cd                	li	a7,19
 ecall
 45c:	00000073          	ecall
 ret
 460:	8082                	ret

0000000000000462 <mkdir>:
.global mkdir
mkdir:
 li a7, SYS_mkdir
 462:	48d1                	li	a7,20
 ecall
 464:	00000073          	ecall
 ret
 468:	8082                	ret

000000000000046a <chdir>:
.global chdir
chdir:
 li a7, SYS_chdir
 46a:	48a5                	li	a7,9
 ecall
 46c:	00000073          	ecall
 ret
 470:	8082                	ret

0000000000000472 <dup>:
.global dup
dup:
 li a7, SYS_dup
 472:	48a9                	li	a7,10
 ecall
 474:	00000073          	ecall
 ret
 478:	8082                	ret

000000000000047a <getpid>:
.global getpid
getpid:
 li a7, SYS_getpid
 47a:	48ad                	li	a7,11
 ecall
 47c:	00000073          	ecall
 ret
 480:	8082                	ret

0000000000000482 <sbrk>:
.global sbrk
sbrk:
 li a7, SYS_sbrk
 482:	48b1                	li	a7,12
 ecall
 484:	00000073          	ecall
 ret
 488:	8082                	ret

000000000000048a <sleep>:
.global sleep
sleep:
 li a7, SYS_sleep
 48a:	48b5                	li	a7,13
 ecall
 48c:	00000073          	ecall
 ret
 490:	8082                	ret

0000000000000492 <uptime>:
.global uptime
uptime:
 li a7, SYS_uptime
 492:	48b9                	li	a7,14
 ecall
 494:	00000073          	ecall
 ret
 498:	8082                	ret

000000000000049a <spoon>:
.global spoon
spoon:
 li a7, SYS_spoon
 49a:	48d9                	li	a7,22
 ecall
 49c:	00000073          	ecall
 ret
 4a0:	8082                	ret

00000000000004a2 <create_thread>:
.global create_thread
create_thread:
 li a7, SYS_create_thread
 4a2:	48dd                	li	a7,23
 ecall
 4a4:	00000073          	ecall
 ret
 4a8:	8082                	ret

00000000000004aa <join_thread>:
.global join_thread
join_thread:
 li a7, SYS_join_thread
 4aa:	48e1                	li	a7,24
 ecall
 4ac:	00000073          	ecall
 ret
 4b0:	8082                	ret

00000000000004b2 <thread_exit>:
.global thread_exit
thread_exit:
 li a7, SYS_thread_exit
 4b2:	48e5                	li	a7,25
 ecall
 4b4:	00000073          	ecall
 ret
 4b8:	8082                	ret

00000000000004ba <socket>:
.global socket
socket:
 li a7, SYS_socket
 4ba:	48e9                	li	a7,26
 ecall
 4bc:	00000073          	ecall
 ret
 4c0:	8082                	ret

00000000000004c2 <bind>:
.global bind
bind:
 li a7, SYS_bind
 4c2:	48ed                	li	a7,27
 ecall
 4c4:	00000073          	ecall
 ret
 4c8:	8082                	ret

00000000000004ca <accept>:
.global accept
accept:
 li a7, SYS_accept
 4ca:	48f5                	li	a7,29
 ecall
 4cc:	00000073          	ecall
 ret
 4d0:	8082                	ret

00000000000004d2 <listen>:
.global listen
listen:
 li a7, SYS_listen
 4d2:	48f1                	li	a7,28
 ecall
 4d4:	00000073          	ecall
 ret
 4d8:	8082                	ret

00000000000004da <connect>:
.global connect
connect:
 li a7, SYS_connect
 4da:	48f9                	li	a7,30
 ecall
 4dc:	00000073          	ecall
 ret
 4e0:	8082                	ret

00000000000004e2 <send>:
.global send
send:
 li a7, SYS_send
 4e2:	48fd                	li	a7,31
 ecall
 4e4:	00000073          	ecall
 ret
 4e8:	8082                	ret

00000000000004ea <recv>:
.global recv
recv:
 li a7, SYS_recv
 4ea:	02000893          	li	a7,32
 ecall
 4ee:	00000073          	ecall
 ret
 4f2:	8082                	ret

00000000000004f4 <sendto>:
.global sendto
sendto:
 li a7, SYS_sendto
 4f4:	02100893          	li	a7,33
 ecall
 4f8:	00000073          	ecall
 ret
 4fc:	8082                	ret

00000000000004fe <recvfrom>:
.global recvfrom
recvfrom:
 li a7, SYS_recvfrom
 4fe:	02200893          	li	a7,34
 ecall
 502:	00000073          	ecall
 ret
 506:	8082                	ret

0000000000000508 <putc>:

static char digits[] = "0123456789ABCDEF";

static void
putc(int fd, char c)
{
 508:	1101                	addi	sp,sp,-32
 50a:	ec06                	sd	ra,24(sp)
 50c:	e822                	sd	s0,16(sp)
 50e:	1000                	addi	s0,sp,32
 510:	feb407a3          	sb	a1,-17(s0)
  write(fd, &c, 1);
 514:	4605                	li	a2,1
 516:	fef40593          	addi	a1,s0,-17
 51a:	00000097          	auipc	ra,0x0
 51e:	f00080e7          	jalr	-256(ra) # 41a <write>
}
 522:	60e2                	ld	ra,24(sp)
 524:	6442                	ld	s0,16(sp)
 526:	6105                	addi	sp,sp,32
 528:	8082                	ret

000000000000052a <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
 52a:	7139                	addi	sp,sp,-64
 52c:	fc06                	sd	ra,56(sp)
 52e:	f822                	sd	s0,48(sp)
 530:	f426                	sd	s1,40(sp)
 532:	0080                	addi	s0,sp,64
 534:	84aa                	mv	s1,a0
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
  if(sgn && xx < 0){
 536:	c299                	beqz	a3,53c <printint+0x12>
 538:	0805cb63          	bltz	a1,5ce <printint+0xa4>
    neg = 1;
    x = -xx;
  } else {
    x = xx;
 53c:	2581                	sext.w	a1,a1
  neg = 0;
 53e:	4881                	li	a7,0
 540:	fc040693          	addi	a3,s0,-64
  }

  i = 0;
 544:	4701                	li	a4,0
  do{
    buf[i++] = digits[x % base];
 546:	2601                	sext.w	a2,a2
 548:	00000517          	auipc	a0,0x0
 54c:	74050513          	addi	a0,a0,1856 # c88 <digits>
 550:	883a                	mv	a6,a4
 552:	2705                	addiw	a4,a4,1
 554:	02c5f7bb          	remuw	a5,a1,a2
 558:	1782                	slli	a5,a5,0x20
 55a:	9381                	srli	a5,a5,0x20
 55c:	97aa                	add	a5,a5,a0
 55e:	0007c783          	lbu	a5,0(a5)
 562:	00f68023          	sb	a5,0(a3)
  }while((x /= base) != 0);
 566:	0005879b          	sext.w	a5,a1
 56a:	02c5d5bb          	divuw	a1,a1,a2
 56e:	0685                	addi	a3,a3,1
 570:	fec7f0e3          	bgeu	a5,a2,550 <printint+0x26>
  if(neg)
 574:	00088c63          	beqz	a7,58c <printint+0x62>
    buf[i++] = '-';
 578:	fd070793          	addi	a5,a4,-48
 57c:	00878733          	add	a4,a5,s0
 580:	02d00793          	li	a5,45
 584:	fef70823          	sb	a5,-16(a4)
 588:	0028071b          	addiw	a4,a6,2

  while(--i >= 0)
 58c:	02e05c63          	blez	a4,5c4 <printint+0x9a>
 590:	f04a                	sd	s2,32(sp)
 592:	ec4e                	sd	s3,24(sp)
 594:	fc040793          	addi	a5,s0,-64
 598:	00e78933          	add	s2,a5,a4
 59c:	fff78993          	addi	s3,a5,-1
 5a0:	99ba                	add	s3,s3,a4
 5a2:	377d                	addiw	a4,a4,-1
 5a4:	1702                	slli	a4,a4,0x20
 5a6:	9301                	srli	a4,a4,0x20
 5a8:	40e989b3          	sub	s3,s3,a4
    putc(fd, buf[i]);
 5ac:	fff94583          	lbu	a1,-1(s2)
 5b0:	8526                	mv	a0,s1
 5b2:	00000097          	auipc	ra,0x0
 5b6:	f56080e7          	jalr	-170(ra) # 508 <putc>
  while(--i >= 0)
 5ba:	197d                	addi	s2,s2,-1
 5bc:	ff3918e3          	bne	s2,s3,5ac <printint+0x82>
 5c0:	7902                	ld	s2,32(sp)
 5c2:	69e2                	ld	s3,24(sp)
}
 5c4:	70e2                	ld	ra,56(sp)
 5c6:	7442                	ld	s0,48(sp)
 5c8:	74a2                	ld	s1,40(sp)
 5ca:	6121                	addi	sp,sp,64
 5cc:	8082                	ret
    x = -xx;
 5ce:	40b005bb          	negw	a1,a1
    neg = 1;
 5d2:	4885                	li	a7,1
    x = -xx;
 5d4:	b7b5                	j	540 <printint+0x16>

00000000000005d6 <vprintf>:
}

// Print to the given fd. Only understands %d, %x, %p, %s.
void
vprintf(int fd, const char *fmt, va_list ap)
{
 5d6:	715d                	addi	sp,sp,-80
 5d8:	e486                	sd	ra,72(sp)
 5da:	e0a2                	sd	s0,64(sp)
 5dc:	f84a                	sd	s2,48(sp)
 5de:	0880                	addi	s0,sp,80
  char *s;
  int c, i, state;

  state = 0;
  for(i = 0; fmt[i]; i++){
 5e0:	0005c903          	lbu	s2,0(a1)
 5e4:	1a090a63          	beqz	s2,798 <vprintf+0x1c2>
 5e8:	fc26                	sd	s1,56(sp)
 5ea:	f44e                	sd	s3,40(sp)
 5ec:	f052                	sd	s4,32(sp)
 5ee:	ec56                	sd	s5,24(sp)
 5f0:	e85a                	sd	s6,16(sp)
 5f2:	e45e                	sd	s7,8(sp)
 5f4:	8aaa                	mv	s5,a0
 5f6:	8bb2                	mv	s7,a2
 5f8:	00158493          	addi	s1,a1,1
  state = 0;
 5fc:	4981                	li	s3,0
      if(c == '%'){
        state = '%';
      } else {
        putc(fd, c);
      }
    } else if(state == '%'){
 5fe:	02500a13          	li	s4,37
 602:	4b55                	li	s6,21
 604:	a839                	j	622 <vprintf+0x4c>
        putc(fd, c);
 606:	85ca                	mv	a1,s2
 608:	8556                	mv	a0,s5
 60a:	00000097          	auipc	ra,0x0
 60e:	efe080e7          	jalr	-258(ra) # 508 <putc>
 612:	a019                	j	618 <vprintf+0x42>
    } else if(state == '%'){
 614:	01498d63          	beq	s3,s4,62e <vprintf+0x58>
  for(i = 0; fmt[i]; i++){
 618:	0485                	addi	s1,s1,1
 61a:	fff4c903          	lbu	s2,-1(s1)
 61e:	16090763          	beqz	s2,78c <vprintf+0x1b6>
    if(state == 0){
 622:	fe0999e3          	bnez	s3,614 <vprintf+0x3e>
      if(c == '%'){
 626:	ff4910e3          	bne	s2,s4,606 <vprintf+0x30>
        state = '%';
 62a:	89d2                	mv	s3,s4
 62c:	b7f5                	j	618 <vprintf+0x42>
      if(c == 'd'){
 62e:	13490463          	beq	s2,s4,756 <vprintf+0x180>
 632:	f9d9079b          	addiw	a5,s2,-99
 636:	0ff7f793          	zext.b	a5,a5
 63a:	12fb6763          	bltu	s6,a5,768 <vprintf+0x192>
 63e:	f9d9079b          	addiw	a5,s2,-99
 642:	0ff7f713          	zext.b	a4,a5
 646:	12eb6163          	bltu	s6,a4,768 <vprintf+0x192>
 64a:	00271793          	slli	a5,a4,0x2
 64e:	00000717          	auipc	a4,0x0
 652:	5e270713          	addi	a4,a4,1506 # c30 <ithread_join+0xa2>
 656:	97ba                	add	a5,a5,a4
 658:	439c                	lw	a5,0(a5)
 65a:	97ba                	add	a5,a5,a4
 65c:	8782                	jr	a5
        printint(fd, va_arg(ap, int), 10, 1);
 65e:	008b8913          	addi	s2,s7,8
 662:	4685                	li	a3,1
 664:	4629                	li	a2,10
 666:	000ba583          	lw	a1,0(s7)
 66a:	8556                	mv	a0,s5
 66c:	00000097          	auipc	ra,0x0
 670:	ebe080e7          	jalr	-322(ra) # 52a <printint>
 674:	8bca                	mv	s7,s2
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
        putc(fd, c);
      }
      state = 0;
 676:	4981                	li	s3,0
 678:	b745                	j	618 <vprintf+0x42>
        printint(fd, va_arg(ap, uint64), 10, 0);
 67a:	008b8913          	addi	s2,s7,8
 67e:	4681                	li	a3,0
 680:	4629                	li	a2,10
 682:	000ba583          	lw	a1,0(s7)
 686:	8556                	mv	a0,s5
 688:	00000097          	auipc	ra,0x0
 68c:	ea2080e7          	jalr	-350(ra) # 52a <printint>
 690:	8bca                	mv	s7,s2
      state = 0;
 692:	4981                	li	s3,0
 694:	b751                	j	618 <vprintf+0x42>
        printint(fd, va_arg(ap, int), 16, 0);
 696:	008b8913          	addi	s2,s7,8
 69a:	4681                	li	a3,0
 69c:	4641                	li	a2,16
 69e:	000ba583          	lw	a1,0(s7)
 6a2:	8556                	mv	a0,s5
 6a4:	00000097          	auipc	ra,0x0
 6a8:	e86080e7          	jalr	-378(ra) # 52a <printint>
 6ac:	8bca                	mv	s7,s2
      state = 0;
 6ae:	4981                	li	s3,0
 6b0:	b7a5                	j	618 <vprintf+0x42>
 6b2:	e062                	sd	s8,0(sp)
        printptr(fd, va_arg(ap, uint64));
 6b4:	008b8c13          	addi	s8,s7,8
 6b8:	000bb983          	ld	s3,0(s7)
  putc(fd, '0');
 6bc:	03000593          	li	a1,48
 6c0:	8556                	mv	a0,s5
 6c2:	00000097          	auipc	ra,0x0
 6c6:	e46080e7          	jalr	-442(ra) # 508 <putc>
  putc(fd, 'x');
 6ca:	07800593          	li	a1,120
 6ce:	8556                	mv	a0,s5
 6d0:	00000097          	auipc	ra,0x0
 6d4:	e38080e7          	jalr	-456(ra) # 508 <putc>
 6d8:	4941                	li	s2,16
    putc(fd, digits[x >> (sizeof(uint64) * 8 - 4)]);
 6da:	00000b97          	auipc	s7,0x0
 6de:	5aeb8b93          	addi	s7,s7,1454 # c88 <digits>
 6e2:	03c9d793          	srli	a5,s3,0x3c
 6e6:	97de                	add	a5,a5,s7
 6e8:	0007c583          	lbu	a1,0(a5)
 6ec:	8556                	mv	a0,s5
 6ee:	00000097          	auipc	ra,0x0
 6f2:	e1a080e7          	jalr	-486(ra) # 508 <putc>
  for (i = 0; i < (sizeof(uint64) * 2); i++, x <<= 4)
 6f6:	0992                	slli	s3,s3,0x4
 6f8:	397d                	addiw	s2,s2,-1
 6fa:	fe0914e3          	bnez	s2,6e2 <vprintf+0x10c>
        printptr(fd, va_arg(ap, uint64));
 6fe:	8be2                	mv	s7,s8
      state = 0;
 700:	4981                	li	s3,0
 702:	6c02                	ld	s8,0(sp)
 704:	bf11                	j	618 <vprintf+0x42>
        s = va_arg(ap, char*);
 706:	008b8993          	addi	s3,s7,8
 70a:	000bb903          	ld	s2,0(s7)
        if(s == 0)
 70e:	02090163          	beqz	s2,730 <vprintf+0x15a>
        while(*s != 0){
 712:	00094583          	lbu	a1,0(s2)
 716:	c9a5                	beqz	a1,786 <vprintf+0x1b0>
          putc(fd, *s);
 718:	8556                	mv	a0,s5
 71a:	00000097          	auipc	ra,0x0
 71e:	dee080e7          	jalr	-530(ra) # 508 <putc>
          s++;
 722:	0905                	addi	s2,s2,1
        while(*s != 0){
 724:	00094583          	lbu	a1,0(s2)
 728:	f9e5                	bnez	a1,718 <vprintf+0x142>
        s = va_arg(ap, char*);
 72a:	8bce                	mv	s7,s3
      state = 0;
 72c:	4981                	li	s3,0
 72e:	b5ed                	j	618 <vprintf+0x42>
          s = "(null)";
 730:	00000917          	auipc	s2,0x0
 734:	4c890913          	addi	s2,s2,1224 # bf8 <ithread_join+0x6a>
        while(*s != 0){
 738:	02800593          	li	a1,40
 73c:	bff1                	j	718 <vprintf+0x142>
        putc(fd, va_arg(ap, uint));
 73e:	008b8913          	addi	s2,s7,8
 742:	000bc583          	lbu	a1,0(s7)
 746:	8556                	mv	a0,s5
 748:	00000097          	auipc	ra,0x0
 74c:	dc0080e7          	jalr	-576(ra) # 508 <putc>
 750:	8bca                	mv	s7,s2
      state = 0;
 752:	4981                	li	s3,0
 754:	b5d1                	j	618 <vprintf+0x42>
        putc(fd, c);
 756:	02500593          	li	a1,37
 75a:	8556                	mv	a0,s5
 75c:	00000097          	auipc	ra,0x0
 760:	dac080e7          	jalr	-596(ra) # 508 <putc>
      state = 0;
 764:	4981                	li	s3,0
 766:	bd4d                	j	618 <vprintf+0x42>
        putc(fd, '%');
 768:	02500593          	li	a1,37
 76c:	8556                	mv	a0,s5
 76e:	00000097          	auipc	ra,0x0
 772:	d9a080e7          	jalr	-614(ra) # 508 <putc>
        putc(fd, c);
 776:	85ca                	mv	a1,s2
 778:	8556                	mv	a0,s5
 77a:	00000097          	auipc	ra,0x0
 77e:	d8e080e7          	jalr	-626(ra) # 508 <putc>
      state = 0;
 782:	4981                	li	s3,0
 784:	bd51                	j	618 <vprintf+0x42>
        s = va_arg(ap, char*);
 786:	8bce                	mv	s7,s3
      state = 0;
 788:	4981                	li	s3,0
 78a:	b579                	j	618 <vprintf+0x42>
 78c:	74e2                	ld	s1,56(sp)
 78e:	79a2                	ld	s3,40(sp)
 790:	7a02                	ld	s4,32(sp)
 792:	6ae2                	ld	s5,24(sp)
 794:	6b42                	ld	s6,16(sp)
 796:	6ba2                	ld	s7,8(sp)
    }
  }
}
 798:	60a6                	ld	ra,72(sp)
 79a:	6406                	ld	s0,64(sp)
 79c:	7942                	ld	s2,48(sp)
 79e:	6161                	addi	sp,sp,80
 7a0:	8082                	ret

00000000000007a2 <fprintf>:

void
fprintf(int fd, const char *fmt, ...)
{
 7a2:	715d                	addi	sp,sp,-80
 7a4:	ec06                	sd	ra,24(sp)
 7a6:	e822                	sd	s0,16(sp)
 7a8:	1000                	addi	s0,sp,32
 7aa:	e010                	sd	a2,0(s0)
 7ac:	e414                	sd	a3,8(s0)
 7ae:	e818                	sd	a4,16(s0)
 7b0:	ec1c                	sd	a5,24(s0)
 7b2:	03043023          	sd	a6,32(s0)
 7b6:	03143423          	sd	a7,40(s0)
  va_list ap;

  va_start(ap, fmt);
 7ba:	fe843423          	sd	s0,-24(s0)
  vprintf(fd, fmt, ap);
 7be:	8622                	mv	a2,s0
 7c0:	00000097          	auipc	ra,0x0
 7c4:	e16080e7          	jalr	-490(ra) # 5d6 <vprintf>
}
 7c8:	60e2                	ld	ra,24(sp)
 7ca:	6442                	ld	s0,16(sp)
 7cc:	6161                	addi	sp,sp,80
 7ce:	8082                	ret

00000000000007d0 <printf>:

void
printf(const char *fmt, ...)
{
 7d0:	711d                	addi	sp,sp,-96
 7d2:	ec06                	sd	ra,24(sp)
 7d4:	e822                	sd	s0,16(sp)
 7d6:	1000                	addi	s0,sp,32
 7d8:	e40c                	sd	a1,8(s0)
 7da:	e810                	sd	a2,16(s0)
 7dc:	ec14                	sd	a3,24(s0)
 7de:	f018                	sd	a4,32(s0)
 7e0:	f41c                	sd	a5,40(s0)
 7e2:	03043823          	sd	a6,48(s0)
 7e6:	03143c23          	sd	a7,56(s0)
  va_list ap;

  va_start(ap, fmt);
 7ea:	00840613          	addi	a2,s0,8
 7ee:	fec43423          	sd	a2,-24(s0)
  vprintf(1, fmt, ap);
 7f2:	85aa                	mv	a1,a0
 7f4:	4505                	li	a0,1
 7f6:	00000097          	auipc	ra,0x0
 7fa:	de0080e7          	jalr	-544(ra) # 5d6 <vprintf>
}
 7fe:	60e2                	ld	ra,24(sp)
 800:	6442                	ld	s0,16(sp)
 802:	6125                	addi	sp,sp,96
 804:	8082                	ret

0000000000000806 <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 806:	1141                	addi	sp,sp,-16
 808:	e422                	sd	s0,8(sp)
 80a:	0800                	addi	s0,sp,16
  Header *bp, *p;

  bp = (Header*)ap - 1;
 80c:	ff050693          	addi	a3,a0,-16
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 810:	00001797          	auipc	a5,0x1
 814:	8007b783          	ld	a5,-2048(a5) # 1010 <freep>
 818:	a02d                	j	842 <free+0x3c>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
      break;
  if(bp + bp->s.size == p->s.ptr){
    bp->s.size += p->s.ptr->s.size;
 81a:	4618                	lw	a4,8(a2)
 81c:	9f2d                	addw	a4,a4,a1
 81e:	fee52c23          	sw	a4,-8(a0)
    bp->s.ptr = p->s.ptr->s.ptr;
 822:	6398                	ld	a4,0(a5)
 824:	6310                	ld	a2,0(a4)
 826:	a83d                	j	864 <free+0x5e>
  } else
    bp->s.ptr = p->s.ptr;
  if(p + p->s.size == bp){
    p->s.size += bp->s.size;
 828:	ff852703          	lw	a4,-8(a0)
 82c:	9f31                	addw	a4,a4,a2
 82e:	c798                	sw	a4,8(a5)
    p->s.ptr = bp->s.ptr;
 830:	ff053683          	ld	a3,-16(a0)
 834:	a091                	j	878 <free+0x72>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 836:	6398                	ld	a4,0(a5)
 838:	00e7e463          	bltu	a5,a4,840 <free+0x3a>
 83c:	00e6ea63          	bltu	a3,a4,850 <free+0x4a>
{
 840:	87ba                	mv	a5,a4
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 842:	fed7fae3          	bgeu	a5,a3,836 <free+0x30>
 846:	6398                	ld	a4,0(a5)
 848:	00e6e463          	bltu	a3,a4,850 <free+0x4a>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 84c:	fee7eae3          	bltu	a5,a4,840 <free+0x3a>
  if(bp + bp->s.size == p->s.ptr){
 850:	ff852583          	lw	a1,-8(a0)
 854:	6390                	ld	a2,0(a5)
 856:	02059813          	slli	a6,a1,0x20
 85a:	01c85713          	srli	a4,a6,0x1c
 85e:	9736                	add	a4,a4,a3
 860:	fae60de3          	beq	a2,a4,81a <free+0x14>
    bp->s.ptr = p->s.ptr->s.ptr;
 864:	fec53823          	sd	a2,-16(a0)
  if(p + p->s.size == bp){
 868:	4790                	lw	a2,8(a5)
 86a:	02061593          	slli	a1,a2,0x20
 86e:	01c5d713          	srli	a4,a1,0x1c
 872:	973e                	add	a4,a4,a5
 874:	fae68ae3          	beq	a3,a4,828 <free+0x22>
    p->s.ptr = bp->s.ptr;
 878:	e394                	sd	a3,0(a5)
  } else
    p->s.ptr = bp;
  freep = p;
 87a:	00000717          	auipc	a4,0x0
 87e:	78f73b23          	sd	a5,1942(a4) # 1010 <freep>
}
 882:	6422                	ld	s0,8(sp)
 884:	0141                	addi	sp,sp,16
 886:	8082                	ret

0000000000000888 <malloc>:
  return freep;
}

void*
malloc(uint nbytes)
{
 888:	7139                	addi	sp,sp,-64
 88a:	fc06                	sd	ra,56(sp)
 88c:	f822                	sd	s0,48(sp)
 88e:	f426                	sd	s1,40(sp)
 890:	ec4e                	sd	s3,24(sp)
 892:	0080                	addi	s0,sp,64
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 894:	02051493          	slli	s1,a0,0x20
 898:	9081                	srli	s1,s1,0x20
 89a:	04bd                	addi	s1,s1,15
 89c:	8091                	srli	s1,s1,0x4
 89e:	0014899b          	addiw	s3,s1,1
 8a2:	0485                	addi	s1,s1,1
  if((prevp = freep) == 0){
 8a4:	00000517          	auipc	a0,0x0
 8a8:	76c53503          	ld	a0,1900(a0) # 1010 <freep>
 8ac:	c915                	beqz	a0,8e0 <malloc+0x58>
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 8ae:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
 8b0:	4798                	lw	a4,8(a5)
 8b2:	08977e63          	bgeu	a4,s1,94e <malloc+0xc6>
 8b6:	f04a                	sd	s2,32(sp)
 8b8:	e852                	sd	s4,16(sp)
 8ba:	e456                	sd	s5,8(sp)
 8bc:	e05a                	sd	s6,0(sp)
  if(nu < 4096)
 8be:	8a4e                	mv	s4,s3
 8c0:	0009871b          	sext.w	a4,s3
 8c4:	6685                	lui	a3,0x1
 8c6:	00d77363          	bgeu	a4,a3,8cc <malloc+0x44>
 8ca:	6a05                	lui	s4,0x1
 8cc:	000a0b1b          	sext.w	s6,s4
  p = sbrk(nu * sizeof(Header));
 8d0:	004a1a1b          	slliw	s4,s4,0x4
        p->s.size = nunits;
      }
      freep = prevp;
      return (void*)(p + 1);
    }
    if(p == freep)
 8d4:	00000917          	auipc	s2,0x0
 8d8:	73c90913          	addi	s2,s2,1852 # 1010 <freep>
  if(p == (char*)-1)
 8dc:	5afd                	li	s5,-1
 8de:	a091                	j	922 <malloc+0x9a>
 8e0:	f04a                	sd	s2,32(sp)
 8e2:	e852                	sd	s4,16(sp)
 8e4:	e456                	sd	s5,8(sp)
 8e6:	e05a                	sd	s6,0(sp)
    base.s.ptr = freep = prevp = &base;
 8e8:	00000797          	auipc	a5,0x0
 8ec:	74878793          	addi	a5,a5,1864 # 1030 <base>
 8f0:	00000717          	auipc	a4,0x0
 8f4:	72f73023          	sd	a5,1824(a4) # 1010 <freep>
 8f8:	e39c                	sd	a5,0(a5)
    base.s.size = 0;
 8fa:	0007a423          	sw	zero,8(a5)
    if(p->s.size >= nunits){
 8fe:	b7c1                	j	8be <malloc+0x36>
        prevp->s.ptr = p->s.ptr;
 900:	6398                	ld	a4,0(a5)
 902:	e118                	sd	a4,0(a0)
 904:	a08d                	j	966 <malloc+0xde>
  hp->s.size = nu;
 906:	01652423          	sw	s6,8(a0)
  free((void*)(hp + 1));
 90a:	0541                	addi	a0,a0,16
 90c:	00000097          	auipc	ra,0x0
 910:	efa080e7          	jalr	-262(ra) # 806 <free>
  return freep;
 914:	00093503          	ld	a0,0(s2)
      if((p = morecore(nunits)) == 0)
 918:	c13d                	beqz	a0,97e <malloc+0xf6>
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 91a:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
 91c:	4798                	lw	a4,8(a5)
 91e:	02977463          	bgeu	a4,s1,946 <malloc+0xbe>
    if(p == freep)
 922:	00093703          	ld	a4,0(s2)
 926:	853e                	mv	a0,a5
 928:	fef719e3          	bne	a4,a5,91a <malloc+0x92>
  p = sbrk(nu * sizeof(Header));
 92c:	8552                	mv	a0,s4
 92e:	00000097          	auipc	ra,0x0
 932:	b54080e7          	jalr	-1196(ra) # 482 <sbrk>
  if(p == (char*)-1)
 936:	fd5518e3          	bne	a0,s5,906 <malloc+0x7e>
        return 0;
 93a:	4501                	li	a0,0
 93c:	7902                	ld	s2,32(sp)
 93e:	6a42                	ld	s4,16(sp)
 940:	6aa2                	ld	s5,8(sp)
 942:	6b02                	ld	s6,0(sp)
 944:	a03d                	j	972 <malloc+0xea>
 946:	7902                	ld	s2,32(sp)
 948:	6a42                	ld	s4,16(sp)
 94a:	6aa2                	ld	s5,8(sp)
 94c:	6b02                	ld	s6,0(sp)
      if(p->s.size == nunits)
 94e:	fae489e3          	beq	s1,a4,900 <malloc+0x78>
        p->s.size -= nunits;
 952:	4137073b          	subw	a4,a4,s3
 956:	c798                	sw	a4,8(a5)
        p += p->s.size;
 958:	02071693          	slli	a3,a4,0x20
 95c:	01c6d713          	srli	a4,a3,0x1c
 960:	97ba                	add	a5,a5,a4
        p->s.size = nunits;
 962:	0137a423          	sw	s3,8(a5)
      freep = prevp;
 966:	00000717          	auipc	a4,0x0
 96a:	6aa73523          	sd	a0,1706(a4) # 1010 <freep>
      return (void*)(p + 1);
 96e:	01078513          	addi	a0,a5,16
  }
}
 972:	70e2                	ld	ra,56(sp)
 974:	7442                	ld	s0,48(sp)
 976:	74a2                	ld	s1,40(sp)
 978:	69e2                	ld	s3,24(sp)
 97a:	6121                	addi	sp,sp,64
 97c:	8082                	ret
 97e:	7902                	ld	s2,32(sp)
 980:	6a42                	ld	s4,16(sp)
 982:	6aa2                	ld	s5,8(sp)
 984:	6b02                	ld	s6,0(sp)
 986:	b7f5                	j	972 <malloc+0xea>

0000000000000988 <ithread_exit>:
  free(stacks);
  stacks = new_stacks;
  return 0;
}

void ithread_exit(uint64 status) {
 988:	1141                	addi	sp,sp,-16
 98a:	e406                	sd	ra,8(sp)
 98c:	e022                	sd	s0,0(sp)
 98e:	0800                	addi	s0,sp,16
  thread_exit(status);
 990:	2501                	sext.w	a0,a0
 992:	00000097          	auipc	ra,0x0
 996:	b20080e7          	jalr	-1248(ra) # 4b2 <thread_exit>
}
 99a:	60a2                	ld	ra,8(sp)
 99c:	6402                	ld	s0,0(sp)
 99e:	0141                	addi	sp,sp,16
 9a0:	8082                	ret

00000000000009a2 <free_stacks>:
int free_stacks() {
 9a2:	7179                	addi	sp,sp,-48
 9a4:	f406                	sd	ra,40(sp)
 9a6:	f022                	sd	s0,32(sp)
 9a8:	ec26                	sd	s1,24(sp)
 9aa:	1800                	addi	s0,sp,48
  for (int i = 0; i < num_threads; i++) {
 9ac:	00000797          	auipc	a5,0x0
 9b0:	6747a783          	lw	a5,1652(a5) # 1020 <num_threads>
 9b4:	04f05063          	blez	a5,9f4 <free_stacks+0x52>
 9b8:	e84a                	sd	s2,16(sp)
 9ba:	e44e                	sd	s3,8(sp)
 9bc:	4481                	li	s1,0
    free(stacks[i]);
 9be:	00000997          	auipc	s3,0x0
 9c2:	65a98993          	addi	s3,s3,1626 # 1018 <stacks>
  for (int i = 0; i < num_threads; i++) {
 9c6:	00000917          	auipc	s2,0x0
 9ca:	65a90913          	addi	s2,s2,1626 # 1020 <num_threads>
    free(stacks[i]);
 9ce:	0009b783          	ld	a5,0(s3)
 9d2:	00349713          	slli	a4,s1,0x3
 9d6:	97ba                	add	a5,a5,a4
 9d8:	6388                	ld	a0,0(a5)
 9da:	00000097          	auipc	ra,0x0
 9de:	e2c080e7          	jalr	-468(ra) # 806 <free>
  for (int i = 0; i < num_threads; i++) {
 9e2:	0485                	addi	s1,s1,1
 9e4:	00092703          	lw	a4,0(s2)
 9e8:	0004879b          	sext.w	a5,s1
 9ec:	fee7c1e3          	blt	a5,a4,9ce <free_stacks+0x2c>
 9f0:	6942                	ld	s2,16(sp)
 9f2:	69a2                	ld	s3,8(sp)
  free(stacks);
 9f4:	00000497          	auipc	s1,0x0
 9f8:	62448493          	addi	s1,s1,1572 # 1018 <stacks>
 9fc:	6088                	ld	a0,0(s1)
 9fe:	00000097          	auipc	ra,0x0
 a02:	e08080e7          	jalr	-504(ra) # 806 <free>
  stacks = 0;
 a06:	0004b023          	sd	zero,0(s1)
  num_threads = 0;
 a0a:	00000797          	auipc	a5,0x0
 a0e:	6007ab23          	sw	zero,1558(a5) # 1020 <num_threads>
  max_stacks = INIT_MAX_STACKS;
 a12:	47a1                	li	a5,8
 a14:	00000717          	auipc	a4,0x0
 a18:	5ef72623          	sw	a5,1516(a4) # 1000 <max_stacks>
  threads_done = 0;
 a1c:	00000797          	auipc	a5,0x0
 a20:	6007a423          	sw	zero,1544(a5) # 1024 <threads_done>
}
 a24:	4501                	li	a0,0
 a26:	70a2                	ld	ra,40(sp)
 a28:	7402                	ld	s0,32(sp)
 a2a:	64e2                	ld	s1,24(sp)
 a2c:	6145                	addi	sp,sp,48
 a2e:	8082                	ret

0000000000000a30 <expand_num_threads>:
int expand_num_threads() {
 a30:	1101                	addi	sp,sp,-32
 a32:	ec06                	sd	ra,24(sp)
 a34:	e822                	sd	s0,16(sp)
 a36:	e426                	sd	s1,8(sp)
 a38:	e04a                	sd	s2,0(sp)
 a3a:	1000                	addi	s0,sp,32
  max_stacks *= 2;
 a3c:	00000797          	auipc	a5,0x0
 a40:	5c478793          	addi	a5,a5,1476 # 1000 <max_stacks>
 a44:	4388                	lw	a0,0(a5)
 a46:	0015151b          	slliw	a0,a0,0x1
 a4a:	c388                	sw	a0,0(a5)
  void **new_stacks = malloc(max_stacks*sizeof(char*));
 a4c:	0035151b          	slliw	a0,a0,0x3
 a50:	00000097          	auipc	ra,0x0
 a54:	e38080e7          	jalr	-456(ra) # 888 <malloc>
 a58:	892a                	mv	s2,a0
  memmove(new_stacks, stacks, num_threads*sizeof(char*));
 a5a:	00000617          	auipc	a2,0x0
 a5e:	5c662603          	lw	a2,1478(a2) # 1020 <num_threads>
 a62:	00000497          	auipc	s1,0x0
 a66:	5b648493          	addi	s1,s1,1462 # 1018 <stacks>
 a6a:	0036161b          	slliw	a2,a2,0x3
 a6e:	608c                	ld	a1,0(s1)
 a70:	00000097          	auipc	ra,0x0
 a74:	840080e7          	jalr	-1984(ra) # 2b0 <memmove>
  free(stacks);
 a78:	6088                	ld	a0,0(s1)
 a7a:	00000097          	auipc	ra,0x0
 a7e:	d8c080e7          	jalr	-628(ra) # 806 <free>
  stacks = new_stacks;
 a82:	0124b023          	sd	s2,0(s1)
}
 a86:	4501                	li	a0,0
 a88:	60e2                	ld	ra,24(sp)
 a8a:	6442                	ld	s0,16(sp)
 a8c:	64a2                	ld	s1,8(sp)
 a8e:	6902                	ld	s2,0(sp)
 a90:	6105                	addi	sp,sp,32
 a92:	8082                	ret

0000000000000a94 <ithread_create>:

int ithread_create(void* (*fn_ptr)(void *), void *args) {
 a94:	7179                	addi	sp,sp,-48
 a96:	f406                	sd	ra,40(sp)
 a98:	f022                	sd	s0,32(sp)
 a9a:	e84a                	sd	s2,16(sp)
 a9c:	e44e                	sd	s3,8(sp)
 a9e:	1800                	addi	s0,sp,48
 aa0:	892a                	mv	s2,a0
 aa2:	89ae                	mv	s3,a1
  if (stacks == 0) {
 aa4:	00000797          	auipc	a5,0x0
 aa8:	5747b783          	ld	a5,1396(a5) # 1018 <stacks>
 aac:	c3d9                	beqz	a5,b32 <ithread_create+0x9e>
    stacks = malloc(max_stacks*sizeof(char*));
  }
  if (num_threads == max_stacks) {
 aae:	00000797          	auipc	a5,0x0
 ab2:	5527a783          	lw	a5,1362(a5) # 1000 <max_stacks>
 ab6:	00000717          	auipc	a4,0x0
 aba:	56a72703          	lw	a4,1386(a4) # 1020 <num_threads>
 abe:	0af71363          	bne	a4,a5,b64 <ithread_create+0xd0>
    if (max_stacks == MAX_THREADS) {
 ac2:	04000713          	li	a4,64
 ac6:	08e78563          	beq	a5,a4,b50 <ithread_create+0xbc>
 aca:	ec26                	sd	s1,24(sp)
      printf("ERROR: Thread capacity has been reached\n");
      return -1;
    }
    expand_num_threads();
 acc:	00000097          	auipc	ra,0x0
 ad0:	f64080e7          	jalr	-156(ra) # a30 <expand_num_threads>
  }

  void *stack_ptr = malloc(PGSIZE);
 ad4:	6505                	lui	a0,0x1
 ad6:	00000097          	auipc	ra,0x0
 ada:	db2080e7          	jalr	-590(ra) # 888 <malloc>
 ade:	84aa                	mv	s1,a0
  stacks[num_threads] = stack_ptr;
 ae0:	00000717          	auipc	a4,0x0
 ae4:	54072703          	lw	a4,1344(a4) # 1020 <num_threads>
 ae8:	070e                	slli	a4,a4,0x3
 aea:	00000797          	auipc	a5,0x0
 aee:	52e7b783          	ld	a5,1326(a5) # 1018 <stacks>
 af2:	97ba                	add	a5,a5,a4
 af4:	e388                	sd	a0,0(a5)
  int res = create_thread(fn_ptr, args, stack_ptr, &ithread_exit);
 af6:	00000697          	auipc	a3,0x0
 afa:	e9268693          	addi	a3,a3,-366 # 988 <ithread_exit>
 afe:	862a                	mv	a2,a0
 b00:	85ce                	mv	a1,s3
 b02:	854a                	mv	a0,s2
 b04:	00000097          	auipc	ra,0x0
 b08:	99e080e7          	jalr	-1634(ra) # 4a2 <create_thread>
 b0c:	892a                	mv	s2,a0
  if (res != -1) {
 b0e:	57fd                	li	a5,-1
 b10:	04f50c63          	beq	a0,a5,b68 <ithread_create+0xd4>
    num_threads++;
 b14:	00000717          	auipc	a4,0x0
 b18:	50c70713          	addi	a4,a4,1292 # 1020 <num_threads>
 b1c:	431c                	lw	a5,0(a4)
 b1e:	2785                	addiw	a5,a5,1
 b20:	c31c                	sw	a5,0(a4)
 b22:	64e2                	ld	s1,24(sp)
  } else {
    free(stack_ptr);
    stacks[num_threads] = 0;
  }
  return res;
}
 b24:	854a                	mv	a0,s2
 b26:	70a2                	ld	ra,40(sp)
 b28:	7402                	ld	s0,32(sp)
 b2a:	6942                	ld	s2,16(sp)
 b2c:	69a2                	ld	s3,8(sp)
 b2e:	6145                	addi	sp,sp,48
 b30:	8082                	ret
    stacks = malloc(max_stacks*sizeof(char*));
 b32:	00000517          	auipc	a0,0x0
 b36:	4ce52503          	lw	a0,1230(a0) # 1000 <max_stacks>
 b3a:	0035151b          	slliw	a0,a0,0x3
 b3e:	00000097          	auipc	ra,0x0
 b42:	d4a080e7          	jalr	-694(ra) # 888 <malloc>
 b46:	00000797          	auipc	a5,0x0
 b4a:	4ca7b923          	sd	a0,1234(a5) # 1018 <stacks>
 b4e:	b785                	j	aae <ithread_create+0x1a>
      printf("ERROR: Thread capacity has been reached\n");
 b50:	00000517          	auipc	a0,0x0
 b54:	0b050513          	addi	a0,a0,176 # c00 <ithread_join+0x72>
 b58:	00000097          	auipc	ra,0x0
 b5c:	c78080e7          	jalr	-904(ra) # 7d0 <printf>
      return -1;
 b60:	597d                	li	s2,-1
 b62:	b7c9                	j	b24 <ithread_create+0x90>
 b64:	ec26                	sd	s1,24(sp)
 b66:	b7bd                	j	ad4 <ithread_create+0x40>
    free(stack_ptr);
 b68:	8526                	mv	a0,s1
 b6a:	00000097          	auipc	ra,0x0
 b6e:	c9c080e7          	jalr	-868(ra) # 806 <free>
    stacks[num_threads] = 0;
 b72:	00000717          	auipc	a4,0x0
 b76:	4ae72703          	lw	a4,1198(a4) # 1020 <num_threads>
 b7a:	070e                	slli	a4,a4,0x3
 b7c:	00000797          	auipc	a5,0x0
 b80:	49c7b783          	ld	a5,1180(a5) # 1018 <stacks>
 b84:	97ba                	add	a5,a5,a4
 b86:	0007b023          	sd	zero,0(a5)
 b8a:	64e2                	ld	s1,24(sp)
 b8c:	bf61                	j	b24 <ithread_create+0x90>

0000000000000b8e <ithread_join>:

int ithread_join(int thread_id) {
 b8e:	1101                	addi	sp,sp,-32
 b90:	ec06                	sd	ra,24(sp)
 b92:	e822                	sd	s0,16(sp)
 b94:	1000                	addi	s0,sp,32
  int status;
  join_thread(thread_id, (uint64)&status);
 b96:	ff040793          	addi	a5,s0,-16
 b9a:	ffc7859b          	addiw	a1,a5,-4
 b9e:	00000097          	auipc	ra,0x0
 ba2:	90c080e7          	jalr	-1780(ra) # 4aa <join_thread>
  threads_done++;
 ba6:	00000717          	auipc	a4,0x0
 baa:	47e70713          	addi	a4,a4,1150 # 1024 <threads_done>
 bae:	431c                	lw	a5,0(a4)
 bb0:	2785                	addiw	a5,a5,1
 bb2:	0007869b          	sext.w	a3,a5
 bb6:	c31c                	sw	a5,0(a4)
  if (threads_done == num_threads) {
 bb8:	00000797          	auipc	a5,0x0
 bbc:	4687a783          	lw	a5,1128(a5) # 1020 <num_threads>
 bc0:	00d78863          	beq	a5,a3,bd0 <ithread_join+0x42>
    free_stacks();
  }
  return status;
}
 bc4:	fec42503          	lw	a0,-20(s0)
 bc8:	60e2                	ld	ra,24(sp)
 bca:	6442                	ld	s0,16(sp)
 bcc:	6105                	addi	sp,sp,32
 bce:	8082                	ret
    free_stacks();
 bd0:	00000097          	auipc	ra,0x0
 bd4:	dd2080e7          	jalr	-558(ra) # 9a2 <free_stacks>
 bd8:	b7f5                	j	bc4 <ithread_join+0x36>
