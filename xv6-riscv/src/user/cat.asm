
src/user/_cat:     file format elf64-littleriscv


Disassembly of section .text:

0000000000000000 <cat>:

char buf[512];

void
cat(int fd)
{
   0:	7179                	addi	sp,sp,-48
   2:	f406                	sd	ra,40(sp)
   4:	f022                	sd	s0,32(sp)
   6:	ec26                	sd	s1,24(sp)
   8:	e84a                	sd	s2,16(sp)
   a:	e44e                	sd	s3,8(sp)
   c:	1800                	addi	s0,sp,48
   e:	89aa                	mv	s3,a0
  int n;

  while((n = read(fd, buf, sizeof(buf))) > 0) {
  10:	00001917          	auipc	s2,0x1
  14:	02090913          	addi	s2,s2,32 # 1030 <buf>
  18:	20000613          	li	a2,512
  1c:	85ca                	mv	a1,s2
  1e:	854e                	mv	a0,s3
  20:	00000097          	auipc	ra,0x0
  24:	4ac080e7          	jalr	1196(ra) # 4cc <read>
  28:	84aa                	mv	s1,a0
  2a:	02a05963          	blez	a0,5c <cat+0x5c>
    if (write(1, buf, n) != n) {
  2e:	8626                	mv	a2,s1
  30:	85ca                	mv	a1,s2
  32:	4505                	li	a0,1
  34:	00000097          	auipc	ra,0x0
  38:	4a0080e7          	jalr	1184(ra) # 4d4 <write>
  3c:	fc950ee3          	beq	a0,s1,18 <cat+0x18>
      fprintf(2, "cat: write error\n");
  40:	00001597          	auipc	a1,0x1
  44:	c6058593          	addi	a1,a1,-928 # ca0 <ithread_join+0x58>
  48:	4509                	li	a0,2
  4a:	00001097          	auipc	ra,0x1
  4e:	812080e7          	jalr	-2030(ra) # 85c <fprintf>
      exit(1);
  52:	4505                	li	a0,1
  54:	00000097          	auipc	ra,0x0
  58:	460080e7          	jalr	1120(ra) # 4b4 <exit>
    }
  }
  if(n < 0){
  5c:	00054963          	bltz	a0,6e <cat+0x6e>
    fprintf(2, "cat: read error\n");
    exit(1);
  }
}
  60:	70a2                	ld	ra,40(sp)
  62:	7402                	ld	s0,32(sp)
  64:	64e2                	ld	s1,24(sp)
  66:	6942                	ld	s2,16(sp)
  68:	69a2                	ld	s3,8(sp)
  6a:	6145                	addi	sp,sp,48
  6c:	8082                	ret
    fprintf(2, "cat: read error\n");
  6e:	00001597          	auipc	a1,0x1
  72:	c4a58593          	addi	a1,a1,-950 # cb8 <ithread_join+0x70>
  76:	4509                	li	a0,2
  78:	00000097          	auipc	ra,0x0
  7c:	7e4080e7          	jalr	2020(ra) # 85c <fprintf>
    exit(1);
  80:	4505                	li	a0,1
  82:	00000097          	auipc	ra,0x0
  86:	432080e7          	jalr	1074(ra) # 4b4 <exit>

000000000000008a <main>:

int
main(int argc, char *argv[])
{
  8a:	7179                	addi	sp,sp,-48
  8c:	f406                	sd	ra,40(sp)
  8e:	f022                	sd	s0,32(sp)
  90:	1800                	addi	s0,sp,48
  int fd, i;

  if(argc <= 1){
  92:	4785                	li	a5,1
  94:	04a7da63          	bge	a5,a0,e8 <main+0x5e>
  98:	ec26                	sd	s1,24(sp)
  9a:	e84a                	sd	s2,16(sp)
  9c:	e44e                	sd	s3,8(sp)
  9e:	00858913          	addi	s2,a1,8
  a2:	ffe5099b          	addiw	s3,a0,-2
  a6:	02099793          	slli	a5,s3,0x20
  aa:	01d7d993          	srli	s3,a5,0x1d
  ae:	05c1                	addi	a1,a1,16
  b0:	99ae                	add	s3,s3,a1
    cat(0);
    exit(0);
  }

  for(i = 1; i < argc; i++){
    if((fd = open(argv[i], 0)) < 0){
  b2:	4581                	li	a1,0
  b4:	00093503          	ld	a0,0(s2)
  b8:	00000097          	auipc	ra,0x0
  bc:	43c080e7          	jalr	1084(ra) # 4f4 <open>
  c0:	84aa                	mv	s1,a0
  c2:	04054063          	bltz	a0,102 <main+0x78>
      fprintf(2, "cat: cannot open %s\n", argv[i]);
      exit(1);
    }
    cat(fd);
  c6:	00000097          	auipc	ra,0x0
  ca:	f3a080e7          	jalr	-198(ra) # 0 <cat>
    close(fd);
  ce:	8526                	mv	a0,s1
  d0:	00000097          	auipc	ra,0x0
  d4:	40c080e7          	jalr	1036(ra) # 4dc <close>
  for(i = 1; i < argc; i++){
  d8:	0921                	addi	s2,s2,8
  da:	fd391ce3          	bne	s2,s3,b2 <main+0x28>
  }
  exit(0);
  de:	4501                	li	a0,0
  e0:	00000097          	auipc	ra,0x0
  e4:	3d4080e7          	jalr	980(ra) # 4b4 <exit>
  e8:	ec26                	sd	s1,24(sp)
  ea:	e84a                	sd	s2,16(sp)
  ec:	e44e                	sd	s3,8(sp)
    cat(0);
  ee:	4501                	li	a0,0
  f0:	00000097          	auipc	ra,0x0
  f4:	f10080e7          	jalr	-240(ra) # 0 <cat>
    exit(0);
  f8:	4501                	li	a0,0
  fa:	00000097          	auipc	ra,0x0
  fe:	3ba080e7          	jalr	954(ra) # 4b4 <exit>
      fprintf(2, "cat: cannot open %s\n", argv[i]);
 102:	00093603          	ld	a2,0(s2)
 106:	00001597          	auipc	a1,0x1
 10a:	bca58593          	addi	a1,a1,-1078 # cd0 <ithread_join+0x88>
 10e:	4509                	li	a0,2
 110:	00000097          	auipc	ra,0x0
 114:	74c080e7          	jalr	1868(ra) # 85c <fprintf>
      exit(1);
 118:	4505                	li	a0,1
 11a:	00000097          	auipc	ra,0x0
 11e:	39a080e7          	jalr	922(ra) # 4b4 <exit>

0000000000000122 <_main>:
//
// wrapper so that it's OK if main() does not call exit().
//
void
_main()
{
 122:	1141                	addi	sp,sp,-16
 124:	e406                	sd	ra,8(sp)
 126:	e022                	sd	s0,0(sp)
 128:	0800                	addi	s0,sp,16
  extern int main();
  main();
 12a:	00000097          	auipc	ra,0x0
 12e:	f60080e7          	jalr	-160(ra) # 8a <main>
  exit(0);
 132:	4501                	li	a0,0
 134:	00000097          	auipc	ra,0x0
 138:	380080e7          	jalr	896(ra) # 4b4 <exit>

000000000000013c <strcpy>:
}

char*
strcpy(char *s, const char *t)
{
 13c:	1141                	addi	sp,sp,-16
 13e:	e422                	sd	s0,8(sp)
 140:	0800                	addi	s0,sp,16
  char *os;

  os = s;
  while((*s++ = *t++) != 0)
 142:	87aa                	mv	a5,a0
 144:	0585                	addi	a1,a1,1
 146:	0785                	addi	a5,a5,1
 148:	fff5c703          	lbu	a4,-1(a1)
 14c:	fee78fa3          	sb	a4,-1(a5)
 150:	fb75                	bnez	a4,144 <strcpy+0x8>
    ;
  return os;
}
 152:	6422                	ld	s0,8(sp)
 154:	0141                	addi	sp,sp,16
 156:	8082                	ret

0000000000000158 <strcmp>:

int
strcmp(const char *p, const char *q)
{
 158:	1141                	addi	sp,sp,-16
 15a:	e422                	sd	s0,8(sp)
 15c:	0800                	addi	s0,sp,16
  while(*p && *p == *q)
 15e:	00054783          	lbu	a5,0(a0)
 162:	cb91                	beqz	a5,176 <strcmp+0x1e>
 164:	0005c703          	lbu	a4,0(a1)
 168:	00f71763          	bne	a4,a5,176 <strcmp+0x1e>
    p++, q++;
 16c:	0505                	addi	a0,a0,1
 16e:	0585                	addi	a1,a1,1
  while(*p && *p == *q)
 170:	00054783          	lbu	a5,0(a0)
 174:	fbe5                	bnez	a5,164 <strcmp+0xc>
  return (uchar)*p - (uchar)*q;
 176:	0005c503          	lbu	a0,0(a1)
}
 17a:	40a7853b          	subw	a0,a5,a0
 17e:	6422                	ld	s0,8(sp)
 180:	0141                	addi	sp,sp,16
 182:	8082                	ret

0000000000000184 <strlen>:

uint
strlen(const char *s)
{
 184:	1141                	addi	sp,sp,-16
 186:	e422                	sd	s0,8(sp)
 188:	0800                	addi	s0,sp,16
  int n;

  for(n = 0; s[n]; n++)
 18a:	00054783          	lbu	a5,0(a0)
 18e:	cf91                	beqz	a5,1aa <strlen+0x26>
 190:	0505                	addi	a0,a0,1
 192:	87aa                	mv	a5,a0
 194:	86be                	mv	a3,a5
 196:	0785                	addi	a5,a5,1
 198:	fff7c703          	lbu	a4,-1(a5)
 19c:	ff65                	bnez	a4,194 <strlen+0x10>
 19e:	40a6853b          	subw	a0,a3,a0
 1a2:	2505                	addiw	a0,a0,1
    ;
  return n;
}
 1a4:	6422                	ld	s0,8(sp)
 1a6:	0141                	addi	sp,sp,16
 1a8:	8082                	ret
  for(n = 0; s[n]; n++)
 1aa:	4501                	li	a0,0
 1ac:	bfe5                	j	1a4 <strlen+0x20>

00000000000001ae <memset>:

void*
memset(void *dst, int c, uint n)
{
 1ae:	1141                	addi	sp,sp,-16
 1b0:	e422                	sd	s0,8(sp)
 1b2:	0800                	addi	s0,sp,16
  char *cdst = (char *) dst;
  int i;
  for(i = 0; i < n; i++){
 1b4:	ca19                	beqz	a2,1ca <memset+0x1c>
 1b6:	87aa                	mv	a5,a0
 1b8:	1602                	slli	a2,a2,0x20
 1ba:	9201                	srli	a2,a2,0x20
 1bc:	00a60733          	add	a4,a2,a0
    cdst[i] = c;
 1c0:	00b78023          	sb	a1,0(a5)
  for(i = 0; i < n; i++){
 1c4:	0785                	addi	a5,a5,1
 1c6:	fee79de3          	bne	a5,a4,1c0 <memset+0x12>
  }
  return dst;
}
 1ca:	6422                	ld	s0,8(sp)
 1cc:	0141                	addi	sp,sp,16
 1ce:	8082                	ret

00000000000001d0 <strchr>:

char*
strchr(const char *s, char c)
{
 1d0:	1141                	addi	sp,sp,-16
 1d2:	e422                	sd	s0,8(sp)
 1d4:	0800                	addi	s0,sp,16
  for(; *s; s++)
 1d6:	00054783          	lbu	a5,0(a0)
 1da:	cb99                	beqz	a5,1f0 <strchr+0x20>
    if(*s == c)
 1dc:	00f58763          	beq	a1,a5,1ea <strchr+0x1a>
  for(; *s; s++)
 1e0:	0505                	addi	a0,a0,1
 1e2:	00054783          	lbu	a5,0(a0)
 1e6:	fbfd                	bnez	a5,1dc <strchr+0xc>
      return (char*)s;
  return 0;
 1e8:	4501                	li	a0,0
}
 1ea:	6422                	ld	s0,8(sp)
 1ec:	0141                	addi	sp,sp,16
 1ee:	8082                	ret
  return 0;
 1f0:	4501                	li	a0,0
 1f2:	bfe5                	j	1ea <strchr+0x1a>

00000000000001f4 <gets>:

char*
gets(char *buf, int max)
{
 1f4:	711d                	addi	sp,sp,-96
 1f6:	ec86                	sd	ra,88(sp)
 1f8:	e8a2                	sd	s0,80(sp)
 1fa:	e4a6                	sd	s1,72(sp)
 1fc:	e0ca                	sd	s2,64(sp)
 1fe:	fc4e                	sd	s3,56(sp)
 200:	f852                	sd	s4,48(sp)
 202:	f456                	sd	s5,40(sp)
 204:	f05a                	sd	s6,32(sp)
 206:	ec5e                	sd	s7,24(sp)
 208:	1080                	addi	s0,sp,96
 20a:	8baa                	mv	s7,a0
 20c:	8a2e                	mv	s4,a1
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 20e:	892a                	mv	s2,a0
 210:	4481                	li	s1,0
    cc = read(0, &c, 1);
    if(cc < 1)
      break;
    buf[i++] = c;
    if(c == '\n' || c == '\r')
 212:	4aa9                	li	s5,10
 214:	4b35                	li	s6,13
  for(i=0; i+1 < max; ){
 216:	89a6                	mv	s3,s1
 218:	2485                	addiw	s1,s1,1
 21a:	0344d863          	bge	s1,s4,24a <gets+0x56>
    cc = read(0, &c, 1);
 21e:	4605                	li	a2,1
 220:	faf40593          	addi	a1,s0,-81
 224:	4501                	li	a0,0
 226:	00000097          	auipc	ra,0x0
 22a:	2a6080e7          	jalr	678(ra) # 4cc <read>
    if(cc < 1)
 22e:	00a05e63          	blez	a0,24a <gets+0x56>
    buf[i++] = c;
 232:	faf44783          	lbu	a5,-81(s0)
 236:	00f90023          	sb	a5,0(s2)
    if(c == '\n' || c == '\r')
 23a:	01578763          	beq	a5,s5,248 <gets+0x54>
 23e:	0905                	addi	s2,s2,1
 240:	fd679be3          	bne	a5,s6,216 <gets+0x22>
    buf[i++] = c;
 244:	89a6                	mv	s3,s1
 246:	a011                	j	24a <gets+0x56>
 248:	89a6                	mv	s3,s1
      break;
  }
  buf[i] = '\0';
 24a:	99de                	add	s3,s3,s7
 24c:	00098023          	sb	zero,0(s3)
  return buf;
}
 250:	855e                	mv	a0,s7
 252:	60e6                	ld	ra,88(sp)
 254:	6446                	ld	s0,80(sp)
 256:	64a6                	ld	s1,72(sp)
 258:	6906                	ld	s2,64(sp)
 25a:	79e2                	ld	s3,56(sp)
 25c:	7a42                	ld	s4,48(sp)
 25e:	7aa2                	ld	s5,40(sp)
 260:	7b02                	ld	s6,32(sp)
 262:	6be2                	ld	s7,24(sp)
 264:	6125                	addi	sp,sp,96
 266:	8082                	ret

0000000000000268 <fgetstdin>:

int
fgetstdin(char *buf, int size) {
 268:	711d                	addi	sp,sp,-96
 26a:	ec86                	sd	ra,88(sp)
 26c:	e8a2                	sd	s0,80(sp)
 26e:	e4a6                	sd	s1,72(sp)
 270:	e0ca                	sd	s2,64(sp)
 272:	fc4e                	sd	s3,56(sp)
 274:	f852                	sd	s4,48(sp)
 276:	f456                	sd	s5,40(sp)
 278:	f05a                	sd	s6,32(sp)
 27a:	ec5e                	sd	s7,24(sp)
 27c:	1080                	addi	s0,sp,96
 27e:	8baa                	mv	s7,a0
 280:	89ae                	mv	s3,a1
  int i, cc;
  char c;

  for(i=0; i+1 < size; ){
 282:	892a                	mv	s2,a0
 284:	4481                	li	s1,0
    cc = read(0, &c, 1);
    if(cc < 1)
      break;
    buf[i++] = c;
    if(c == '\n' || c == '\r')
 286:	4aa9                	li	s5,10
 288:	4b35                	li	s6,13
  for(i=0; i+1 < size; ){
 28a:	8a26                	mv	s4,s1
 28c:	2485                	addiw	s1,s1,1
 28e:	0334d863          	bge	s1,s3,2be <fgetstdin+0x56>
    cc = read(0, &c, 1);
 292:	4605                	li	a2,1
 294:	faf40593          	addi	a1,s0,-81
 298:	4501                	li	a0,0
 29a:	00000097          	auipc	ra,0x0
 29e:	232080e7          	jalr	562(ra) # 4cc <read>
    if(cc < 1)
 2a2:	00a05e63          	blez	a0,2be <fgetstdin+0x56>
    buf[i++] = c;
 2a6:	faf44783          	lbu	a5,-81(s0)
 2aa:	00f90023          	sb	a5,0(s2)
    if(c == '\n' || c == '\r')
 2ae:	01578763          	beq	a5,s5,2bc <fgetstdin+0x54>
 2b2:	0905                	addi	s2,s2,1
 2b4:	fd679be3          	bne	a5,s6,28a <fgetstdin+0x22>
    buf[i++] = c;
 2b8:	8a26                	mv	s4,s1
 2ba:	a011                	j	2be <fgetstdin+0x56>
 2bc:	8a26                	mv	s4,s1
      break;
  }
  buf[i] = '\0';
 2be:	9bd2                	add	s7,s7,s4
 2c0:	000b8023          	sb	zero,0(s7)
  return i;
}
 2c4:	8552                	mv	a0,s4
 2c6:	60e6                	ld	ra,88(sp)
 2c8:	6446                	ld	s0,80(sp)
 2ca:	64a6                	ld	s1,72(sp)
 2cc:	6906                	ld	s2,64(sp)
 2ce:	79e2                	ld	s3,56(sp)
 2d0:	7a42                	ld	s4,48(sp)
 2d2:	7aa2                	ld	s5,40(sp)
 2d4:	7b02                	ld	s6,32(sp)
 2d6:	6be2                	ld	s7,24(sp)
 2d8:	6125                	addi	sp,sp,96
 2da:	8082                	ret

00000000000002dc <stat>:

int
stat(const char *n, struct stat *st)
{
 2dc:	1101                	addi	sp,sp,-32
 2de:	ec06                	sd	ra,24(sp)
 2e0:	e822                	sd	s0,16(sp)
 2e2:	e04a                	sd	s2,0(sp)
 2e4:	1000                	addi	s0,sp,32
 2e6:	892e                	mv	s2,a1
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 2e8:	4581                	li	a1,0
 2ea:	00000097          	auipc	ra,0x0
 2ee:	20a080e7          	jalr	522(ra) # 4f4 <open>
  if(fd < 0)
 2f2:	02054663          	bltz	a0,31e <stat+0x42>
 2f6:	e426                	sd	s1,8(sp)
 2f8:	84aa                	mv	s1,a0
    return -1;
  r = fstat(fd, st);
 2fa:	85ca                	mv	a1,s2
 2fc:	00000097          	auipc	ra,0x0
 300:	210080e7          	jalr	528(ra) # 50c <fstat>
 304:	892a                	mv	s2,a0
  close(fd);
 306:	8526                	mv	a0,s1
 308:	00000097          	auipc	ra,0x0
 30c:	1d4080e7          	jalr	468(ra) # 4dc <close>
  return r;
 310:	64a2                	ld	s1,8(sp)
}
 312:	854a                	mv	a0,s2
 314:	60e2                	ld	ra,24(sp)
 316:	6442                	ld	s0,16(sp)
 318:	6902                	ld	s2,0(sp)
 31a:	6105                	addi	sp,sp,32
 31c:	8082                	ret
    return -1;
 31e:	597d                	li	s2,-1
 320:	bfcd                	j	312 <stat+0x36>

0000000000000322 <atoi>:

int
atoi(const char *s)
{
 322:	1141                	addi	sp,sp,-16
 324:	e422                	sd	s0,8(sp)
 326:	0800                	addi	s0,sp,16
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
 328:	00054683          	lbu	a3,0(a0)
 32c:	fd06879b          	addiw	a5,a3,-48
 330:	0ff7f793          	zext.b	a5,a5
 334:	4625                	li	a2,9
 336:	02f66863          	bltu	a2,a5,366 <atoi+0x44>
 33a:	872a                	mv	a4,a0
  n = 0;
 33c:	4501                	li	a0,0
    n = n*10 + *s++ - '0';
 33e:	0705                	addi	a4,a4,1
 340:	0025179b          	slliw	a5,a0,0x2
 344:	9fa9                	addw	a5,a5,a0
 346:	0017979b          	slliw	a5,a5,0x1
 34a:	9fb5                	addw	a5,a5,a3
 34c:	fd07851b          	addiw	a0,a5,-48
  while('0' <= *s && *s <= '9')
 350:	00074683          	lbu	a3,0(a4)
 354:	fd06879b          	addiw	a5,a3,-48
 358:	0ff7f793          	zext.b	a5,a5
 35c:	fef671e3          	bgeu	a2,a5,33e <atoi+0x1c>
  return n;
}
 360:	6422                	ld	s0,8(sp)
 362:	0141                	addi	sp,sp,16
 364:	8082                	ret
  n = 0;
 366:	4501                	li	a0,0
 368:	bfe5                	j	360 <atoi+0x3e>

000000000000036a <memmove>:

void*
memmove(void *vdst, const void *vsrc, int n)
{
 36a:	1141                	addi	sp,sp,-16
 36c:	e422                	sd	s0,8(sp)
 36e:	0800                	addi	s0,sp,16
  char *dst;
  const char *src;

  dst = vdst;
  src = vsrc;
  if (src > dst) {
 370:	02b57463          	bgeu	a0,a1,398 <memmove+0x2e>
    while(n-- > 0)
 374:	00c05f63          	blez	a2,392 <memmove+0x28>
 378:	1602                	slli	a2,a2,0x20
 37a:	9201                	srli	a2,a2,0x20
 37c:	00c507b3          	add	a5,a0,a2
  dst = vdst;
 380:	872a                	mv	a4,a0
      *dst++ = *src++;
 382:	0585                	addi	a1,a1,1
 384:	0705                	addi	a4,a4,1
 386:	fff5c683          	lbu	a3,-1(a1)
 38a:	fed70fa3          	sb	a3,-1(a4)
    while(n-- > 0)
 38e:	fef71ae3          	bne	a4,a5,382 <memmove+0x18>
    src += n;
    while(n-- > 0)
      *--dst = *--src;
  }
  return vdst;
}
 392:	6422                	ld	s0,8(sp)
 394:	0141                	addi	sp,sp,16
 396:	8082                	ret
    dst += n;
 398:	00c50733          	add	a4,a0,a2
    src += n;
 39c:	95b2                	add	a1,a1,a2
    while(n-- > 0)
 39e:	fec05ae3          	blez	a2,392 <memmove+0x28>
 3a2:	fff6079b          	addiw	a5,a2,-1
 3a6:	1782                	slli	a5,a5,0x20
 3a8:	9381                	srli	a5,a5,0x20
 3aa:	fff7c793          	not	a5,a5
 3ae:	97ba                	add	a5,a5,a4
      *--dst = *--src;
 3b0:	15fd                	addi	a1,a1,-1
 3b2:	177d                	addi	a4,a4,-1
 3b4:	0005c683          	lbu	a3,0(a1)
 3b8:	00d70023          	sb	a3,0(a4)
    while(n-- > 0)
 3bc:	fee79ae3          	bne	a5,a4,3b0 <memmove+0x46>
 3c0:	bfc9                	j	392 <memmove+0x28>

00000000000003c2 <memcmp>:

int
memcmp(const void *s1, const void *s2, uint n)
{
 3c2:	1141                	addi	sp,sp,-16
 3c4:	e422                	sd	s0,8(sp)
 3c6:	0800                	addi	s0,sp,16
  const char *p1 = s1, *p2 = s2;
  while (n-- > 0) {
 3c8:	ca05                	beqz	a2,3f8 <memcmp+0x36>
 3ca:	fff6069b          	addiw	a3,a2,-1
 3ce:	1682                	slli	a3,a3,0x20
 3d0:	9281                	srli	a3,a3,0x20
 3d2:	0685                	addi	a3,a3,1
 3d4:	96aa                	add	a3,a3,a0
    if (*p1 != *p2) {
 3d6:	00054783          	lbu	a5,0(a0)
 3da:	0005c703          	lbu	a4,0(a1)
 3de:	00e79863          	bne	a5,a4,3ee <memcmp+0x2c>
      return *p1 - *p2;
    }
    p1++;
 3e2:	0505                	addi	a0,a0,1
    p2++;
 3e4:	0585                	addi	a1,a1,1
  while (n-- > 0) {
 3e6:	fed518e3          	bne	a0,a3,3d6 <memcmp+0x14>
  }
  return 0;
 3ea:	4501                	li	a0,0
 3ec:	a019                	j	3f2 <memcmp+0x30>
      return *p1 - *p2;
 3ee:	40e7853b          	subw	a0,a5,a4
}
 3f2:	6422                	ld	s0,8(sp)
 3f4:	0141                	addi	sp,sp,16
 3f6:	8082                	ret
  return 0;
 3f8:	4501                	li	a0,0
 3fa:	bfe5                	j	3f2 <memcmp+0x30>

00000000000003fc <memcpy>:

void *
memcpy(void *dst, const void *src, uint n)
{
 3fc:	1141                	addi	sp,sp,-16
 3fe:	e406                	sd	ra,8(sp)
 400:	e022                	sd	s0,0(sp)
 402:	0800                	addi	s0,sp,16
  return memmove(dst, src, n);
 404:	00000097          	auipc	ra,0x0
 408:	f66080e7          	jalr	-154(ra) # 36a <memmove>
}
 40c:	60a2                	ld	ra,8(sp)
 40e:	6402                	ld	s0,0(sp)
 410:	0141                	addi	sp,sp,16
 412:	8082                	ret

0000000000000414 <inet_addr>:

// Parse a dotted-decimal IPv4 string (e.g. "10.10.0.2") and return the
// address as a 32-bit integer in host byte order, or 0 on failure.
uint
inet_addr(const char *s)
{
 414:	1141                	addi	sp,sp,-16
 416:	e422                	sd	s0,8(sp)
 418:	0800                	addi	s0,sp,16
  uint result = 0;
  int octet = 0;
  int digits = 0;
  int dots = 0;

  for (; *s; s++) {
 41a:	00054783          	lbu	a5,0(a0)
 41e:	cfbd                	beqz	a5,49c <inet_addr+0x88>
  int dots = 0;
 420:	4801                	li	a6,0
  int digits = 0;
 422:	4601                	li	a2,0
  int octet = 0;
 424:	4681                	li	a3,0
  uint result = 0;
 426:	4581                	li	a1,0
    if (*s >= '0' && *s <= '9') {
 428:	48a5                	li	a7,9
      octet = octet * 10 + (*s - '0');
      digits++;
      if (octet > 255)
        return 0;
    } else if (*s == '.') {
 42a:	02e00e93          	li	t4,46
      if (digits == 0 || dots == 3)
 42e:	4f0d                	li	t5,3
        return 0;
      result = (result << 8) | (uint)octet;
      octet = 0;
      digits = 0;
 430:	4301                	li	t1,0
      if (octet > 255)
 432:	0ff00e13          	li	t3,255
 436:	a015                	j	45a <inet_addr+0x46>
    } else if (*s == '.') {
 438:	07d79463          	bne	a5,t4,4a0 <inet_addr+0x8c>
      if (digits == 0 || dots == 3)
 43c:	c625                	beqz	a2,4a4 <inet_addr+0x90>
 43e:	07e80563          	beq	a6,t5,4a8 <inet_addr+0x94>
      result = (result << 8) | (uint)octet;
 442:	0085959b          	slliw	a1,a1,0x8
 446:	8ecd                	or	a3,a3,a1
 448:	0006859b          	sext.w	a1,a3
      dots++;
 44c:	2805                	addiw	a6,a6,1
      digits = 0;
 44e:	861a                	mv	a2,t1
      octet = 0;
 450:	869a                	mv	a3,t1
  for (; *s; s++) {
 452:	0505                	addi	a0,a0,1
 454:	00054783          	lbu	a5,0(a0)
 458:	c79d                	beqz	a5,486 <inet_addr+0x72>
    if (*s >= '0' && *s <= '9') {
 45a:	fd07871b          	addiw	a4,a5,-48
 45e:	0ff77713          	zext.b	a4,a4
 462:	fce8ebe3          	bltu	a7,a4,438 <inet_addr+0x24>
      octet = octet * 10 + (*s - '0');
 466:	0026971b          	slliw	a4,a3,0x2
 46a:	9f35                	addw	a4,a4,a3
 46c:	0017171b          	slliw	a4,a4,0x1
 470:	fd07879b          	addiw	a5,a5,-48
 474:	00e786bb          	addw	a3,a5,a4
      digits++;
 478:	2605                	addiw	a2,a2,1
      if (octet > 255)
 47a:	fcde5ce3          	bge	t3,a3,452 <inet_addr+0x3e>
        return 0;
 47e:	4501                	li	a0,0
  if (digits == 0 || dots != 3)
    return 0;

  result = (result << 8) | (uint)octet;
  return result;
}
 480:	6422                	ld	s0,8(sp)
 482:	0141                	addi	sp,sp,16
 484:	8082                	ret
    return 0;
 486:	4501                	li	a0,0
  if (digits == 0 || dots != 3)
 488:	de65                	beqz	a2,480 <inet_addr+0x6c>
 48a:	478d                	li	a5,3
 48c:	fef81ae3          	bne	a6,a5,480 <inet_addr+0x6c>
  result = (result << 8) | (uint)octet;
 490:	0085959b          	slliw	a1,a1,0x8
 494:	8ecd                	or	a3,a3,a1
 496:	0006851b          	sext.w	a0,a3
  return result;
 49a:	b7dd                	j	480 <inet_addr+0x6c>
    return 0;
 49c:	4501                	li	a0,0
 49e:	b7cd                	j	480 <inet_addr+0x6c>
      return 0;
 4a0:	4501                	li	a0,0
 4a2:	bff9                	j	480 <inet_addr+0x6c>
        return 0;
 4a4:	4501                	li	a0,0
 4a6:	bfe9                	j	480 <inet_addr+0x6c>
 4a8:	4501                	li	a0,0
 4aa:	bfd9                	j	480 <inet_addr+0x6c>

00000000000004ac <fork>:
# generated by usys.pl - do not edit
#include "kernel/syscall.h"
.global fork
fork:
 li a7, SYS_fork
 4ac:	4885                	li	a7,1
 ecall
 4ae:	00000073          	ecall
 ret
 4b2:	8082                	ret

00000000000004b4 <exit>:
.global exit
exit:
 li a7, SYS_exit
 4b4:	4889                	li	a7,2
 ecall
 4b6:	00000073          	ecall
 ret
 4ba:	8082                	ret

00000000000004bc <wait>:
.global wait
wait:
 li a7, SYS_wait
 4bc:	488d                	li	a7,3
 ecall
 4be:	00000073          	ecall
 ret
 4c2:	8082                	ret

00000000000004c4 <pipe>:
.global pipe
pipe:
 li a7, SYS_pipe
 4c4:	4891                	li	a7,4
 ecall
 4c6:	00000073          	ecall
 ret
 4ca:	8082                	ret

00000000000004cc <read>:
.global read
read:
 li a7, SYS_read
 4cc:	4895                	li	a7,5
 ecall
 4ce:	00000073          	ecall
 ret
 4d2:	8082                	ret

00000000000004d4 <write>:
.global write
write:
 li a7, SYS_write
 4d4:	48c1                	li	a7,16
 ecall
 4d6:	00000073          	ecall
 ret
 4da:	8082                	ret

00000000000004dc <close>:
.global close
close:
 li a7, SYS_close
 4dc:	48d5                	li	a7,21
 ecall
 4de:	00000073          	ecall
 ret
 4e2:	8082                	ret

00000000000004e4 <kill>:
.global kill
kill:
 li a7, SYS_kill
 4e4:	4899                	li	a7,6
 ecall
 4e6:	00000073          	ecall
 ret
 4ea:	8082                	ret

00000000000004ec <exec>:
.global exec
exec:
 li a7, SYS_exec
 4ec:	489d                	li	a7,7
 ecall
 4ee:	00000073          	ecall
 ret
 4f2:	8082                	ret

00000000000004f4 <open>:
.global open
open:
 li a7, SYS_open
 4f4:	48bd                	li	a7,15
 ecall
 4f6:	00000073          	ecall
 ret
 4fa:	8082                	ret

00000000000004fc <mknod>:
.global mknod
mknod:
 li a7, SYS_mknod
 4fc:	48c5                	li	a7,17
 ecall
 4fe:	00000073          	ecall
 ret
 502:	8082                	ret

0000000000000504 <unlink>:
.global unlink
unlink:
 li a7, SYS_unlink
 504:	48c9                	li	a7,18
 ecall
 506:	00000073          	ecall
 ret
 50a:	8082                	ret

000000000000050c <fstat>:
.global fstat
fstat:
 li a7, SYS_fstat
 50c:	48a1                	li	a7,8
 ecall
 50e:	00000073          	ecall
 ret
 512:	8082                	ret

0000000000000514 <link>:
.global link
link:
 li a7, SYS_link
 514:	48cd                	li	a7,19
 ecall
 516:	00000073          	ecall
 ret
 51a:	8082                	ret

000000000000051c <mkdir>:
.global mkdir
mkdir:
 li a7, SYS_mkdir
 51c:	48d1                	li	a7,20
 ecall
 51e:	00000073          	ecall
 ret
 522:	8082                	ret

0000000000000524 <chdir>:
.global chdir
chdir:
 li a7, SYS_chdir
 524:	48a5                	li	a7,9
 ecall
 526:	00000073          	ecall
 ret
 52a:	8082                	ret

000000000000052c <dup>:
.global dup
dup:
 li a7, SYS_dup
 52c:	48a9                	li	a7,10
 ecall
 52e:	00000073          	ecall
 ret
 532:	8082                	ret

0000000000000534 <getpid>:
.global getpid
getpid:
 li a7, SYS_getpid
 534:	48ad                	li	a7,11
 ecall
 536:	00000073          	ecall
 ret
 53a:	8082                	ret

000000000000053c <sbrk>:
.global sbrk
sbrk:
 li a7, SYS_sbrk
 53c:	48b1                	li	a7,12
 ecall
 53e:	00000073          	ecall
 ret
 542:	8082                	ret

0000000000000544 <sleep>:
.global sleep
sleep:
 li a7, SYS_sleep
 544:	48b5                	li	a7,13
 ecall
 546:	00000073          	ecall
 ret
 54a:	8082                	ret

000000000000054c <uptime>:
.global uptime
uptime:
 li a7, SYS_uptime
 54c:	48b9                	li	a7,14
 ecall
 54e:	00000073          	ecall
 ret
 552:	8082                	ret

0000000000000554 <spoon>:
.global spoon
spoon:
 li a7, SYS_spoon
 554:	48d9                	li	a7,22
 ecall
 556:	00000073          	ecall
 ret
 55a:	8082                	ret

000000000000055c <create_thread>:
.global create_thread
create_thread:
 li a7, SYS_create_thread
 55c:	48dd                	li	a7,23
 ecall
 55e:	00000073          	ecall
 ret
 562:	8082                	ret

0000000000000564 <join_thread>:
.global join_thread
join_thread:
 li a7, SYS_join_thread
 564:	48e1                	li	a7,24
 ecall
 566:	00000073          	ecall
 ret
 56a:	8082                	ret

000000000000056c <thread_exit>:
.global thread_exit
thread_exit:
 li a7, SYS_thread_exit
 56c:	48e5                	li	a7,25
 ecall
 56e:	00000073          	ecall
 ret
 572:	8082                	ret

0000000000000574 <socket>:
.global socket
socket:
 li a7, SYS_socket
 574:	48e9                	li	a7,26
 ecall
 576:	00000073          	ecall
 ret
 57a:	8082                	ret

000000000000057c <bind>:
.global bind
bind:
 li a7, SYS_bind
 57c:	48ed                	li	a7,27
 ecall
 57e:	00000073          	ecall
 ret
 582:	8082                	ret

0000000000000584 <accept>:
.global accept
accept:
 li a7, SYS_accept
 584:	48f5                	li	a7,29
 ecall
 586:	00000073          	ecall
 ret
 58a:	8082                	ret

000000000000058c <listen>:
.global listen
listen:
 li a7, SYS_listen
 58c:	48f1                	li	a7,28
 ecall
 58e:	00000073          	ecall
 ret
 592:	8082                	ret

0000000000000594 <connect>:
.global connect
connect:
 li a7, SYS_connect
 594:	48f9                	li	a7,30
 ecall
 596:	00000073          	ecall
 ret
 59a:	8082                	ret

000000000000059c <send>:
.global send
send:
 li a7, SYS_send
 59c:	48fd                	li	a7,31
 ecall
 59e:	00000073          	ecall
 ret
 5a2:	8082                	ret

00000000000005a4 <recv>:
.global recv
recv:
 li a7, SYS_recv
 5a4:	02000893          	li	a7,32
 ecall
 5a8:	00000073          	ecall
 ret
 5ac:	8082                	ret

00000000000005ae <sendto>:
.global sendto
sendto:
 li a7, SYS_sendto
 5ae:	02100893          	li	a7,33
 ecall
 5b2:	00000073          	ecall
 ret
 5b6:	8082                	ret

00000000000005b8 <recvfrom>:
.global recvfrom
recvfrom:
 li a7, SYS_recvfrom
 5b8:	02200893          	li	a7,34
 ecall
 5bc:	00000073          	ecall
 ret
 5c0:	8082                	ret

00000000000005c2 <putc>:

static char digits[] = "0123456789ABCDEF";

static void
putc(int fd, char c)
{
 5c2:	1101                	addi	sp,sp,-32
 5c4:	ec06                	sd	ra,24(sp)
 5c6:	e822                	sd	s0,16(sp)
 5c8:	1000                	addi	s0,sp,32
 5ca:	feb407a3          	sb	a1,-17(s0)
  write(fd, &c, 1);
 5ce:	4605                	li	a2,1
 5d0:	fef40593          	addi	a1,s0,-17
 5d4:	00000097          	auipc	ra,0x0
 5d8:	f00080e7          	jalr	-256(ra) # 4d4 <write>
}
 5dc:	60e2                	ld	ra,24(sp)
 5de:	6442                	ld	s0,16(sp)
 5e0:	6105                	addi	sp,sp,32
 5e2:	8082                	ret

00000000000005e4 <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
 5e4:	7139                	addi	sp,sp,-64
 5e6:	fc06                	sd	ra,56(sp)
 5e8:	f822                	sd	s0,48(sp)
 5ea:	f426                	sd	s1,40(sp)
 5ec:	0080                	addi	s0,sp,64
 5ee:	84aa                	mv	s1,a0
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
  if(sgn && xx < 0){
 5f0:	c299                	beqz	a3,5f6 <printint+0x12>
 5f2:	0805cb63          	bltz	a1,688 <printint+0xa4>
    neg = 1;
    x = -xx;
  } else {
    x = xx;
 5f6:	2581                	sext.w	a1,a1
  neg = 0;
 5f8:	4881                	li	a7,0
 5fa:	fc040693          	addi	a3,s0,-64
  }

  i = 0;
 5fe:	4701                	li	a4,0
  do{
    buf[i++] = digits[x % base];
 600:	2601                	sext.w	a2,a2
 602:	00000517          	auipc	a0,0x0
 606:	77650513          	addi	a0,a0,1910 # d78 <digits>
 60a:	883a                	mv	a6,a4
 60c:	2705                	addiw	a4,a4,1
 60e:	02c5f7bb          	remuw	a5,a1,a2
 612:	1782                	slli	a5,a5,0x20
 614:	9381                	srli	a5,a5,0x20
 616:	97aa                	add	a5,a5,a0
 618:	0007c783          	lbu	a5,0(a5)
 61c:	00f68023          	sb	a5,0(a3)
  }while((x /= base) != 0);
 620:	0005879b          	sext.w	a5,a1
 624:	02c5d5bb          	divuw	a1,a1,a2
 628:	0685                	addi	a3,a3,1
 62a:	fec7f0e3          	bgeu	a5,a2,60a <printint+0x26>
  if(neg)
 62e:	00088c63          	beqz	a7,646 <printint+0x62>
    buf[i++] = '-';
 632:	fd070793          	addi	a5,a4,-48
 636:	00878733          	add	a4,a5,s0
 63a:	02d00793          	li	a5,45
 63e:	fef70823          	sb	a5,-16(a4)
 642:	0028071b          	addiw	a4,a6,2

  while(--i >= 0)
 646:	02e05c63          	blez	a4,67e <printint+0x9a>
 64a:	f04a                	sd	s2,32(sp)
 64c:	ec4e                	sd	s3,24(sp)
 64e:	fc040793          	addi	a5,s0,-64
 652:	00e78933          	add	s2,a5,a4
 656:	fff78993          	addi	s3,a5,-1
 65a:	99ba                	add	s3,s3,a4
 65c:	377d                	addiw	a4,a4,-1
 65e:	1702                	slli	a4,a4,0x20
 660:	9301                	srli	a4,a4,0x20
 662:	40e989b3          	sub	s3,s3,a4
    putc(fd, buf[i]);
 666:	fff94583          	lbu	a1,-1(s2)
 66a:	8526                	mv	a0,s1
 66c:	00000097          	auipc	ra,0x0
 670:	f56080e7          	jalr	-170(ra) # 5c2 <putc>
  while(--i >= 0)
 674:	197d                	addi	s2,s2,-1
 676:	ff3918e3          	bne	s2,s3,666 <printint+0x82>
 67a:	7902                	ld	s2,32(sp)
 67c:	69e2                	ld	s3,24(sp)
}
 67e:	70e2                	ld	ra,56(sp)
 680:	7442                	ld	s0,48(sp)
 682:	74a2                	ld	s1,40(sp)
 684:	6121                	addi	sp,sp,64
 686:	8082                	ret
    x = -xx;
 688:	40b005bb          	negw	a1,a1
    neg = 1;
 68c:	4885                	li	a7,1
    x = -xx;
 68e:	b7b5                	j	5fa <printint+0x16>

0000000000000690 <vprintf>:
}

// Print to the given fd. Only understands %d, %x, %p, %s.
void
vprintf(int fd, const char *fmt, va_list ap)
{
 690:	715d                	addi	sp,sp,-80
 692:	e486                	sd	ra,72(sp)
 694:	e0a2                	sd	s0,64(sp)
 696:	f84a                	sd	s2,48(sp)
 698:	0880                	addi	s0,sp,80
  char *s;
  int c, i, state;

  state = 0;
  for(i = 0; fmt[i]; i++){
 69a:	0005c903          	lbu	s2,0(a1)
 69e:	1a090a63          	beqz	s2,852 <vprintf+0x1c2>
 6a2:	fc26                	sd	s1,56(sp)
 6a4:	f44e                	sd	s3,40(sp)
 6a6:	f052                	sd	s4,32(sp)
 6a8:	ec56                	sd	s5,24(sp)
 6aa:	e85a                	sd	s6,16(sp)
 6ac:	e45e                	sd	s7,8(sp)
 6ae:	8aaa                	mv	s5,a0
 6b0:	8bb2                	mv	s7,a2
 6b2:	00158493          	addi	s1,a1,1
  state = 0;
 6b6:	4981                	li	s3,0
      if(c == '%'){
        state = '%';
      } else {
        putc(fd, c);
      }
    } else if(state == '%'){
 6b8:	02500a13          	li	s4,37
 6bc:	4b55                	li	s6,21
 6be:	a839                	j	6dc <vprintf+0x4c>
        putc(fd, c);
 6c0:	85ca                	mv	a1,s2
 6c2:	8556                	mv	a0,s5
 6c4:	00000097          	auipc	ra,0x0
 6c8:	efe080e7          	jalr	-258(ra) # 5c2 <putc>
 6cc:	a019                	j	6d2 <vprintf+0x42>
    } else if(state == '%'){
 6ce:	01498d63          	beq	s3,s4,6e8 <vprintf+0x58>
  for(i = 0; fmt[i]; i++){
 6d2:	0485                	addi	s1,s1,1
 6d4:	fff4c903          	lbu	s2,-1(s1)
 6d8:	16090763          	beqz	s2,846 <vprintf+0x1b6>
    if(state == 0){
 6dc:	fe0999e3          	bnez	s3,6ce <vprintf+0x3e>
      if(c == '%'){
 6e0:	ff4910e3          	bne	s2,s4,6c0 <vprintf+0x30>
        state = '%';
 6e4:	89d2                	mv	s3,s4
 6e6:	b7f5                	j	6d2 <vprintf+0x42>
      if(c == 'd'){
 6e8:	13490463          	beq	s2,s4,810 <vprintf+0x180>
 6ec:	f9d9079b          	addiw	a5,s2,-99
 6f0:	0ff7f793          	zext.b	a5,a5
 6f4:	12fb6763          	bltu	s6,a5,822 <vprintf+0x192>
 6f8:	f9d9079b          	addiw	a5,s2,-99
 6fc:	0ff7f713          	zext.b	a4,a5
 700:	12eb6163          	bltu	s6,a4,822 <vprintf+0x192>
 704:	00271793          	slli	a5,a4,0x2
 708:	00000717          	auipc	a4,0x0
 70c:	61870713          	addi	a4,a4,1560 # d20 <ithread_join+0xd8>
 710:	97ba                	add	a5,a5,a4
 712:	439c                	lw	a5,0(a5)
 714:	97ba                	add	a5,a5,a4
 716:	8782                	jr	a5
        printint(fd, va_arg(ap, int), 10, 1);
 718:	008b8913          	addi	s2,s7,8
 71c:	4685                	li	a3,1
 71e:	4629                	li	a2,10
 720:	000ba583          	lw	a1,0(s7)
 724:	8556                	mv	a0,s5
 726:	00000097          	auipc	ra,0x0
 72a:	ebe080e7          	jalr	-322(ra) # 5e4 <printint>
 72e:	8bca                	mv	s7,s2
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
        putc(fd, c);
      }
      state = 0;
 730:	4981                	li	s3,0
 732:	b745                	j	6d2 <vprintf+0x42>
        printint(fd, va_arg(ap, uint64), 10, 0);
 734:	008b8913          	addi	s2,s7,8
 738:	4681                	li	a3,0
 73a:	4629                	li	a2,10
 73c:	000ba583          	lw	a1,0(s7)
 740:	8556                	mv	a0,s5
 742:	00000097          	auipc	ra,0x0
 746:	ea2080e7          	jalr	-350(ra) # 5e4 <printint>
 74a:	8bca                	mv	s7,s2
      state = 0;
 74c:	4981                	li	s3,0
 74e:	b751                	j	6d2 <vprintf+0x42>
        printint(fd, va_arg(ap, int), 16, 0);
 750:	008b8913          	addi	s2,s7,8
 754:	4681                	li	a3,0
 756:	4641                	li	a2,16
 758:	000ba583          	lw	a1,0(s7)
 75c:	8556                	mv	a0,s5
 75e:	00000097          	auipc	ra,0x0
 762:	e86080e7          	jalr	-378(ra) # 5e4 <printint>
 766:	8bca                	mv	s7,s2
      state = 0;
 768:	4981                	li	s3,0
 76a:	b7a5                	j	6d2 <vprintf+0x42>
 76c:	e062                	sd	s8,0(sp)
        printptr(fd, va_arg(ap, uint64));
 76e:	008b8c13          	addi	s8,s7,8
 772:	000bb983          	ld	s3,0(s7)
  putc(fd, '0');
 776:	03000593          	li	a1,48
 77a:	8556                	mv	a0,s5
 77c:	00000097          	auipc	ra,0x0
 780:	e46080e7          	jalr	-442(ra) # 5c2 <putc>
  putc(fd, 'x');
 784:	07800593          	li	a1,120
 788:	8556                	mv	a0,s5
 78a:	00000097          	auipc	ra,0x0
 78e:	e38080e7          	jalr	-456(ra) # 5c2 <putc>
 792:	4941                	li	s2,16
    putc(fd, digits[x >> (sizeof(uint64) * 8 - 4)]);
 794:	00000b97          	auipc	s7,0x0
 798:	5e4b8b93          	addi	s7,s7,1508 # d78 <digits>
 79c:	03c9d793          	srli	a5,s3,0x3c
 7a0:	97de                	add	a5,a5,s7
 7a2:	0007c583          	lbu	a1,0(a5)
 7a6:	8556                	mv	a0,s5
 7a8:	00000097          	auipc	ra,0x0
 7ac:	e1a080e7          	jalr	-486(ra) # 5c2 <putc>
  for (i = 0; i < (sizeof(uint64) * 2); i++, x <<= 4)
 7b0:	0992                	slli	s3,s3,0x4
 7b2:	397d                	addiw	s2,s2,-1
 7b4:	fe0914e3          	bnez	s2,79c <vprintf+0x10c>
        printptr(fd, va_arg(ap, uint64));
 7b8:	8be2                	mv	s7,s8
      state = 0;
 7ba:	4981                	li	s3,0
 7bc:	6c02                	ld	s8,0(sp)
 7be:	bf11                	j	6d2 <vprintf+0x42>
        s = va_arg(ap, char*);
 7c0:	008b8993          	addi	s3,s7,8
 7c4:	000bb903          	ld	s2,0(s7)
        if(s == 0)
 7c8:	02090163          	beqz	s2,7ea <vprintf+0x15a>
        while(*s != 0){
 7cc:	00094583          	lbu	a1,0(s2)
 7d0:	c9a5                	beqz	a1,840 <vprintf+0x1b0>
          putc(fd, *s);
 7d2:	8556                	mv	a0,s5
 7d4:	00000097          	auipc	ra,0x0
 7d8:	dee080e7          	jalr	-530(ra) # 5c2 <putc>
          s++;
 7dc:	0905                	addi	s2,s2,1
        while(*s != 0){
 7de:	00094583          	lbu	a1,0(s2)
 7e2:	f9e5                	bnez	a1,7d2 <vprintf+0x142>
        s = va_arg(ap, char*);
 7e4:	8bce                	mv	s7,s3
      state = 0;
 7e6:	4981                	li	s3,0
 7e8:	b5ed                	j	6d2 <vprintf+0x42>
          s = "(null)";
 7ea:	00000917          	auipc	s2,0x0
 7ee:	4fe90913          	addi	s2,s2,1278 # ce8 <ithread_join+0xa0>
        while(*s != 0){
 7f2:	02800593          	li	a1,40
 7f6:	bff1                	j	7d2 <vprintf+0x142>
        putc(fd, va_arg(ap, uint));
 7f8:	008b8913          	addi	s2,s7,8
 7fc:	000bc583          	lbu	a1,0(s7)
 800:	8556                	mv	a0,s5
 802:	00000097          	auipc	ra,0x0
 806:	dc0080e7          	jalr	-576(ra) # 5c2 <putc>
 80a:	8bca                	mv	s7,s2
      state = 0;
 80c:	4981                	li	s3,0
 80e:	b5d1                	j	6d2 <vprintf+0x42>
        putc(fd, c);
 810:	02500593          	li	a1,37
 814:	8556                	mv	a0,s5
 816:	00000097          	auipc	ra,0x0
 81a:	dac080e7          	jalr	-596(ra) # 5c2 <putc>
      state = 0;
 81e:	4981                	li	s3,0
 820:	bd4d                	j	6d2 <vprintf+0x42>
        putc(fd, '%');
 822:	02500593          	li	a1,37
 826:	8556                	mv	a0,s5
 828:	00000097          	auipc	ra,0x0
 82c:	d9a080e7          	jalr	-614(ra) # 5c2 <putc>
        putc(fd, c);
 830:	85ca                	mv	a1,s2
 832:	8556                	mv	a0,s5
 834:	00000097          	auipc	ra,0x0
 838:	d8e080e7          	jalr	-626(ra) # 5c2 <putc>
      state = 0;
 83c:	4981                	li	s3,0
 83e:	bd51                	j	6d2 <vprintf+0x42>
        s = va_arg(ap, char*);
 840:	8bce                	mv	s7,s3
      state = 0;
 842:	4981                	li	s3,0
 844:	b579                	j	6d2 <vprintf+0x42>
 846:	74e2                	ld	s1,56(sp)
 848:	79a2                	ld	s3,40(sp)
 84a:	7a02                	ld	s4,32(sp)
 84c:	6ae2                	ld	s5,24(sp)
 84e:	6b42                	ld	s6,16(sp)
 850:	6ba2                	ld	s7,8(sp)
    }
  }
}
 852:	60a6                	ld	ra,72(sp)
 854:	6406                	ld	s0,64(sp)
 856:	7942                	ld	s2,48(sp)
 858:	6161                	addi	sp,sp,80
 85a:	8082                	ret

000000000000085c <fprintf>:

void
fprintf(int fd, const char *fmt, ...)
{
 85c:	715d                	addi	sp,sp,-80
 85e:	ec06                	sd	ra,24(sp)
 860:	e822                	sd	s0,16(sp)
 862:	1000                	addi	s0,sp,32
 864:	e010                	sd	a2,0(s0)
 866:	e414                	sd	a3,8(s0)
 868:	e818                	sd	a4,16(s0)
 86a:	ec1c                	sd	a5,24(s0)
 86c:	03043023          	sd	a6,32(s0)
 870:	03143423          	sd	a7,40(s0)
  va_list ap;

  va_start(ap, fmt);
 874:	fe843423          	sd	s0,-24(s0)
  vprintf(fd, fmt, ap);
 878:	8622                	mv	a2,s0
 87a:	00000097          	auipc	ra,0x0
 87e:	e16080e7          	jalr	-490(ra) # 690 <vprintf>
}
 882:	60e2                	ld	ra,24(sp)
 884:	6442                	ld	s0,16(sp)
 886:	6161                	addi	sp,sp,80
 888:	8082                	ret

000000000000088a <printf>:

void
printf(const char *fmt, ...)
{
 88a:	711d                	addi	sp,sp,-96
 88c:	ec06                	sd	ra,24(sp)
 88e:	e822                	sd	s0,16(sp)
 890:	1000                	addi	s0,sp,32
 892:	e40c                	sd	a1,8(s0)
 894:	e810                	sd	a2,16(s0)
 896:	ec14                	sd	a3,24(s0)
 898:	f018                	sd	a4,32(s0)
 89a:	f41c                	sd	a5,40(s0)
 89c:	03043823          	sd	a6,48(s0)
 8a0:	03143c23          	sd	a7,56(s0)
  va_list ap;

  va_start(ap, fmt);
 8a4:	00840613          	addi	a2,s0,8
 8a8:	fec43423          	sd	a2,-24(s0)
  vprintf(1, fmt, ap);
 8ac:	85aa                	mv	a1,a0
 8ae:	4505                	li	a0,1
 8b0:	00000097          	auipc	ra,0x0
 8b4:	de0080e7          	jalr	-544(ra) # 690 <vprintf>
}
 8b8:	60e2                	ld	ra,24(sp)
 8ba:	6442                	ld	s0,16(sp)
 8bc:	6125                	addi	sp,sp,96
 8be:	8082                	ret

00000000000008c0 <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 8c0:	1141                	addi	sp,sp,-16
 8c2:	e422                	sd	s0,8(sp)
 8c4:	0800                	addi	s0,sp,16
  Header *bp, *p;

  bp = (Header*)ap - 1;
 8c6:	ff050693          	addi	a3,a0,-16
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 8ca:	00000797          	auipc	a5,0x0
 8ce:	7467b783          	ld	a5,1862(a5) # 1010 <freep>
 8d2:	a02d                	j	8fc <free+0x3c>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
      break;
  if(bp + bp->s.size == p->s.ptr){
    bp->s.size += p->s.ptr->s.size;
 8d4:	4618                	lw	a4,8(a2)
 8d6:	9f2d                	addw	a4,a4,a1
 8d8:	fee52c23          	sw	a4,-8(a0)
    bp->s.ptr = p->s.ptr->s.ptr;
 8dc:	6398                	ld	a4,0(a5)
 8de:	6310                	ld	a2,0(a4)
 8e0:	a83d                	j	91e <free+0x5e>
  } else
    bp->s.ptr = p->s.ptr;
  if(p + p->s.size == bp){
    p->s.size += bp->s.size;
 8e2:	ff852703          	lw	a4,-8(a0)
 8e6:	9f31                	addw	a4,a4,a2
 8e8:	c798                	sw	a4,8(a5)
    p->s.ptr = bp->s.ptr;
 8ea:	ff053683          	ld	a3,-16(a0)
 8ee:	a091                	j	932 <free+0x72>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 8f0:	6398                	ld	a4,0(a5)
 8f2:	00e7e463          	bltu	a5,a4,8fa <free+0x3a>
 8f6:	00e6ea63          	bltu	a3,a4,90a <free+0x4a>
{
 8fa:	87ba                	mv	a5,a4
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 8fc:	fed7fae3          	bgeu	a5,a3,8f0 <free+0x30>
 900:	6398                	ld	a4,0(a5)
 902:	00e6e463          	bltu	a3,a4,90a <free+0x4a>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 906:	fee7eae3          	bltu	a5,a4,8fa <free+0x3a>
  if(bp + bp->s.size == p->s.ptr){
 90a:	ff852583          	lw	a1,-8(a0)
 90e:	6390                	ld	a2,0(a5)
 910:	02059813          	slli	a6,a1,0x20
 914:	01c85713          	srli	a4,a6,0x1c
 918:	9736                	add	a4,a4,a3
 91a:	fae60de3          	beq	a2,a4,8d4 <free+0x14>
    bp->s.ptr = p->s.ptr->s.ptr;
 91e:	fec53823          	sd	a2,-16(a0)
  if(p + p->s.size == bp){
 922:	4790                	lw	a2,8(a5)
 924:	02061593          	slli	a1,a2,0x20
 928:	01c5d713          	srli	a4,a1,0x1c
 92c:	973e                	add	a4,a4,a5
 92e:	fae68ae3          	beq	a3,a4,8e2 <free+0x22>
    p->s.ptr = bp->s.ptr;
 932:	e394                	sd	a3,0(a5)
  } else
    p->s.ptr = bp;
  freep = p;
 934:	00000717          	auipc	a4,0x0
 938:	6cf73e23          	sd	a5,1756(a4) # 1010 <freep>
}
 93c:	6422                	ld	s0,8(sp)
 93e:	0141                	addi	sp,sp,16
 940:	8082                	ret

0000000000000942 <malloc>:
  return freep;
}

void*
malloc(uint nbytes)
{
 942:	7139                	addi	sp,sp,-64
 944:	fc06                	sd	ra,56(sp)
 946:	f822                	sd	s0,48(sp)
 948:	f426                	sd	s1,40(sp)
 94a:	ec4e                	sd	s3,24(sp)
 94c:	0080                	addi	s0,sp,64
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 94e:	02051493          	slli	s1,a0,0x20
 952:	9081                	srli	s1,s1,0x20
 954:	04bd                	addi	s1,s1,15
 956:	8091                	srli	s1,s1,0x4
 958:	0014899b          	addiw	s3,s1,1
 95c:	0485                	addi	s1,s1,1
  if((prevp = freep) == 0){
 95e:	00000517          	auipc	a0,0x0
 962:	6b253503          	ld	a0,1714(a0) # 1010 <freep>
 966:	c915                	beqz	a0,99a <malloc+0x58>
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 968:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
 96a:	4798                	lw	a4,8(a5)
 96c:	08977e63          	bgeu	a4,s1,a08 <malloc+0xc6>
 970:	f04a                	sd	s2,32(sp)
 972:	e852                	sd	s4,16(sp)
 974:	e456                	sd	s5,8(sp)
 976:	e05a                	sd	s6,0(sp)
  if(nu < 4096)
 978:	8a4e                	mv	s4,s3
 97a:	0009871b          	sext.w	a4,s3
 97e:	6685                	lui	a3,0x1
 980:	00d77363          	bgeu	a4,a3,986 <malloc+0x44>
 984:	6a05                	lui	s4,0x1
 986:	000a0b1b          	sext.w	s6,s4
  p = sbrk(nu * sizeof(Header));
 98a:	004a1a1b          	slliw	s4,s4,0x4
        p->s.size = nunits;
      }
      freep = prevp;
      return (void*)(p + 1);
    }
    if(p == freep)
 98e:	00000917          	auipc	s2,0x0
 992:	68290913          	addi	s2,s2,1666 # 1010 <freep>
  if(p == (char*)-1)
 996:	5afd                	li	s5,-1
 998:	a091                	j	9dc <malloc+0x9a>
 99a:	f04a                	sd	s2,32(sp)
 99c:	e852                	sd	s4,16(sp)
 99e:	e456                	sd	s5,8(sp)
 9a0:	e05a                	sd	s6,0(sp)
    base.s.ptr = freep = prevp = &base;
 9a2:	00001797          	auipc	a5,0x1
 9a6:	88e78793          	addi	a5,a5,-1906 # 1230 <base>
 9aa:	00000717          	auipc	a4,0x0
 9ae:	66f73323          	sd	a5,1638(a4) # 1010 <freep>
 9b2:	e39c                	sd	a5,0(a5)
    base.s.size = 0;
 9b4:	0007a423          	sw	zero,8(a5)
    if(p->s.size >= nunits){
 9b8:	b7c1                	j	978 <malloc+0x36>
        prevp->s.ptr = p->s.ptr;
 9ba:	6398                	ld	a4,0(a5)
 9bc:	e118                	sd	a4,0(a0)
 9be:	a08d                	j	a20 <malloc+0xde>
  hp->s.size = nu;
 9c0:	01652423          	sw	s6,8(a0)
  free((void*)(hp + 1));
 9c4:	0541                	addi	a0,a0,16
 9c6:	00000097          	auipc	ra,0x0
 9ca:	efa080e7          	jalr	-262(ra) # 8c0 <free>
  return freep;
 9ce:	00093503          	ld	a0,0(s2)
      if((p = morecore(nunits)) == 0)
 9d2:	c13d                	beqz	a0,a38 <malloc+0xf6>
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 9d4:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
 9d6:	4798                	lw	a4,8(a5)
 9d8:	02977463          	bgeu	a4,s1,a00 <malloc+0xbe>
    if(p == freep)
 9dc:	00093703          	ld	a4,0(s2)
 9e0:	853e                	mv	a0,a5
 9e2:	fef719e3          	bne	a4,a5,9d4 <malloc+0x92>
  p = sbrk(nu * sizeof(Header));
 9e6:	8552                	mv	a0,s4
 9e8:	00000097          	auipc	ra,0x0
 9ec:	b54080e7          	jalr	-1196(ra) # 53c <sbrk>
  if(p == (char*)-1)
 9f0:	fd5518e3          	bne	a0,s5,9c0 <malloc+0x7e>
        return 0;
 9f4:	4501                	li	a0,0
 9f6:	7902                	ld	s2,32(sp)
 9f8:	6a42                	ld	s4,16(sp)
 9fa:	6aa2                	ld	s5,8(sp)
 9fc:	6b02                	ld	s6,0(sp)
 9fe:	a03d                	j	a2c <malloc+0xea>
 a00:	7902                	ld	s2,32(sp)
 a02:	6a42                	ld	s4,16(sp)
 a04:	6aa2                	ld	s5,8(sp)
 a06:	6b02                	ld	s6,0(sp)
      if(p->s.size == nunits)
 a08:	fae489e3          	beq	s1,a4,9ba <malloc+0x78>
        p->s.size -= nunits;
 a0c:	4137073b          	subw	a4,a4,s3
 a10:	c798                	sw	a4,8(a5)
        p += p->s.size;
 a12:	02071693          	slli	a3,a4,0x20
 a16:	01c6d713          	srli	a4,a3,0x1c
 a1a:	97ba                	add	a5,a5,a4
        p->s.size = nunits;
 a1c:	0137a423          	sw	s3,8(a5)
      freep = prevp;
 a20:	00000717          	auipc	a4,0x0
 a24:	5ea73823          	sd	a0,1520(a4) # 1010 <freep>
      return (void*)(p + 1);
 a28:	01078513          	addi	a0,a5,16
  }
}
 a2c:	70e2                	ld	ra,56(sp)
 a2e:	7442                	ld	s0,48(sp)
 a30:	74a2                	ld	s1,40(sp)
 a32:	69e2                	ld	s3,24(sp)
 a34:	6121                	addi	sp,sp,64
 a36:	8082                	ret
 a38:	7902                	ld	s2,32(sp)
 a3a:	6a42                	ld	s4,16(sp)
 a3c:	6aa2                	ld	s5,8(sp)
 a3e:	6b02                	ld	s6,0(sp)
 a40:	b7f5                	j	a2c <malloc+0xea>

0000000000000a42 <ithread_exit>:
  free(stacks);
  stacks = new_stacks;
  return 0;
}

void ithread_exit(uint64 status) {
 a42:	1141                	addi	sp,sp,-16
 a44:	e406                	sd	ra,8(sp)
 a46:	e022                	sd	s0,0(sp)
 a48:	0800                	addi	s0,sp,16
  thread_exit(status);
 a4a:	2501                	sext.w	a0,a0
 a4c:	00000097          	auipc	ra,0x0
 a50:	b20080e7          	jalr	-1248(ra) # 56c <thread_exit>
}
 a54:	60a2                	ld	ra,8(sp)
 a56:	6402                	ld	s0,0(sp)
 a58:	0141                	addi	sp,sp,16
 a5a:	8082                	ret

0000000000000a5c <free_stacks>:
int free_stacks() {
 a5c:	7179                	addi	sp,sp,-48
 a5e:	f406                	sd	ra,40(sp)
 a60:	f022                	sd	s0,32(sp)
 a62:	ec26                	sd	s1,24(sp)
 a64:	1800                	addi	s0,sp,48
  for (int i = 0; i < num_threads; i++) {
 a66:	00000797          	auipc	a5,0x0
 a6a:	5ba7a783          	lw	a5,1466(a5) # 1020 <num_threads>
 a6e:	04f05063          	blez	a5,aae <free_stacks+0x52>
 a72:	e84a                	sd	s2,16(sp)
 a74:	e44e                	sd	s3,8(sp)
 a76:	4481                	li	s1,0
    free(stacks[i]);
 a78:	00000997          	auipc	s3,0x0
 a7c:	5a098993          	addi	s3,s3,1440 # 1018 <stacks>
  for (int i = 0; i < num_threads; i++) {
 a80:	00000917          	auipc	s2,0x0
 a84:	5a090913          	addi	s2,s2,1440 # 1020 <num_threads>
    free(stacks[i]);
 a88:	0009b783          	ld	a5,0(s3)
 a8c:	00349713          	slli	a4,s1,0x3
 a90:	97ba                	add	a5,a5,a4
 a92:	6388                	ld	a0,0(a5)
 a94:	00000097          	auipc	ra,0x0
 a98:	e2c080e7          	jalr	-468(ra) # 8c0 <free>
  for (int i = 0; i < num_threads; i++) {
 a9c:	0485                	addi	s1,s1,1
 a9e:	00092703          	lw	a4,0(s2)
 aa2:	0004879b          	sext.w	a5,s1
 aa6:	fee7c1e3          	blt	a5,a4,a88 <free_stacks+0x2c>
 aaa:	6942                	ld	s2,16(sp)
 aac:	69a2                	ld	s3,8(sp)
  free(stacks);
 aae:	00000497          	auipc	s1,0x0
 ab2:	56a48493          	addi	s1,s1,1386 # 1018 <stacks>
 ab6:	6088                	ld	a0,0(s1)
 ab8:	00000097          	auipc	ra,0x0
 abc:	e08080e7          	jalr	-504(ra) # 8c0 <free>
  stacks = 0;
 ac0:	0004b023          	sd	zero,0(s1)
  num_threads = 0;
 ac4:	00000797          	auipc	a5,0x0
 ac8:	5407ae23          	sw	zero,1372(a5) # 1020 <num_threads>
  max_stacks = INIT_MAX_STACKS;
 acc:	47a1                	li	a5,8
 ace:	00000717          	auipc	a4,0x0
 ad2:	52f72923          	sw	a5,1330(a4) # 1000 <max_stacks>
  threads_done = 0;
 ad6:	00000797          	auipc	a5,0x0
 ada:	5407a723          	sw	zero,1358(a5) # 1024 <threads_done>
}
 ade:	4501                	li	a0,0
 ae0:	70a2                	ld	ra,40(sp)
 ae2:	7402                	ld	s0,32(sp)
 ae4:	64e2                	ld	s1,24(sp)
 ae6:	6145                	addi	sp,sp,48
 ae8:	8082                	ret

0000000000000aea <expand_num_threads>:
int expand_num_threads() {
 aea:	1101                	addi	sp,sp,-32
 aec:	ec06                	sd	ra,24(sp)
 aee:	e822                	sd	s0,16(sp)
 af0:	e426                	sd	s1,8(sp)
 af2:	e04a                	sd	s2,0(sp)
 af4:	1000                	addi	s0,sp,32
  max_stacks *= 2;
 af6:	00000797          	auipc	a5,0x0
 afa:	50a78793          	addi	a5,a5,1290 # 1000 <max_stacks>
 afe:	4388                	lw	a0,0(a5)
 b00:	0015151b          	slliw	a0,a0,0x1
 b04:	c388                	sw	a0,0(a5)
  void **new_stacks = malloc(max_stacks*sizeof(char*));
 b06:	0035151b          	slliw	a0,a0,0x3
 b0a:	00000097          	auipc	ra,0x0
 b0e:	e38080e7          	jalr	-456(ra) # 942 <malloc>
 b12:	892a                	mv	s2,a0
  memmove(new_stacks, stacks, num_threads*sizeof(char*));
 b14:	00000617          	auipc	a2,0x0
 b18:	50c62603          	lw	a2,1292(a2) # 1020 <num_threads>
 b1c:	00000497          	auipc	s1,0x0
 b20:	4fc48493          	addi	s1,s1,1276 # 1018 <stacks>
 b24:	0036161b          	slliw	a2,a2,0x3
 b28:	608c                	ld	a1,0(s1)
 b2a:	00000097          	auipc	ra,0x0
 b2e:	840080e7          	jalr	-1984(ra) # 36a <memmove>
  free(stacks);
 b32:	6088                	ld	a0,0(s1)
 b34:	00000097          	auipc	ra,0x0
 b38:	d8c080e7          	jalr	-628(ra) # 8c0 <free>
  stacks = new_stacks;
 b3c:	0124b023          	sd	s2,0(s1)
}
 b40:	4501                	li	a0,0
 b42:	60e2                	ld	ra,24(sp)
 b44:	6442                	ld	s0,16(sp)
 b46:	64a2                	ld	s1,8(sp)
 b48:	6902                	ld	s2,0(sp)
 b4a:	6105                	addi	sp,sp,32
 b4c:	8082                	ret

0000000000000b4e <ithread_create>:

int ithread_create(void* (*fn_ptr)(void *), void *args) {
 b4e:	7179                	addi	sp,sp,-48
 b50:	f406                	sd	ra,40(sp)
 b52:	f022                	sd	s0,32(sp)
 b54:	e84a                	sd	s2,16(sp)
 b56:	e44e                	sd	s3,8(sp)
 b58:	1800                	addi	s0,sp,48
 b5a:	892a                	mv	s2,a0
 b5c:	89ae                	mv	s3,a1
  if (stacks == 0) {
 b5e:	00000797          	auipc	a5,0x0
 b62:	4ba7b783          	ld	a5,1210(a5) # 1018 <stacks>
 b66:	c3d9                	beqz	a5,bec <ithread_create+0x9e>
    stacks = malloc(max_stacks*sizeof(char*));
  }
  if (num_threads == max_stacks) {
 b68:	00000797          	auipc	a5,0x0
 b6c:	4987a783          	lw	a5,1176(a5) # 1000 <max_stacks>
 b70:	00000717          	auipc	a4,0x0
 b74:	4b072703          	lw	a4,1200(a4) # 1020 <num_threads>
 b78:	0af71363          	bne	a4,a5,c1e <ithread_create+0xd0>
    if (max_stacks == MAX_THREADS) {
 b7c:	04000713          	li	a4,64
 b80:	08e78563          	beq	a5,a4,c0a <ithread_create+0xbc>
 b84:	ec26                	sd	s1,24(sp)
      printf("ERROR: Thread capacity has been reached\n");
      return -1;
    }
    expand_num_threads();
 b86:	00000097          	auipc	ra,0x0
 b8a:	f64080e7          	jalr	-156(ra) # aea <expand_num_threads>
  }

  void *stack_ptr = malloc(PGSIZE);
 b8e:	6505                	lui	a0,0x1
 b90:	00000097          	auipc	ra,0x0
 b94:	db2080e7          	jalr	-590(ra) # 942 <malloc>
 b98:	84aa                	mv	s1,a0
  stacks[num_threads] = stack_ptr;
 b9a:	00000717          	auipc	a4,0x0
 b9e:	48672703          	lw	a4,1158(a4) # 1020 <num_threads>
 ba2:	070e                	slli	a4,a4,0x3
 ba4:	00000797          	auipc	a5,0x0
 ba8:	4747b783          	ld	a5,1140(a5) # 1018 <stacks>
 bac:	97ba                	add	a5,a5,a4
 bae:	e388                	sd	a0,0(a5)
  int res = create_thread(fn_ptr, args, stack_ptr, &ithread_exit);
 bb0:	00000697          	auipc	a3,0x0
 bb4:	e9268693          	addi	a3,a3,-366 # a42 <ithread_exit>
 bb8:	862a                	mv	a2,a0
 bba:	85ce                	mv	a1,s3
 bbc:	854a                	mv	a0,s2
 bbe:	00000097          	auipc	ra,0x0
 bc2:	99e080e7          	jalr	-1634(ra) # 55c <create_thread>
 bc6:	892a                	mv	s2,a0
  if (res != -1) {
 bc8:	57fd                	li	a5,-1
 bca:	04f50c63          	beq	a0,a5,c22 <ithread_create+0xd4>
    num_threads++;
 bce:	00000717          	auipc	a4,0x0
 bd2:	45270713          	addi	a4,a4,1106 # 1020 <num_threads>
 bd6:	431c                	lw	a5,0(a4)
 bd8:	2785                	addiw	a5,a5,1
 bda:	c31c                	sw	a5,0(a4)
 bdc:	64e2                	ld	s1,24(sp)
  } else {
    free(stack_ptr);
    stacks[num_threads] = 0;
  }
  return res;
}
 bde:	854a                	mv	a0,s2
 be0:	70a2                	ld	ra,40(sp)
 be2:	7402                	ld	s0,32(sp)
 be4:	6942                	ld	s2,16(sp)
 be6:	69a2                	ld	s3,8(sp)
 be8:	6145                	addi	sp,sp,48
 bea:	8082                	ret
    stacks = malloc(max_stacks*sizeof(char*));
 bec:	00000517          	auipc	a0,0x0
 bf0:	41452503          	lw	a0,1044(a0) # 1000 <max_stacks>
 bf4:	0035151b          	slliw	a0,a0,0x3
 bf8:	00000097          	auipc	ra,0x0
 bfc:	d4a080e7          	jalr	-694(ra) # 942 <malloc>
 c00:	00000797          	auipc	a5,0x0
 c04:	40a7bc23          	sd	a0,1048(a5) # 1018 <stacks>
 c08:	b785                	j	b68 <ithread_create+0x1a>
      printf("ERROR: Thread capacity has been reached\n");
 c0a:	00000517          	auipc	a0,0x0
 c0e:	0e650513          	addi	a0,a0,230 # cf0 <ithread_join+0xa8>
 c12:	00000097          	auipc	ra,0x0
 c16:	c78080e7          	jalr	-904(ra) # 88a <printf>
      return -1;
 c1a:	597d                	li	s2,-1
 c1c:	b7c9                	j	bde <ithread_create+0x90>
 c1e:	ec26                	sd	s1,24(sp)
 c20:	b7bd                	j	b8e <ithread_create+0x40>
    free(stack_ptr);
 c22:	8526                	mv	a0,s1
 c24:	00000097          	auipc	ra,0x0
 c28:	c9c080e7          	jalr	-868(ra) # 8c0 <free>
    stacks[num_threads] = 0;
 c2c:	00000717          	auipc	a4,0x0
 c30:	3f472703          	lw	a4,1012(a4) # 1020 <num_threads>
 c34:	070e                	slli	a4,a4,0x3
 c36:	00000797          	auipc	a5,0x0
 c3a:	3e27b783          	ld	a5,994(a5) # 1018 <stacks>
 c3e:	97ba                	add	a5,a5,a4
 c40:	0007b023          	sd	zero,0(a5)
 c44:	64e2                	ld	s1,24(sp)
 c46:	bf61                	j	bde <ithread_create+0x90>

0000000000000c48 <ithread_join>:

int ithread_join(int thread_id) {
 c48:	1101                	addi	sp,sp,-32
 c4a:	ec06                	sd	ra,24(sp)
 c4c:	e822                	sd	s0,16(sp)
 c4e:	1000                	addi	s0,sp,32
  int status;
  join_thread(thread_id, (uint64)&status);
 c50:	ff040793          	addi	a5,s0,-16
 c54:	ffc7859b          	addiw	a1,a5,-4
 c58:	00000097          	auipc	ra,0x0
 c5c:	90c080e7          	jalr	-1780(ra) # 564 <join_thread>
  threads_done++;
 c60:	00000717          	auipc	a4,0x0
 c64:	3c470713          	addi	a4,a4,964 # 1024 <threads_done>
 c68:	431c                	lw	a5,0(a4)
 c6a:	2785                	addiw	a5,a5,1
 c6c:	0007869b          	sext.w	a3,a5
 c70:	c31c                	sw	a5,0(a4)
  if (threads_done == num_threads) {
 c72:	00000797          	auipc	a5,0x0
 c76:	3ae7a783          	lw	a5,942(a5) # 1020 <num_threads>
 c7a:	00d78863          	beq	a5,a3,c8a <ithread_join+0x42>
    free_stacks();
  }
  return status;
}
 c7e:	fec42503          	lw	a0,-20(s0)
 c82:	60e2                	ld	ra,24(sp)
 c84:	6442                	ld	s0,16(sp)
 c86:	6105                	addi	sp,sp,32
 c88:	8082                	ret
    free_stacks();
 c8a:	00000097          	auipc	ra,0x0
 c8e:	dd2080e7          	jalr	-558(ra) # a5c <free_stacks>
 c92:	b7f5                	j	c7e <ithread_join+0x36>
