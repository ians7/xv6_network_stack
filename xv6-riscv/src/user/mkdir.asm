
src/user/_mkdir:     file format elf64-littleriscv


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
   a:	02a7d963          	bge	a5,a0,3c <main+0x3c>
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
  2c:	44c080e7          	jalr	1100(ra) # 474 <mkdir>
  30:	02054663          	bltz	a0,5c <main+0x5c>
  for(i = 1; i < argc; i++){
  34:	04a1                	addi	s1,s1,8
  36:	ff2498e3          	bne	s1,s2,26 <main+0x26>
  3a:	a81d                	j	70 <main+0x70>
  3c:	e426                	sd	s1,8(sp)
  3e:	e04a                	sd	s2,0(sp)
    fprintf(2, "Usage: mkdir files...\n");
  40:	00001597          	auipc	a1,0x1
  44:	bb058593          	addi	a1,a1,-1104 # bf0 <ithread_join+0x50>
  48:	4509                	li	a0,2
  4a:	00000097          	auipc	ra,0x0
  4e:	76a080e7          	jalr	1898(ra) # 7b4 <fprintf>
    exit(1);
  52:	4505                	li	a0,1
  54:	00000097          	auipc	ra,0x0
  58:	3b8080e7          	jalr	952(ra) # 40c <exit>
      fprintf(2, "mkdir: %s failed to create\n", argv[i]);
  5c:	6090                	ld	a2,0(s1)
  5e:	00001597          	auipc	a1,0x1
  62:	baa58593          	addi	a1,a1,-1110 # c08 <ithread_join+0x68>
  66:	4509                	li	a0,2
  68:	00000097          	auipc	ra,0x0
  6c:	74c080e7          	jalr	1868(ra) # 7b4 <fprintf>
      break;
    }
  }

  exit(0);
  70:	4501                	li	a0,0
  72:	00000097          	auipc	ra,0x0
  76:	39a080e7          	jalr	922(ra) # 40c <exit>

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
  90:	380080e7          	jalr	896(ra) # 40c <exit>

0000000000000094 <strcpy>:
}

char*
strcpy(char *s, const char *t)
{
  94:	1141                	addi	sp,sp,-16
  96:	e422                	sd	s0,8(sp)
  98:	0800                	addi	s0,sp,16
  char *os;

  os = s;
  while((*s++ = *t++) != 0)
  9a:	87aa                	mv	a5,a0
  9c:	0585                	addi	a1,a1,1
  9e:	0785                	addi	a5,a5,1
  a0:	fff5c703          	lbu	a4,-1(a1)
  a4:	fee78fa3          	sb	a4,-1(a5)
  a8:	fb75                	bnez	a4,9c <strcpy+0x8>
    ;
  return os;
}
  aa:	6422                	ld	s0,8(sp)
  ac:	0141                	addi	sp,sp,16
  ae:	8082                	ret

00000000000000b0 <strcmp>:

int
strcmp(const char *p, const char *q)
{
  b0:	1141                	addi	sp,sp,-16
  b2:	e422                	sd	s0,8(sp)
  b4:	0800                	addi	s0,sp,16
  while(*p && *p == *q)
  b6:	00054783          	lbu	a5,0(a0)
  ba:	cb91                	beqz	a5,ce <strcmp+0x1e>
  bc:	0005c703          	lbu	a4,0(a1)
  c0:	00f71763          	bne	a4,a5,ce <strcmp+0x1e>
    p++, q++;
  c4:	0505                	addi	a0,a0,1
  c6:	0585                	addi	a1,a1,1
  while(*p && *p == *q)
  c8:	00054783          	lbu	a5,0(a0)
  cc:	fbe5                	bnez	a5,bc <strcmp+0xc>
  return (uchar)*p - (uchar)*q;
  ce:	0005c503          	lbu	a0,0(a1)
}
  d2:	40a7853b          	subw	a0,a5,a0
  d6:	6422                	ld	s0,8(sp)
  d8:	0141                	addi	sp,sp,16
  da:	8082                	ret

00000000000000dc <strlen>:

uint
strlen(const char *s)
{
  dc:	1141                	addi	sp,sp,-16
  de:	e422                	sd	s0,8(sp)
  e0:	0800                	addi	s0,sp,16
  int n;

  for(n = 0; s[n]; n++)
  e2:	00054783          	lbu	a5,0(a0)
  e6:	cf91                	beqz	a5,102 <strlen+0x26>
  e8:	0505                	addi	a0,a0,1
  ea:	87aa                	mv	a5,a0
  ec:	86be                	mv	a3,a5
  ee:	0785                	addi	a5,a5,1
  f0:	fff7c703          	lbu	a4,-1(a5)
  f4:	ff65                	bnez	a4,ec <strlen+0x10>
  f6:	40a6853b          	subw	a0,a3,a0
  fa:	2505                	addiw	a0,a0,1
    ;
  return n;
}
  fc:	6422                	ld	s0,8(sp)
  fe:	0141                	addi	sp,sp,16
 100:	8082                	ret
  for(n = 0; s[n]; n++)
 102:	4501                	li	a0,0
 104:	bfe5                	j	fc <strlen+0x20>

0000000000000106 <memset>:

void*
memset(void *dst, int c, uint n)
{
 106:	1141                	addi	sp,sp,-16
 108:	e422                	sd	s0,8(sp)
 10a:	0800                	addi	s0,sp,16
  char *cdst = (char *) dst;
  int i;
  for(i = 0; i < n; i++){
 10c:	ca19                	beqz	a2,122 <memset+0x1c>
 10e:	87aa                	mv	a5,a0
 110:	1602                	slli	a2,a2,0x20
 112:	9201                	srli	a2,a2,0x20
 114:	00a60733          	add	a4,a2,a0
    cdst[i] = c;
 118:	00b78023          	sb	a1,0(a5)
  for(i = 0; i < n; i++){
 11c:	0785                	addi	a5,a5,1
 11e:	fee79de3          	bne	a5,a4,118 <memset+0x12>
  }
  return dst;
}
 122:	6422                	ld	s0,8(sp)
 124:	0141                	addi	sp,sp,16
 126:	8082                	ret

0000000000000128 <strchr>:

char*
strchr(const char *s, char c)
{
 128:	1141                	addi	sp,sp,-16
 12a:	e422                	sd	s0,8(sp)
 12c:	0800                	addi	s0,sp,16
  for(; *s; s++)
 12e:	00054783          	lbu	a5,0(a0)
 132:	cb99                	beqz	a5,148 <strchr+0x20>
    if(*s == c)
 134:	00f58763          	beq	a1,a5,142 <strchr+0x1a>
  for(; *s; s++)
 138:	0505                	addi	a0,a0,1
 13a:	00054783          	lbu	a5,0(a0)
 13e:	fbfd                	bnez	a5,134 <strchr+0xc>
      return (char*)s;
  return 0;
 140:	4501                	li	a0,0
}
 142:	6422                	ld	s0,8(sp)
 144:	0141                	addi	sp,sp,16
 146:	8082                	ret
  return 0;
 148:	4501                	li	a0,0
 14a:	bfe5                	j	142 <strchr+0x1a>

000000000000014c <gets>:

char*
gets(char *buf, int max)
{
 14c:	711d                	addi	sp,sp,-96
 14e:	ec86                	sd	ra,88(sp)
 150:	e8a2                	sd	s0,80(sp)
 152:	e4a6                	sd	s1,72(sp)
 154:	e0ca                	sd	s2,64(sp)
 156:	fc4e                	sd	s3,56(sp)
 158:	f852                	sd	s4,48(sp)
 15a:	f456                	sd	s5,40(sp)
 15c:	f05a                	sd	s6,32(sp)
 15e:	ec5e                	sd	s7,24(sp)
 160:	1080                	addi	s0,sp,96
 162:	8baa                	mv	s7,a0
 164:	8a2e                	mv	s4,a1
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 166:	892a                	mv	s2,a0
 168:	4481                	li	s1,0
    cc = read(0, &c, 1);
    if(cc < 1)
      break;
    buf[i++] = c;
    if(c == '\n' || c == '\r')
 16a:	4aa9                	li	s5,10
 16c:	4b35                	li	s6,13
  for(i=0; i+1 < max; ){
 16e:	89a6                	mv	s3,s1
 170:	2485                	addiw	s1,s1,1
 172:	0344d863          	bge	s1,s4,1a2 <gets+0x56>
    cc = read(0, &c, 1);
 176:	4605                	li	a2,1
 178:	faf40593          	addi	a1,s0,-81
 17c:	4501                	li	a0,0
 17e:	00000097          	auipc	ra,0x0
 182:	2a6080e7          	jalr	678(ra) # 424 <read>
    if(cc < 1)
 186:	00a05e63          	blez	a0,1a2 <gets+0x56>
    buf[i++] = c;
 18a:	faf44783          	lbu	a5,-81(s0)
 18e:	00f90023          	sb	a5,0(s2)
    if(c == '\n' || c == '\r')
 192:	01578763          	beq	a5,s5,1a0 <gets+0x54>
 196:	0905                	addi	s2,s2,1
 198:	fd679be3          	bne	a5,s6,16e <gets+0x22>
    buf[i++] = c;
 19c:	89a6                	mv	s3,s1
 19e:	a011                	j	1a2 <gets+0x56>
 1a0:	89a6                	mv	s3,s1
      break;
  }
  buf[i] = '\0';
 1a2:	99de                	add	s3,s3,s7
 1a4:	00098023          	sb	zero,0(s3)
  return buf;
}
 1a8:	855e                	mv	a0,s7
 1aa:	60e6                	ld	ra,88(sp)
 1ac:	6446                	ld	s0,80(sp)
 1ae:	64a6                	ld	s1,72(sp)
 1b0:	6906                	ld	s2,64(sp)
 1b2:	79e2                	ld	s3,56(sp)
 1b4:	7a42                	ld	s4,48(sp)
 1b6:	7aa2                	ld	s5,40(sp)
 1b8:	7b02                	ld	s6,32(sp)
 1ba:	6be2                	ld	s7,24(sp)
 1bc:	6125                	addi	sp,sp,96
 1be:	8082                	ret

00000000000001c0 <fgetstdin>:

int
fgetstdin(char *buf, int size) {
 1c0:	711d                	addi	sp,sp,-96
 1c2:	ec86                	sd	ra,88(sp)
 1c4:	e8a2                	sd	s0,80(sp)
 1c6:	e4a6                	sd	s1,72(sp)
 1c8:	e0ca                	sd	s2,64(sp)
 1ca:	fc4e                	sd	s3,56(sp)
 1cc:	f852                	sd	s4,48(sp)
 1ce:	f456                	sd	s5,40(sp)
 1d0:	f05a                	sd	s6,32(sp)
 1d2:	ec5e                	sd	s7,24(sp)
 1d4:	1080                	addi	s0,sp,96
 1d6:	8baa                	mv	s7,a0
 1d8:	89ae                	mv	s3,a1
  int i, cc;
  char c;

  for(i=0; i+1 < size; ){
 1da:	892a                	mv	s2,a0
 1dc:	4481                	li	s1,0
    cc = read(0, &c, 1);
    if(cc < 1)
      break;
    buf[i++] = c;
    if(c == '\n' || c == '\r')
 1de:	4aa9                	li	s5,10
 1e0:	4b35                	li	s6,13
  for(i=0; i+1 < size; ){
 1e2:	8a26                	mv	s4,s1
 1e4:	2485                	addiw	s1,s1,1
 1e6:	0334d863          	bge	s1,s3,216 <fgetstdin+0x56>
    cc = read(0, &c, 1);
 1ea:	4605                	li	a2,1
 1ec:	faf40593          	addi	a1,s0,-81
 1f0:	4501                	li	a0,0
 1f2:	00000097          	auipc	ra,0x0
 1f6:	232080e7          	jalr	562(ra) # 424 <read>
    if(cc < 1)
 1fa:	00a05e63          	blez	a0,216 <fgetstdin+0x56>
    buf[i++] = c;
 1fe:	faf44783          	lbu	a5,-81(s0)
 202:	00f90023          	sb	a5,0(s2)
    if(c == '\n' || c == '\r')
 206:	01578763          	beq	a5,s5,214 <fgetstdin+0x54>
 20a:	0905                	addi	s2,s2,1
 20c:	fd679be3          	bne	a5,s6,1e2 <fgetstdin+0x22>
    buf[i++] = c;
 210:	8a26                	mv	s4,s1
 212:	a011                	j	216 <fgetstdin+0x56>
 214:	8a26                	mv	s4,s1
      break;
  }
  buf[i] = '\0';
 216:	9bd2                	add	s7,s7,s4
 218:	000b8023          	sb	zero,0(s7)
  return i;
}
 21c:	8552                	mv	a0,s4
 21e:	60e6                	ld	ra,88(sp)
 220:	6446                	ld	s0,80(sp)
 222:	64a6                	ld	s1,72(sp)
 224:	6906                	ld	s2,64(sp)
 226:	79e2                	ld	s3,56(sp)
 228:	7a42                	ld	s4,48(sp)
 22a:	7aa2                	ld	s5,40(sp)
 22c:	7b02                	ld	s6,32(sp)
 22e:	6be2                	ld	s7,24(sp)
 230:	6125                	addi	sp,sp,96
 232:	8082                	ret

0000000000000234 <stat>:

int
stat(const char *n, struct stat *st)
{
 234:	1101                	addi	sp,sp,-32
 236:	ec06                	sd	ra,24(sp)
 238:	e822                	sd	s0,16(sp)
 23a:	e04a                	sd	s2,0(sp)
 23c:	1000                	addi	s0,sp,32
 23e:	892e                	mv	s2,a1
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 240:	4581                	li	a1,0
 242:	00000097          	auipc	ra,0x0
 246:	20a080e7          	jalr	522(ra) # 44c <open>
  if(fd < 0)
 24a:	02054663          	bltz	a0,276 <stat+0x42>
 24e:	e426                	sd	s1,8(sp)
 250:	84aa                	mv	s1,a0
    return -1;
  r = fstat(fd, st);
 252:	85ca                	mv	a1,s2
 254:	00000097          	auipc	ra,0x0
 258:	210080e7          	jalr	528(ra) # 464 <fstat>
 25c:	892a                	mv	s2,a0
  close(fd);
 25e:	8526                	mv	a0,s1
 260:	00000097          	auipc	ra,0x0
 264:	1d4080e7          	jalr	468(ra) # 434 <close>
  return r;
 268:	64a2                	ld	s1,8(sp)
}
 26a:	854a                	mv	a0,s2
 26c:	60e2                	ld	ra,24(sp)
 26e:	6442                	ld	s0,16(sp)
 270:	6902                	ld	s2,0(sp)
 272:	6105                	addi	sp,sp,32
 274:	8082                	ret
    return -1;
 276:	597d                	li	s2,-1
 278:	bfcd                	j	26a <stat+0x36>

000000000000027a <atoi>:

int
atoi(const char *s)
{
 27a:	1141                	addi	sp,sp,-16
 27c:	e422                	sd	s0,8(sp)
 27e:	0800                	addi	s0,sp,16
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
 280:	00054683          	lbu	a3,0(a0)
 284:	fd06879b          	addiw	a5,a3,-48
 288:	0ff7f793          	zext.b	a5,a5
 28c:	4625                	li	a2,9
 28e:	02f66863          	bltu	a2,a5,2be <atoi+0x44>
 292:	872a                	mv	a4,a0
  n = 0;
 294:	4501                	li	a0,0
    n = n*10 + *s++ - '0';
 296:	0705                	addi	a4,a4,1
 298:	0025179b          	slliw	a5,a0,0x2
 29c:	9fa9                	addw	a5,a5,a0
 29e:	0017979b          	slliw	a5,a5,0x1
 2a2:	9fb5                	addw	a5,a5,a3
 2a4:	fd07851b          	addiw	a0,a5,-48
  while('0' <= *s && *s <= '9')
 2a8:	00074683          	lbu	a3,0(a4)
 2ac:	fd06879b          	addiw	a5,a3,-48
 2b0:	0ff7f793          	zext.b	a5,a5
 2b4:	fef671e3          	bgeu	a2,a5,296 <atoi+0x1c>
  return n;
}
 2b8:	6422                	ld	s0,8(sp)
 2ba:	0141                	addi	sp,sp,16
 2bc:	8082                	ret
  n = 0;
 2be:	4501                	li	a0,0
 2c0:	bfe5                	j	2b8 <atoi+0x3e>

00000000000002c2 <memmove>:

void*
memmove(void *vdst, const void *vsrc, int n)
{
 2c2:	1141                	addi	sp,sp,-16
 2c4:	e422                	sd	s0,8(sp)
 2c6:	0800                	addi	s0,sp,16
  char *dst;
  const char *src;

  dst = vdst;
  src = vsrc;
  if (src > dst) {
 2c8:	02b57463          	bgeu	a0,a1,2f0 <memmove+0x2e>
    while(n-- > 0)
 2cc:	00c05f63          	blez	a2,2ea <memmove+0x28>
 2d0:	1602                	slli	a2,a2,0x20
 2d2:	9201                	srli	a2,a2,0x20
 2d4:	00c507b3          	add	a5,a0,a2
  dst = vdst;
 2d8:	872a                	mv	a4,a0
      *dst++ = *src++;
 2da:	0585                	addi	a1,a1,1
 2dc:	0705                	addi	a4,a4,1
 2de:	fff5c683          	lbu	a3,-1(a1)
 2e2:	fed70fa3          	sb	a3,-1(a4)
    while(n-- > 0)
 2e6:	fef71ae3          	bne	a4,a5,2da <memmove+0x18>
    src += n;
    while(n-- > 0)
      *--dst = *--src;
  }
  return vdst;
}
 2ea:	6422                	ld	s0,8(sp)
 2ec:	0141                	addi	sp,sp,16
 2ee:	8082                	ret
    dst += n;
 2f0:	00c50733          	add	a4,a0,a2
    src += n;
 2f4:	95b2                	add	a1,a1,a2
    while(n-- > 0)
 2f6:	fec05ae3          	blez	a2,2ea <memmove+0x28>
 2fa:	fff6079b          	addiw	a5,a2,-1
 2fe:	1782                	slli	a5,a5,0x20
 300:	9381                	srli	a5,a5,0x20
 302:	fff7c793          	not	a5,a5
 306:	97ba                	add	a5,a5,a4
      *--dst = *--src;
 308:	15fd                	addi	a1,a1,-1
 30a:	177d                	addi	a4,a4,-1
 30c:	0005c683          	lbu	a3,0(a1)
 310:	00d70023          	sb	a3,0(a4)
    while(n-- > 0)
 314:	fee79ae3          	bne	a5,a4,308 <memmove+0x46>
 318:	bfc9                	j	2ea <memmove+0x28>

000000000000031a <memcmp>:

int
memcmp(const void *s1, const void *s2, uint n)
{
 31a:	1141                	addi	sp,sp,-16
 31c:	e422                	sd	s0,8(sp)
 31e:	0800                	addi	s0,sp,16
  const char *p1 = s1, *p2 = s2;
  while (n-- > 0) {
 320:	ca05                	beqz	a2,350 <memcmp+0x36>
 322:	fff6069b          	addiw	a3,a2,-1
 326:	1682                	slli	a3,a3,0x20
 328:	9281                	srli	a3,a3,0x20
 32a:	0685                	addi	a3,a3,1
 32c:	96aa                	add	a3,a3,a0
    if (*p1 != *p2) {
 32e:	00054783          	lbu	a5,0(a0)
 332:	0005c703          	lbu	a4,0(a1)
 336:	00e79863          	bne	a5,a4,346 <memcmp+0x2c>
      return *p1 - *p2;
    }
    p1++;
 33a:	0505                	addi	a0,a0,1
    p2++;
 33c:	0585                	addi	a1,a1,1
  while (n-- > 0) {
 33e:	fed518e3          	bne	a0,a3,32e <memcmp+0x14>
  }
  return 0;
 342:	4501                	li	a0,0
 344:	a019                	j	34a <memcmp+0x30>
      return *p1 - *p2;
 346:	40e7853b          	subw	a0,a5,a4
}
 34a:	6422                	ld	s0,8(sp)
 34c:	0141                	addi	sp,sp,16
 34e:	8082                	ret
  return 0;
 350:	4501                	li	a0,0
 352:	bfe5                	j	34a <memcmp+0x30>

0000000000000354 <memcpy>:

void *
memcpy(void *dst, const void *src, uint n)
{
 354:	1141                	addi	sp,sp,-16
 356:	e406                	sd	ra,8(sp)
 358:	e022                	sd	s0,0(sp)
 35a:	0800                	addi	s0,sp,16
  return memmove(dst, src, n);
 35c:	00000097          	auipc	ra,0x0
 360:	f66080e7          	jalr	-154(ra) # 2c2 <memmove>
}
 364:	60a2                	ld	ra,8(sp)
 366:	6402                	ld	s0,0(sp)
 368:	0141                	addi	sp,sp,16
 36a:	8082                	ret

000000000000036c <inet_addr>:

// Parse a dotted-decimal IPv4 string (e.g. "10.10.0.2") and return the
// address as a 32-bit integer in host byte order, or 0 on failure.
uint
inet_addr(const char *s)
{
 36c:	1141                	addi	sp,sp,-16
 36e:	e422                	sd	s0,8(sp)
 370:	0800                	addi	s0,sp,16
  uint result = 0;
  int octet = 0;
  int digits = 0;
  int dots = 0;

  for (; *s; s++) {
 372:	00054783          	lbu	a5,0(a0)
 376:	cfbd                	beqz	a5,3f4 <inet_addr+0x88>
  int dots = 0;
 378:	4801                	li	a6,0
  int digits = 0;
 37a:	4601                	li	a2,0
  int octet = 0;
 37c:	4681                	li	a3,0
  uint result = 0;
 37e:	4581                	li	a1,0
    if (*s >= '0' && *s <= '9') {
 380:	48a5                	li	a7,9
      octet = octet * 10 + (*s - '0');
      digits++;
      if (octet > 255)
        return 0;
    } else if (*s == '.') {
 382:	02e00e93          	li	t4,46
      if (digits == 0 || dots == 3)
 386:	4f0d                	li	t5,3
        return 0;
      result = (result << 8) | (uint)octet;
      octet = 0;
      digits = 0;
 388:	4301                	li	t1,0
      if (octet > 255)
 38a:	0ff00e13          	li	t3,255
 38e:	a015                	j	3b2 <inet_addr+0x46>
    } else if (*s == '.') {
 390:	07d79463          	bne	a5,t4,3f8 <inet_addr+0x8c>
      if (digits == 0 || dots == 3)
 394:	c625                	beqz	a2,3fc <inet_addr+0x90>
 396:	07e80563          	beq	a6,t5,400 <inet_addr+0x94>
      result = (result << 8) | (uint)octet;
 39a:	0085959b          	slliw	a1,a1,0x8
 39e:	8ecd                	or	a3,a3,a1
 3a0:	0006859b          	sext.w	a1,a3
      dots++;
 3a4:	2805                	addiw	a6,a6,1
      digits = 0;
 3a6:	861a                	mv	a2,t1
      octet = 0;
 3a8:	869a                	mv	a3,t1
  for (; *s; s++) {
 3aa:	0505                	addi	a0,a0,1
 3ac:	00054783          	lbu	a5,0(a0)
 3b0:	c79d                	beqz	a5,3de <inet_addr+0x72>
    if (*s >= '0' && *s <= '9') {
 3b2:	fd07871b          	addiw	a4,a5,-48
 3b6:	0ff77713          	zext.b	a4,a4
 3ba:	fce8ebe3          	bltu	a7,a4,390 <inet_addr+0x24>
      octet = octet * 10 + (*s - '0');
 3be:	0026971b          	slliw	a4,a3,0x2
 3c2:	9f35                	addw	a4,a4,a3
 3c4:	0017171b          	slliw	a4,a4,0x1
 3c8:	fd07879b          	addiw	a5,a5,-48
 3cc:	00e786bb          	addw	a3,a5,a4
      digits++;
 3d0:	2605                	addiw	a2,a2,1
      if (octet > 255)
 3d2:	fcde5ce3          	bge	t3,a3,3aa <inet_addr+0x3e>
        return 0;
 3d6:	4501                	li	a0,0
  if (digits == 0 || dots != 3)
    return 0;

  result = (result << 8) | (uint)octet;
  return result;
}
 3d8:	6422                	ld	s0,8(sp)
 3da:	0141                	addi	sp,sp,16
 3dc:	8082                	ret
    return 0;
 3de:	4501                	li	a0,0
  if (digits == 0 || dots != 3)
 3e0:	de65                	beqz	a2,3d8 <inet_addr+0x6c>
 3e2:	478d                	li	a5,3
 3e4:	fef81ae3          	bne	a6,a5,3d8 <inet_addr+0x6c>
  result = (result << 8) | (uint)octet;
 3e8:	0085959b          	slliw	a1,a1,0x8
 3ec:	8ecd                	or	a3,a3,a1
 3ee:	0006851b          	sext.w	a0,a3
  return result;
 3f2:	b7dd                	j	3d8 <inet_addr+0x6c>
    return 0;
 3f4:	4501                	li	a0,0
 3f6:	b7cd                	j	3d8 <inet_addr+0x6c>
      return 0;
 3f8:	4501                	li	a0,0
 3fa:	bff9                	j	3d8 <inet_addr+0x6c>
        return 0;
 3fc:	4501                	li	a0,0
 3fe:	bfe9                	j	3d8 <inet_addr+0x6c>
 400:	4501                	li	a0,0
 402:	bfd9                	j	3d8 <inet_addr+0x6c>

0000000000000404 <fork>:
# generated by usys.pl - do not edit
#include "kernel/syscall.h"
.global fork
fork:
 li a7, SYS_fork
 404:	4885                	li	a7,1
 ecall
 406:	00000073          	ecall
 ret
 40a:	8082                	ret

000000000000040c <exit>:
.global exit
exit:
 li a7, SYS_exit
 40c:	4889                	li	a7,2
 ecall
 40e:	00000073          	ecall
 ret
 412:	8082                	ret

0000000000000414 <wait>:
.global wait
wait:
 li a7, SYS_wait
 414:	488d                	li	a7,3
 ecall
 416:	00000073          	ecall
 ret
 41a:	8082                	ret

000000000000041c <pipe>:
.global pipe
pipe:
 li a7, SYS_pipe
 41c:	4891                	li	a7,4
 ecall
 41e:	00000073          	ecall
 ret
 422:	8082                	ret

0000000000000424 <read>:
.global read
read:
 li a7, SYS_read
 424:	4895                	li	a7,5
 ecall
 426:	00000073          	ecall
 ret
 42a:	8082                	ret

000000000000042c <write>:
.global write
write:
 li a7, SYS_write
 42c:	48c1                	li	a7,16
 ecall
 42e:	00000073          	ecall
 ret
 432:	8082                	ret

0000000000000434 <close>:
.global close
close:
 li a7, SYS_close
 434:	48d5                	li	a7,21
 ecall
 436:	00000073          	ecall
 ret
 43a:	8082                	ret

000000000000043c <kill>:
.global kill
kill:
 li a7, SYS_kill
 43c:	4899                	li	a7,6
 ecall
 43e:	00000073          	ecall
 ret
 442:	8082                	ret

0000000000000444 <exec>:
.global exec
exec:
 li a7, SYS_exec
 444:	489d                	li	a7,7
 ecall
 446:	00000073          	ecall
 ret
 44a:	8082                	ret

000000000000044c <open>:
.global open
open:
 li a7, SYS_open
 44c:	48bd                	li	a7,15
 ecall
 44e:	00000073          	ecall
 ret
 452:	8082                	ret

0000000000000454 <mknod>:
.global mknod
mknod:
 li a7, SYS_mknod
 454:	48c5                	li	a7,17
 ecall
 456:	00000073          	ecall
 ret
 45a:	8082                	ret

000000000000045c <unlink>:
.global unlink
unlink:
 li a7, SYS_unlink
 45c:	48c9                	li	a7,18
 ecall
 45e:	00000073          	ecall
 ret
 462:	8082                	ret

0000000000000464 <fstat>:
.global fstat
fstat:
 li a7, SYS_fstat
 464:	48a1                	li	a7,8
 ecall
 466:	00000073          	ecall
 ret
 46a:	8082                	ret

000000000000046c <link>:
.global link
link:
 li a7, SYS_link
 46c:	48cd                	li	a7,19
 ecall
 46e:	00000073          	ecall
 ret
 472:	8082                	ret

0000000000000474 <mkdir>:
.global mkdir
mkdir:
 li a7, SYS_mkdir
 474:	48d1                	li	a7,20
 ecall
 476:	00000073          	ecall
 ret
 47a:	8082                	ret

000000000000047c <chdir>:
.global chdir
chdir:
 li a7, SYS_chdir
 47c:	48a5                	li	a7,9
 ecall
 47e:	00000073          	ecall
 ret
 482:	8082                	ret

0000000000000484 <dup>:
.global dup
dup:
 li a7, SYS_dup
 484:	48a9                	li	a7,10
 ecall
 486:	00000073          	ecall
 ret
 48a:	8082                	ret

000000000000048c <getpid>:
.global getpid
getpid:
 li a7, SYS_getpid
 48c:	48ad                	li	a7,11
 ecall
 48e:	00000073          	ecall
 ret
 492:	8082                	ret

0000000000000494 <sbrk>:
.global sbrk
sbrk:
 li a7, SYS_sbrk
 494:	48b1                	li	a7,12
 ecall
 496:	00000073          	ecall
 ret
 49a:	8082                	ret

000000000000049c <sleep>:
.global sleep
sleep:
 li a7, SYS_sleep
 49c:	48b5                	li	a7,13
 ecall
 49e:	00000073          	ecall
 ret
 4a2:	8082                	ret

00000000000004a4 <uptime>:
.global uptime
uptime:
 li a7, SYS_uptime
 4a4:	48b9                	li	a7,14
 ecall
 4a6:	00000073          	ecall
 ret
 4aa:	8082                	ret

00000000000004ac <spoon>:
.global spoon
spoon:
 li a7, SYS_spoon
 4ac:	48d9                	li	a7,22
 ecall
 4ae:	00000073          	ecall
 ret
 4b2:	8082                	ret

00000000000004b4 <create_thread>:
.global create_thread
create_thread:
 li a7, SYS_create_thread
 4b4:	48dd                	li	a7,23
 ecall
 4b6:	00000073          	ecall
 ret
 4ba:	8082                	ret

00000000000004bc <join_thread>:
.global join_thread
join_thread:
 li a7, SYS_join_thread
 4bc:	48e1                	li	a7,24
 ecall
 4be:	00000073          	ecall
 ret
 4c2:	8082                	ret

00000000000004c4 <thread_exit>:
.global thread_exit
thread_exit:
 li a7, SYS_thread_exit
 4c4:	48e5                	li	a7,25
 ecall
 4c6:	00000073          	ecall
 ret
 4ca:	8082                	ret

00000000000004cc <socket>:
.global socket
socket:
 li a7, SYS_socket
 4cc:	48e9                	li	a7,26
 ecall
 4ce:	00000073          	ecall
 ret
 4d2:	8082                	ret

00000000000004d4 <bind>:
.global bind
bind:
 li a7, SYS_bind
 4d4:	48ed                	li	a7,27
 ecall
 4d6:	00000073          	ecall
 ret
 4da:	8082                	ret

00000000000004dc <accept>:
.global accept
accept:
 li a7, SYS_accept
 4dc:	48f5                	li	a7,29
 ecall
 4de:	00000073          	ecall
 ret
 4e2:	8082                	ret

00000000000004e4 <listen>:
.global listen
listen:
 li a7, SYS_listen
 4e4:	48f1                	li	a7,28
 ecall
 4e6:	00000073          	ecall
 ret
 4ea:	8082                	ret

00000000000004ec <connect>:
.global connect
connect:
 li a7, SYS_connect
 4ec:	48f9                	li	a7,30
 ecall
 4ee:	00000073          	ecall
 ret
 4f2:	8082                	ret

00000000000004f4 <send>:
.global send
send:
 li a7, SYS_send
 4f4:	48fd                	li	a7,31
 ecall
 4f6:	00000073          	ecall
 ret
 4fa:	8082                	ret

00000000000004fc <recv>:
.global recv
recv:
 li a7, SYS_recv
 4fc:	02000893          	li	a7,32
 ecall
 500:	00000073          	ecall
 ret
 504:	8082                	ret

0000000000000506 <sendto>:
.global sendto
sendto:
 li a7, SYS_sendto
 506:	02100893          	li	a7,33
 ecall
 50a:	00000073          	ecall
 ret
 50e:	8082                	ret

0000000000000510 <recvfrom>:
.global recvfrom
recvfrom:
 li a7, SYS_recvfrom
 510:	02200893          	li	a7,34
 ecall
 514:	00000073          	ecall
 ret
 518:	8082                	ret

000000000000051a <putc>:

static char digits[] = "0123456789ABCDEF";

static void
putc(int fd, char c)
{
 51a:	1101                	addi	sp,sp,-32
 51c:	ec06                	sd	ra,24(sp)
 51e:	e822                	sd	s0,16(sp)
 520:	1000                	addi	s0,sp,32
 522:	feb407a3          	sb	a1,-17(s0)
  write(fd, &c, 1);
 526:	4605                	li	a2,1
 528:	fef40593          	addi	a1,s0,-17
 52c:	00000097          	auipc	ra,0x0
 530:	f00080e7          	jalr	-256(ra) # 42c <write>
}
 534:	60e2                	ld	ra,24(sp)
 536:	6442                	ld	s0,16(sp)
 538:	6105                	addi	sp,sp,32
 53a:	8082                	ret

000000000000053c <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
 53c:	7139                	addi	sp,sp,-64
 53e:	fc06                	sd	ra,56(sp)
 540:	f822                	sd	s0,48(sp)
 542:	f426                	sd	s1,40(sp)
 544:	0080                	addi	s0,sp,64
 546:	84aa                	mv	s1,a0
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
  if(sgn && xx < 0){
 548:	c299                	beqz	a3,54e <printint+0x12>
 54a:	0805cb63          	bltz	a1,5e0 <printint+0xa4>
    neg = 1;
    x = -xx;
  } else {
    x = xx;
 54e:	2581                	sext.w	a1,a1
  neg = 0;
 550:	4881                	li	a7,0
 552:	fc040693          	addi	a3,s0,-64
  }

  i = 0;
 556:	4701                	li	a4,0
  do{
    buf[i++] = digits[x % base];
 558:	2601                	sext.w	a2,a2
 55a:	00000517          	auipc	a0,0x0
 55e:	75e50513          	addi	a0,a0,1886 # cb8 <digits>
 562:	883a                	mv	a6,a4
 564:	2705                	addiw	a4,a4,1
 566:	02c5f7bb          	remuw	a5,a1,a2
 56a:	1782                	slli	a5,a5,0x20
 56c:	9381                	srli	a5,a5,0x20
 56e:	97aa                	add	a5,a5,a0
 570:	0007c783          	lbu	a5,0(a5)
 574:	00f68023          	sb	a5,0(a3)
  }while((x /= base) != 0);
 578:	0005879b          	sext.w	a5,a1
 57c:	02c5d5bb          	divuw	a1,a1,a2
 580:	0685                	addi	a3,a3,1
 582:	fec7f0e3          	bgeu	a5,a2,562 <printint+0x26>
  if(neg)
 586:	00088c63          	beqz	a7,59e <printint+0x62>
    buf[i++] = '-';
 58a:	fd070793          	addi	a5,a4,-48
 58e:	00878733          	add	a4,a5,s0
 592:	02d00793          	li	a5,45
 596:	fef70823          	sb	a5,-16(a4)
 59a:	0028071b          	addiw	a4,a6,2

  while(--i >= 0)
 59e:	02e05c63          	blez	a4,5d6 <printint+0x9a>
 5a2:	f04a                	sd	s2,32(sp)
 5a4:	ec4e                	sd	s3,24(sp)
 5a6:	fc040793          	addi	a5,s0,-64
 5aa:	00e78933          	add	s2,a5,a4
 5ae:	fff78993          	addi	s3,a5,-1
 5b2:	99ba                	add	s3,s3,a4
 5b4:	377d                	addiw	a4,a4,-1
 5b6:	1702                	slli	a4,a4,0x20
 5b8:	9301                	srli	a4,a4,0x20
 5ba:	40e989b3          	sub	s3,s3,a4
    putc(fd, buf[i]);
 5be:	fff94583          	lbu	a1,-1(s2)
 5c2:	8526                	mv	a0,s1
 5c4:	00000097          	auipc	ra,0x0
 5c8:	f56080e7          	jalr	-170(ra) # 51a <putc>
  while(--i >= 0)
 5cc:	197d                	addi	s2,s2,-1
 5ce:	ff3918e3          	bne	s2,s3,5be <printint+0x82>
 5d2:	7902                	ld	s2,32(sp)
 5d4:	69e2                	ld	s3,24(sp)
}
 5d6:	70e2                	ld	ra,56(sp)
 5d8:	7442                	ld	s0,48(sp)
 5da:	74a2                	ld	s1,40(sp)
 5dc:	6121                	addi	sp,sp,64
 5de:	8082                	ret
    x = -xx;
 5e0:	40b005bb          	negw	a1,a1
    neg = 1;
 5e4:	4885                	li	a7,1
    x = -xx;
 5e6:	b7b5                	j	552 <printint+0x16>

00000000000005e8 <vprintf>:
}

// Print to the given fd. Only understands %d, %x, %p, %s.
void
vprintf(int fd, const char *fmt, va_list ap)
{
 5e8:	715d                	addi	sp,sp,-80
 5ea:	e486                	sd	ra,72(sp)
 5ec:	e0a2                	sd	s0,64(sp)
 5ee:	f84a                	sd	s2,48(sp)
 5f0:	0880                	addi	s0,sp,80
  char *s;
  int c, i, state;

  state = 0;
  for(i = 0; fmt[i]; i++){
 5f2:	0005c903          	lbu	s2,0(a1)
 5f6:	1a090a63          	beqz	s2,7aa <vprintf+0x1c2>
 5fa:	fc26                	sd	s1,56(sp)
 5fc:	f44e                	sd	s3,40(sp)
 5fe:	f052                	sd	s4,32(sp)
 600:	ec56                	sd	s5,24(sp)
 602:	e85a                	sd	s6,16(sp)
 604:	e45e                	sd	s7,8(sp)
 606:	8aaa                	mv	s5,a0
 608:	8bb2                	mv	s7,a2
 60a:	00158493          	addi	s1,a1,1
  state = 0;
 60e:	4981                	li	s3,0
      if(c == '%'){
        state = '%';
      } else {
        putc(fd, c);
      }
    } else if(state == '%'){
 610:	02500a13          	li	s4,37
 614:	4b55                	li	s6,21
 616:	a839                	j	634 <vprintf+0x4c>
        putc(fd, c);
 618:	85ca                	mv	a1,s2
 61a:	8556                	mv	a0,s5
 61c:	00000097          	auipc	ra,0x0
 620:	efe080e7          	jalr	-258(ra) # 51a <putc>
 624:	a019                	j	62a <vprintf+0x42>
    } else if(state == '%'){
 626:	01498d63          	beq	s3,s4,640 <vprintf+0x58>
  for(i = 0; fmt[i]; i++){
 62a:	0485                	addi	s1,s1,1
 62c:	fff4c903          	lbu	s2,-1(s1)
 630:	16090763          	beqz	s2,79e <vprintf+0x1b6>
    if(state == 0){
 634:	fe0999e3          	bnez	s3,626 <vprintf+0x3e>
      if(c == '%'){
 638:	ff4910e3          	bne	s2,s4,618 <vprintf+0x30>
        state = '%';
 63c:	89d2                	mv	s3,s4
 63e:	b7f5                	j	62a <vprintf+0x42>
      if(c == 'd'){
 640:	13490463          	beq	s2,s4,768 <vprintf+0x180>
 644:	f9d9079b          	addiw	a5,s2,-99
 648:	0ff7f793          	zext.b	a5,a5
 64c:	12fb6763          	bltu	s6,a5,77a <vprintf+0x192>
 650:	f9d9079b          	addiw	a5,s2,-99
 654:	0ff7f713          	zext.b	a4,a5
 658:	12eb6163          	bltu	s6,a4,77a <vprintf+0x192>
 65c:	00271793          	slli	a5,a4,0x2
 660:	00000717          	auipc	a4,0x0
 664:	60070713          	addi	a4,a4,1536 # c60 <ithread_join+0xc0>
 668:	97ba                	add	a5,a5,a4
 66a:	439c                	lw	a5,0(a5)
 66c:	97ba                	add	a5,a5,a4
 66e:	8782                	jr	a5
        printint(fd, va_arg(ap, int), 10, 1);
 670:	008b8913          	addi	s2,s7,8
 674:	4685                	li	a3,1
 676:	4629                	li	a2,10
 678:	000ba583          	lw	a1,0(s7)
 67c:	8556                	mv	a0,s5
 67e:	00000097          	auipc	ra,0x0
 682:	ebe080e7          	jalr	-322(ra) # 53c <printint>
 686:	8bca                	mv	s7,s2
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
        putc(fd, c);
      }
      state = 0;
 688:	4981                	li	s3,0
 68a:	b745                	j	62a <vprintf+0x42>
        printint(fd, va_arg(ap, uint64), 10, 0);
 68c:	008b8913          	addi	s2,s7,8
 690:	4681                	li	a3,0
 692:	4629                	li	a2,10
 694:	000ba583          	lw	a1,0(s7)
 698:	8556                	mv	a0,s5
 69a:	00000097          	auipc	ra,0x0
 69e:	ea2080e7          	jalr	-350(ra) # 53c <printint>
 6a2:	8bca                	mv	s7,s2
      state = 0;
 6a4:	4981                	li	s3,0
 6a6:	b751                	j	62a <vprintf+0x42>
        printint(fd, va_arg(ap, int), 16, 0);
 6a8:	008b8913          	addi	s2,s7,8
 6ac:	4681                	li	a3,0
 6ae:	4641                	li	a2,16
 6b0:	000ba583          	lw	a1,0(s7)
 6b4:	8556                	mv	a0,s5
 6b6:	00000097          	auipc	ra,0x0
 6ba:	e86080e7          	jalr	-378(ra) # 53c <printint>
 6be:	8bca                	mv	s7,s2
      state = 0;
 6c0:	4981                	li	s3,0
 6c2:	b7a5                	j	62a <vprintf+0x42>
 6c4:	e062                	sd	s8,0(sp)
        printptr(fd, va_arg(ap, uint64));
 6c6:	008b8c13          	addi	s8,s7,8
 6ca:	000bb983          	ld	s3,0(s7)
  putc(fd, '0');
 6ce:	03000593          	li	a1,48
 6d2:	8556                	mv	a0,s5
 6d4:	00000097          	auipc	ra,0x0
 6d8:	e46080e7          	jalr	-442(ra) # 51a <putc>
  putc(fd, 'x');
 6dc:	07800593          	li	a1,120
 6e0:	8556                	mv	a0,s5
 6e2:	00000097          	auipc	ra,0x0
 6e6:	e38080e7          	jalr	-456(ra) # 51a <putc>
 6ea:	4941                	li	s2,16
    putc(fd, digits[x >> (sizeof(uint64) * 8 - 4)]);
 6ec:	00000b97          	auipc	s7,0x0
 6f0:	5ccb8b93          	addi	s7,s7,1484 # cb8 <digits>
 6f4:	03c9d793          	srli	a5,s3,0x3c
 6f8:	97de                	add	a5,a5,s7
 6fa:	0007c583          	lbu	a1,0(a5)
 6fe:	8556                	mv	a0,s5
 700:	00000097          	auipc	ra,0x0
 704:	e1a080e7          	jalr	-486(ra) # 51a <putc>
  for (i = 0; i < (sizeof(uint64) * 2); i++, x <<= 4)
 708:	0992                	slli	s3,s3,0x4
 70a:	397d                	addiw	s2,s2,-1
 70c:	fe0914e3          	bnez	s2,6f4 <vprintf+0x10c>
        printptr(fd, va_arg(ap, uint64));
 710:	8be2                	mv	s7,s8
      state = 0;
 712:	4981                	li	s3,0
 714:	6c02                	ld	s8,0(sp)
 716:	bf11                	j	62a <vprintf+0x42>
        s = va_arg(ap, char*);
 718:	008b8993          	addi	s3,s7,8
 71c:	000bb903          	ld	s2,0(s7)
        if(s == 0)
 720:	02090163          	beqz	s2,742 <vprintf+0x15a>
        while(*s != 0){
 724:	00094583          	lbu	a1,0(s2)
 728:	c9a5                	beqz	a1,798 <vprintf+0x1b0>
          putc(fd, *s);
 72a:	8556                	mv	a0,s5
 72c:	00000097          	auipc	ra,0x0
 730:	dee080e7          	jalr	-530(ra) # 51a <putc>
          s++;
 734:	0905                	addi	s2,s2,1
        while(*s != 0){
 736:	00094583          	lbu	a1,0(s2)
 73a:	f9e5                	bnez	a1,72a <vprintf+0x142>
        s = va_arg(ap, char*);
 73c:	8bce                	mv	s7,s3
      state = 0;
 73e:	4981                	li	s3,0
 740:	b5ed                	j	62a <vprintf+0x42>
          s = "(null)";
 742:	00000917          	auipc	s2,0x0
 746:	4e690913          	addi	s2,s2,1254 # c28 <ithread_join+0x88>
        while(*s != 0){
 74a:	02800593          	li	a1,40
 74e:	bff1                	j	72a <vprintf+0x142>
        putc(fd, va_arg(ap, uint));
 750:	008b8913          	addi	s2,s7,8
 754:	000bc583          	lbu	a1,0(s7)
 758:	8556                	mv	a0,s5
 75a:	00000097          	auipc	ra,0x0
 75e:	dc0080e7          	jalr	-576(ra) # 51a <putc>
 762:	8bca                	mv	s7,s2
      state = 0;
 764:	4981                	li	s3,0
 766:	b5d1                	j	62a <vprintf+0x42>
        putc(fd, c);
 768:	02500593          	li	a1,37
 76c:	8556                	mv	a0,s5
 76e:	00000097          	auipc	ra,0x0
 772:	dac080e7          	jalr	-596(ra) # 51a <putc>
      state = 0;
 776:	4981                	li	s3,0
 778:	bd4d                	j	62a <vprintf+0x42>
        putc(fd, '%');
 77a:	02500593          	li	a1,37
 77e:	8556                	mv	a0,s5
 780:	00000097          	auipc	ra,0x0
 784:	d9a080e7          	jalr	-614(ra) # 51a <putc>
        putc(fd, c);
 788:	85ca                	mv	a1,s2
 78a:	8556                	mv	a0,s5
 78c:	00000097          	auipc	ra,0x0
 790:	d8e080e7          	jalr	-626(ra) # 51a <putc>
      state = 0;
 794:	4981                	li	s3,0
 796:	bd51                	j	62a <vprintf+0x42>
        s = va_arg(ap, char*);
 798:	8bce                	mv	s7,s3
      state = 0;
 79a:	4981                	li	s3,0
 79c:	b579                	j	62a <vprintf+0x42>
 79e:	74e2                	ld	s1,56(sp)
 7a0:	79a2                	ld	s3,40(sp)
 7a2:	7a02                	ld	s4,32(sp)
 7a4:	6ae2                	ld	s5,24(sp)
 7a6:	6b42                	ld	s6,16(sp)
 7a8:	6ba2                	ld	s7,8(sp)
    }
  }
}
 7aa:	60a6                	ld	ra,72(sp)
 7ac:	6406                	ld	s0,64(sp)
 7ae:	7942                	ld	s2,48(sp)
 7b0:	6161                	addi	sp,sp,80
 7b2:	8082                	ret

00000000000007b4 <fprintf>:

void
fprintf(int fd, const char *fmt, ...)
{
 7b4:	715d                	addi	sp,sp,-80
 7b6:	ec06                	sd	ra,24(sp)
 7b8:	e822                	sd	s0,16(sp)
 7ba:	1000                	addi	s0,sp,32
 7bc:	e010                	sd	a2,0(s0)
 7be:	e414                	sd	a3,8(s0)
 7c0:	e818                	sd	a4,16(s0)
 7c2:	ec1c                	sd	a5,24(s0)
 7c4:	03043023          	sd	a6,32(s0)
 7c8:	03143423          	sd	a7,40(s0)
  va_list ap;

  va_start(ap, fmt);
 7cc:	fe843423          	sd	s0,-24(s0)
  vprintf(fd, fmt, ap);
 7d0:	8622                	mv	a2,s0
 7d2:	00000097          	auipc	ra,0x0
 7d6:	e16080e7          	jalr	-490(ra) # 5e8 <vprintf>
}
 7da:	60e2                	ld	ra,24(sp)
 7dc:	6442                	ld	s0,16(sp)
 7de:	6161                	addi	sp,sp,80
 7e0:	8082                	ret

00000000000007e2 <printf>:

void
printf(const char *fmt, ...)
{
 7e2:	711d                	addi	sp,sp,-96
 7e4:	ec06                	sd	ra,24(sp)
 7e6:	e822                	sd	s0,16(sp)
 7e8:	1000                	addi	s0,sp,32
 7ea:	e40c                	sd	a1,8(s0)
 7ec:	e810                	sd	a2,16(s0)
 7ee:	ec14                	sd	a3,24(s0)
 7f0:	f018                	sd	a4,32(s0)
 7f2:	f41c                	sd	a5,40(s0)
 7f4:	03043823          	sd	a6,48(s0)
 7f8:	03143c23          	sd	a7,56(s0)
  va_list ap;

  va_start(ap, fmt);
 7fc:	00840613          	addi	a2,s0,8
 800:	fec43423          	sd	a2,-24(s0)
  vprintf(1, fmt, ap);
 804:	85aa                	mv	a1,a0
 806:	4505                	li	a0,1
 808:	00000097          	auipc	ra,0x0
 80c:	de0080e7          	jalr	-544(ra) # 5e8 <vprintf>
}
 810:	60e2                	ld	ra,24(sp)
 812:	6442                	ld	s0,16(sp)
 814:	6125                	addi	sp,sp,96
 816:	8082                	ret

0000000000000818 <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 818:	1141                	addi	sp,sp,-16
 81a:	e422                	sd	s0,8(sp)
 81c:	0800                	addi	s0,sp,16
  Header *bp, *p;

  bp = (Header*)ap - 1;
 81e:	ff050693          	addi	a3,a0,-16
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 822:	00000797          	auipc	a5,0x0
 826:	7ee7b783          	ld	a5,2030(a5) # 1010 <freep>
 82a:	a02d                	j	854 <free+0x3c>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
      break;
  if(bp + bp->s.size == p->s.ptr){
    bp->s.size += p->s.ptr->s.size;
 82c:	4618                	lw	a4,8(a2)
 82e:	9f2d                	addw	a4,a4,a1
 830:	fee52c23          	sw	a4,-8(a0)
    bp->s.ptr = p->s.ptr->s.ptr;
 834:	6398                	ld	a4,0(a5)
 836:	6310                	ld	a2,0(a4)
 838:	a83d                	j	876 <free+0x5e>
  } else
    bp->s.ptr = p->s.ptr;
  if(p + p->s.size == bp){
    p->s.size += bp->s.size;
 83a:	ff852703          	lw	a4,-8(a0)
 83e:	9f31                	addw	a4,a4,a2
 840:	c798                	sw	a4,8(a5)
    p->s.ptr = bp->s.ptr;
 842:	ff053683          	ld	a3,-16(a0)
 846:	a091                	j	88a <free+0x72>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 848:	6398                	ld	a4,0(a5)
 84a:	00e7e463          	bltu	a5,a4,852 <free+0x3a>
 84e:	00e6ea63          	bltu	a3,a4,862 <free+0x4a>
{
 852:	87ba                	mv	a5,a4
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 854:	fed7fae3          	bgeu	a5,a3,848 <free+0x30>
 858:	6398                	ld	a4,0(a5)
 85a:	00e6e463          	bltu	a3,a4,862 <free+0x4a>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 85e:	fee7eae3          	bltu	a5,a4,852 <free+0x3a>
  if(bp + bp->s.size == p->s.ptr){
 862:	ff852583          	lw	a1,-8(a0)
 866:	6390                	ld	a2,0(a5)
 868:	02059813          	slli	a6,a1,0x20
 86c:	01c85713          	srli	a4,a6,0x1c
 870:	9736                	add	a4,a4,a3
 872:	fae60de3          	beq	a2,a4,82c <free+0x14>
    bp->s.ptr = p->s.ptr->s.ptr;
 876:	fec53823          	sd	a2,-16(a0)
  if(p + p->s.size == bp){
 87a:	4790                	lw	a2,8(a5)
 87c:	02061593          	slli	a1,a2,0x20
 880:	01c5d713          	srli	a4,a1,0x1c
 884:	973e                	add	a4,a4,a5
 886:	fae68ae3          	beq	a3,a4,83a <free+0x22>
    p->s.ptr = bp->s.ptr;
 88a:	e394                	sd	a3,0(a5)
  } else
    p->s.ptr = bp;
  freep = p;
 88c:	00000717          	auipc	a4,0x0
 890:	78f73223          	sd	a5,1924(a4) # 1010 <freep>
}
 894:	6422                	ld	s0,8(sp)
 896:	0141                	addi	sp,sp,16
 898:	8082                	ret

000000000000089a <malloc>:
  return freep;
}

void*
malloc(uint nbytes)
{
 89a:	7139                	addi	sp,sp,-64
 89c:	fc06                	sd	ra,56(sp)
 89e:	f822                	sd	s0,48(sp)
 8a0:	f426                	sd	s1,40(sp)
 8a2:	ec4e                	sd	s3,24(sp)
 8a4:	0080                	addi	s0,sp,64
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 8a6:	02051493          	slli	s1,a0,0x20
 8aa:	9081                	srli	s1,s1,0x20
 8ac:	04bd                	addi	s1,s1,15
 8ae:	8091                	srli	s1,s1,0x4
 8b0:	0014899b          	addiw	s3,s1,1
 8b4:	0485                	addi	s1,s1,1
  if((prevp = freep) == 0){
 8b6:	00000517          	auipc	a0,0x0
 8ba:	75a53503          	ld	a0,1882(a0) # 1010 <freep>
 8be:	c915                	beqz	a0,8f2 <malloc+0x58>
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 8c0:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
 8c2:	4798                	lw	a4,8(a5)
 8c4:	08977e63          	bgeu	a4,s1,960 <malloc+0xc6>
 8c8:	f04a                	sd	s2,32(sp)
 8ca:	e852                	sd	s4,16(sp)
 8cc:	e456                	sd	s5,8(sp)
 8ce:	e05a                	sd	s6,0(sp)
  if(nu < 4096)
 8d0:	8a4e                	mv	s4,s3
 8d2:	0009871b          	sext.w	a4,s3
 8d6:	6685                	lui	a3,0x1
 8d8:	00d77363          	bgeu	a4,a3,8de <malloc+0x44>
 8dc:	6a05                	lui	s4,0x1
 8de:	000a0b1b          	sext.w	s6,s4
  p = sbrk(nu * sizeof(Header));
 8e2:	004a1a1b          	slliw	s4,s4,0x4
        p->s.size = nunits;
      }
      freep = prevp;
      return (void*)(p + 1);
    }
    if(p == freep)
 8e6:	00000917          	auipc	s2,0x0
 8ea:	72a90913          	addi	s2,s2,1834 # 1010 <freep>
  if(p == (char*)-1)
 8ee:	5afd                	li	s5,-1
 8f0:	a091                	j	934 <malloc+0x9a>
 8f2:	f04a                	sd	s2,32(sp)
 8f4:	e852                	sd	s4,16(sp)
 8f6:	e456                	sd	s5,8(sp)
 8f8:	e05a                	sd	s6,0(sp)
    base.s.ptr = freep = prevp = &base;
 8fa:	00000797          	auipc	a5,0x0
 8fe:	73678793          	addi	a5,a5,1846 # 1030 <base>
 902:	00000717          	auipc	a4,0x0
 906:	70f73723          	sd	a5,1806(a4) # 1010 <freep>
 90a:	e39c                	sd	a5,0(a5)
    base.s.size = 0;
 90c:	0007a423          	sw	zero,8(a5)
    if(p->s.size >= nunits){
 910:	b7c1                	j	8d0 <malloc+0x36>
        prevp->s.ptr = p->s.ptr;
 912:	6398                	ld	a4,0(a5)
 914:	e118                	sd	a4,0(a0)
 916:	a08d                	j	978 <malloc+0xde>
  hp->s.size = nu;
 918:	01652423          	sw	s6,8(a0)
  free((void*)(hp + 1));
 91c:	0541                	addi	a0,a0,16
 91e:	00000097          	auipc	ra,0x0
 922:	efa080e7          	jalr	-262(ra) # 818 <free>
  return freep;
 926:	00093503          	ld	a0,0(s2)
      if((p = morecore(nunits)) == 0)
 92a:	c13d                	beqz	a0,990 <malloc+0xf6>
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 92c:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
 92e:	4798                	lw	a4,8(a5)
 930:	02977463          	bgeu	a4,s1,958 <malloc+0xbe>
    if(p == freep)
 934:	00093703          	ld	a4,0(s2)
 938:	853e                	mv	a0,a5
 93a:	fef719e3          	bne	a4,a5,92c <malloc+0x92>
  p = sbrk(nu * sizeof(Header));
 93e:	8552                	mv	a0,s4
 940:	00000097          	auipc	ra,0x0
 944:	b54080e7          	jalr	-1196(ra) # 494 <sbrk>
  if(p == (char*)-1)
 948:	fd5518e3          	bne	a0,s5,918 <malloc+0x7e>
        return 0;
 94c:	4501                	li	a0,0
 94e:	7902                	ld	s2,32(sp)
 950:	6a42                	ld	s4,16(sp)
 952:	6aa2                	ld	s5,8(sp)
 954:	6b02                	ld	s6,0(sp)
 956:	a03d                	j	984 <malloc+0xea>
 958:	7902                	ld	s2,32(sp)
 95a:	6a42                	ld	s4,16(sp)
 95c:	6aa2                	ld	s5,8(sp)
 95e:	6b02                	ld	s6,0(sp)
      if(p->s.size == nunits)
 960:	fae489e3          	beq	s1,a4,912 <malloc+0x78>
        p->s.size -= nunits;
 964:	4137073b          	subw	a4,a4,s3
 968:	c798                	sw	a4,8(a5)
        p += p->s.size;
 96a:	02071693          	slli	a3,a4,0x20
 96e:	01c6d713          	srli	a4,a3,0x1c
 972:	97ba                	add	a5,a5,a4
        p->s.size = nunits;
 974:	0137a423          	sw	s3,8(a5)
      freep = prevp;
 978:	00000717          	auipc	a4,0x0
 97c:	68a73c23          	sd	a0,1688(a4) # 1010 <freep>
      return (void*)(p + 1);
 980:	01078513          	addi	a0,a5,16
  }
}
 984:	70e2                	ld	ra,56(sp)
 986:	7442                	ld	s0,48(sp)
 988:	74a2                	ld	s1,40(sp)
 98a:	69e2                	ld	s3,24(sp)
 98c:	6121                	addi	sp,sp,64
 98e:	8082                	ret
 990:	7902                	ld	s2,32(sp)
 992:	6a42                	ld	s4,16(sp)
 994:	6aa2                	ld	s5,8(sp)
 996:	6b02                	ld	s6,0(sp)
 998:	b7f5                	j	984 <malloc+0xea>

000000000000099a <ithread_exit>:
  free(stacks);
  stacks = new_stacks;
  return 0;
}

void ithread_exit(uint64 status) {
 99a:	1141                	addi	sp,sp,-16
 99c:	e406                	sd	ra,8(sp)
 99e:	e022                	sd	s0,0(sp)
 9a0:	0800                	addi	s0,sp,16
  thread_exit(status);
 9a2:	2501                	sext.w	a0,a0
 9a4:	00000097          	auipc	ra,0x0
 9a8:	b20080e7          	jalr	-1248(ra) # 4c4 <thread_exit>
}
 9ac:	60a2                	ld	ra,8(sp)
 9ae:	6402                	ld	s0,0(sp)
 9b0:	0141                	addi	sp,sp,16
 9b2:	8082                	ret

00000000000009b4 <free_stacks>:
int free_stacks() {
 9b4:	7179                	addi	sp,sp,-48
 9b6:	f406                	sd	ra,40(sp)
 9b8:	f022                	sd	s0,32(sp)
 9ba:	ec26                	sd	s1,24(sp)
 9bc:	1800                	addi	s0,sp,48
  for (int i = 0; i < num_threads; i++) {
 9be:	00000797          	auipc	a5,0x0
 9c2:	6627a783          	lw	a5,1634(a5) # 1020 <num_threads>
 9c6:	04f05063          	blez	a5,a06 <free_stacks+0x52>
 9ca:	e84a                	sd	s2,16(sp)
 9cc:	e44e                	sd	s3,8(sp)
 9ce:	4481                	li	s1,0
    free(stacks[i]);
 9d0:	00000997          	auipc	s3,0x0
 9d4:	64898993          	addi	s3,s3,1608 # 1018 <stacks>
  for (int i = 0; i < num_threads; i++) {
 9d8:	00000917          	auipc	s2,0x0
 9dc:	64890913          	addi	s2,s2,1608 # 1020 <num_threads>
    free(stacks[i]);
 9e0:	0009b783          	ld	a5,0(s3)
 9e4:	00349713          	slli	a4,s1,0x3
 9e8:	97ba                	add	a5,a5,a4
 9ea:	6388                	ld	a0,0(a5)
 9ec:	00000097          	auipc	ra,0x0
 9f0:	e2c080e7          	jalr	-468(ra) # 818 <free>
  for (int i = 0; i < num_threads; i++) {
 9f4:	0485                	addi	s1,s1,1
 9f6:	00092703          	lw	a4,0(s2)
 9fa:	0004879b          	sext.w	a5,s1
 9fe:	fee7c1e3          	blt	a5,a4,9e0 <free_stacks+0x2c>
 a02:	6942                	ld	s2,16(sp)
 a04:	69a2                	ld	s3,8(sp)
  free(stacks);
 a06:	00000497          	auipc	s1,0x0
 a0a:	61248493          	addi	s1,s1,1554 # 1018 <stacks>
 a0e:	6088                	ld	a0,0(s1)
 a10:	00000097          	auipc	ra,0x0
 a14:	e08080e7          	jalr	-504(ra) # 818 <free>
  stacks = 0;
 a18:	0004b023          	sd	zero,0(s1)
  num_threads = 0;
 a1c:	00000797          	auipc	a5,0x0
 a20:	6007a223          	sw	zero,1540(a5) # 1020 <num_threads>
  max_stacks = INIT_MAX_STACKS;
 a24:	47a1                	li	a5,8
 a26:	00000717          	auipc	a4,0x0
 a2a:	5cf72d23          	sw	a5,1498(a4) # 1000 <max_stacks>
  threads_done = 0;
 a2e:	00000797          	auipc	a5,0x0
 a32:	5e07ab23          	sw	zero,1526(a5) # 1024 <threads_done>
}
 a36:	4501                	li	a0,0
 a38:	70a2                	ld	ra,40(sp)
 a3a:	7402                	ld	s0,32(sp)
 a3c:	64e2                	ld	s1,24(sp)
 a3e:	6145                	addi	sp,sp,48
 a40:	8082                	ret

0000000000000a42 <expand_num_threads>:
int expand_num_threads() {
 a42:	1101                	addi	sp,sp,-32
 a44:	ec06                	sd	ra,24(sp)
 a46:	e822                	sd	s0,16(sp)
 a48:	e426                	sd	s1,8(sp)
 a4a:	e04a                	sd	s2,0(sp)
 a4c:	1000                	addi	s0,sp,32
  max_stacks *= 2;
 a4e:	00000797          	auipc	a5,0x0
 a52:	5b278793          	addi	a5,a5,1458 # 1000 <max_stacks>
 a56:	4388                	lw	a0,0(a5)
 a58:	0015151b          	slliw	a0,a0,0x1
 a5c:	c388                	sw	a0,0(a5)
  void **new_stacks = malloc(max_stacks*sizeof(char*));
 a5e:	0035151b          	slliw	a0,a0,0x3
 a62:	00000097          	auipc	ra,0x0
 a66:	e38080e7          	jalr	-456(ra) # 89a <malloc>
 a6a:	892a                	mv	s2,a0
  memmove(new_stacks, stacks, num_threads*sizeof(char*));
 a6c:	00000617          	auipc	a2,0x0
 a70:	5b462603          	lw	a2,1460(a2) # 1020 <num_threads>
 a74:	00000497          	auipc	s1,0x0
 a78:	5a448493          	addi	s1,s1,1444 # 1018 <stacks>
 a7c:	0036161b          	slliw	a2,a2,0x3
 a80:	608c                	ld	a1,0(s1)
 a82:	00000097          	auipc	ra,0x0
 a86:	840080e7          	jalr	-1984(ra) # 2c2 <memmove>
  free(stacks);
 a8a:	6088                	ld	a0,0(s1)
 a8c:	00000097          	auipc	ra,0x0
 a90:	d8c080e7          	jalr	-628(ra) # 818 <free>
  stacks = new_stacks;
 a94:	0124b023          	sd	s2,0(s1)
}
 a98:	4501                	li	a0,0
 a9a:	60e2                	ld	ra,24(sp)
 a9c:	6442                	ld	s0,16(sp)
 a9e:	64a2                	ld	s1,8(sp)
 aa0:	6902                	ld	s2,0(sp)
 aa2:	6105                	addi	sp,sp,32
 aa4:	8082                	ret

0000000000000aa6 <ithread_create>:

int ithread_create(void* (*fn_ptr)(void *), void *args) {
 aa6:	7179                	addi	sp,sp,-48
 aa8:	f406                	sd	ra,40(sp)
 aaa:	f022                	sd	s0,32(sp)
 aac:	e84a                	sd	s2,16(sp)
 aae:	e44e                	sd	s3,8(sp)
 ab0:	1800                	addi	s0,sp,48
 ab2:	892a                	mv	s2,a0
 ab4:	89ae                	mv	s3,a1
  if (stacks == 0) {
 ab6:	00000797          	auipc	a5,0x0
 aba:	5627b783          	ld	a5,1378(a5) # 1018 <stacks>
 abe:	c3d9                	beqz	a5,b44 <ithread_create+0x9e>
    stacks = malloc(max_stacks*sizeof(char*));
  }
  if (num_threads == max_stacks) {
 ac0:	00000797          	auipc	a5,0x0
 ac4:	5407a783          	lw	a5,1344(a5) # 1000 <max_stacks>
 ac8:	00000717          	auipc	a4,0x0
 acc:	55872703          	lw	a4,1368(a4) # 1020 <num_threads>
 ad0:	0af71363          	bne	a4,a5,b76 <ithread_create+0xd0>
    if (max_stacks == MAX_THREADS) {
 ad4:	04000713          	li	a4,64
 ad8:	08e78563          	beq	a5,a4,b62 <ithread_create+0xbc>
 adc:	ec26                	sd	s1,24(sp)
      printf("ERROR: Thread capacity has been reached\n");
      return -1;
    }
    expand_num_threads();
 ade:	00000097          	auipc	ra,0x0
 ae2:	f64080e7          	jalr	-156(ra) # a42 <expand_num_threads>
  }

  void *stack_ptr = malloc(PGSIZE);
 ae6:	6505                	lui	a0,0x1
 ae8:	00000097          	auipc	ra,0x0
 aec:	db2080e7          	jalr	-590(ra) # 89a <malloc>
 af0:	84aa                	mv	s1,a0
  stacks[num_threads] = stack_ptr;
 af2:	00000717          	auipc	a4,0x0
 af6:	52e72703          	lw	a4,1326(a4) # 1020 <num_threads>
 afa:	070e                	slli	a4,a4,0x3
 afc:	00000797          	auipc	a5,0x0
 b00:	51c7b783          	ld	a5,1308(a5) # 1018 <stacks>
 b04:	97ba                	add	a5,a5,a4
 b06:	e388                	sd	a0,0(a5)
  int res = create_thread(fn_ptr, args, stack_ptr, &ithread_exit);
 b08:	00000697          	auipc	a3,0x0
 b0c:	e9268693          	addi	a3,a3,-366 # 99a <ithread_exit>
 b10:	862a                	mv	a2,a0
 b12:	85ce                	mv	a1,s3
 b14:	854a                	mv	a0,s2
 b16:	00000097          	auipc	ra,0x0
 b1a:	99e080e7          	jalr	-1634(ra) # 4b4 <create_thread>
 b1e:	892a                	mv	s2,a0
  if (res != -1) {
 b20:	57fd                	li	a5,-1
 b22:	04f50c63          	beq	a0,a5,b7a <ithread_create+0xd4>
    num_threads++;
 b26:	00000717          	auipc	a4,0x0
 b2a:	4fa70713          	addi	a4,a4,1274 # 1020 <num_threads>
 b2e:	431c                	lw	a5,0(a4)
 b30:	2785                	addiw	a5,a5,1
 b32:	c31c                	sw	a5,0(a4)
 b34:	64e2                	ld	s1,24(sp)
  } else {
    free(stack_ptr);
    stacks[num_threads] = 0;
  }
  return res;
}
 b36:	854a                	mv	a0,s2
 b38:	70a2                	ld	ra,40(sp)
 b3a:	7402                	ld	s0,32(sp)
 b3c:	6942                	ld	s2,16(sp)
 b3e:	69a2                	ld	s3,8(sp)
 b40:	6145                	addi	sp,sp,48
 b42:	8082                	ret
    stacks = malloc(max_stacks*sizeof(char*));
 b44:	00000517          	auipc	a0,0x0
 b48:	4bc52503          	lw	a0,1212(a0) # 1000 <max_stacks>
 b4c:	0035151b          	slliw	a0,a0,0x3
 b50:	00000097          	auipc	ra,0x0
 b54:	d4a080e7          	jalr	-694(ra) # 89a <malloc>
 b58:	00000797          	auipc	a5,0x0
 b5c:	4ca7b023          	sd	a0,1216(a5) # 1018 <stacks>
 b60:	b785                	j	ac0 <ithread_create+0x1a>
      printf("ERROR: Thread capacity has been reached\n");
 b62:	00000517          	auipc	a0,0x0
 b66:	0ce50513          	addi	a0,a0,206 # c30 <ithread_join+0x90>
 b6a:	00000097          	auipc	ra,0x0
 b6e:	c78080e7          	jalr	-904(ra) # 7e2 <printf>
      return -1;
 b72:	597d                	li	s2,-1
 b74:	b7c9                	j	b36 <ithread_create+0x90>
 b76:	ec26                	sd	s1,24(sp)
 b78:	b7bd                	j	ae6 <ithread_create+0x40>
    free(stack_ptr);
 b7a:	8526                	mv	a0,s1
 b7c:	00000097          	auipc	ra,0x0
 b80:	c9c080e7          	jalr	-868(ra) # 818 <free>
    stacks[num_threads] = 0;
 b84:	00000717          	auipc	a4,0x0
 b88:	49c72703          	lw	a4,1180(a4) # 1020 <num_threads>
 b8c:	070e                	slli	a4,a4,0x3
 b8e:	00000797          	auipc	a5,0x0
 b92:	48a7b783          	ld	a5,1162(a5) # 1018 <stacks>
 b96:	97ba                	add	a5,a5,a4
 b98:	0007b023          	sd	zero,0(a5)
 b9c:	64e2                	ld	s1,24(sp)
 b9e:	bf61                	j	b36 <ithread_create+0x90>

0000000000000ba0 <ithread_join>:

int ithread_join(int thread_id) {
 ba0:	1101                	addi	sp,sp,-32
 ba2:	ec06                	sd	ra,24(sp)
 ba4:	e822                	sd	s0,16(sp)
 ba6:	1000                	addi	s0,sp,32
  int status;
  join_thread(thread_id, (uint64)&status);
 ba8:	ff040793          	addi	a5,s0,-16
 bac:	ffc7859b          	addiw	a1,a5,-4
 bb0:	00000097          	auipc	ra,0x0
 bb4:	90c080e7          	jalr	-1780(ra) # 4bc <join_thread>
  threads_done++;
 bb8:	00000717          	auipc	a4,0x0
 bbc:	46c70713          	addi	a4,a4,1132 # 1024 <threads_done>
 bc0:	431c                	lw	a5,0(a4)
 bc2:	2785                	addiw	a5,a5,1
 bc4:	0007869b          	sext.w	a3,a5
 bc8:	c31c                	sw	a5,0(a4)
  if (threads_done == num_threads) {
 bca:	00000797          	auipc	a5,0x0
 bce:	4567a783          	lw	a5,1110(a5) # 1020 <num_threads>
 bd2:	00d78863          	beq	a5,a3,be2 <ithread_join+0x42>
    free_stacks();
  }
  return status;
}
 bd6:	fec42503          	lw	a0,-20(s0)
 bda:	60e2                	ld	ra,24(sp)
 bdc:	6442                	ld	s0,16(sp)
 bde:	6105                	addi	sp,sp,32
 be0:	8082                	ret
    free_stacks();
 be2:	00000097          	auipc	ra,0x0
 be6:	dd2080e7          	jalr	-558(ra) # 9b4 <free_stacks>
 bea:	b7f5                	j	bd6 <ithread_join+0x36>
