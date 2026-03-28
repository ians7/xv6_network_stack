
src/user/_grep:     file format elf64-littleriscv


Disassembly of section .text:

0000000000000000 <matchstar>:
  return 0;
}

// matchstar: search for c*re at beginning of text
int matchstar(int c, char *re, char *text)
{
   0:	7179                	addi	sp,sp,-48
   2:	f406                	sd	ra,40(sp)
   4:	f022                	sd	s0,32(sp)
   6:	ec26                	sd	s1,24(sp)
   8:	e84a                	sd	s2,16(sp)
   a:	e44e                	sd	s3,8(sp)
   c:	e052                	sd	s4,0(sp)
   e:	1800                	addi	s0,sp,48
  10:	892a                	mv	s2,a0
  12:	89ae                	mv	s3,a1
  14:	84b2                	mv	s1,a2
  do{  // a * matches zero or more instances
    if(matchhere(re, text))
      return 1;
  }while(*text!='\0' && (*text++==c || c=='.'));
  16:	02e00a13          	li	s4,46
    if(matchhere(re, text))
  1a:	85a6                	mv	a1,s1
  1c:	854e                	mv	a0,s3
  1e:	00000097          	auipc	ra,0x0
  22:	030080e7          	jalr	48(ra) # 4e <matchhere>
  26:	e919                	bnez	a0,3c <matchstar+0x3c>
  }while(*text!='\0' && (*text++==c || c=='.'));
  28:	0004c783          	lbu	a5,0(s1)
  2c:	cb89                	beqz	a5,3e <matchstar+0x3e>
  2e:	0485                	addi	s1,s1,1
  30:	2781                	sext.w	a5,a5
  32:	ff2784e3          	beq	a5,s2,1a <matchstar+0x1a>
  36:	ff4902e3          	beq	s2,s4,1a <matchstar+0x1a>
  3a:	a011                	j	3e <matchstar+0x3e>
      return 1;
  3c:	4505                	li	a0,1
  return 0;
}
  3e:	70a2                	ld	ra,40(sp)
  40:	7402                	ld	s0,32(sp)
  42:	64e2                	ld	s1,24(sp)
  44:	6942                	ld	s2,16(sp)
  46:	69a2                	ld	s3,8(sp)
  48:	6a02                	ld	s4,0(sp)
  4a:	6145                	addi	sp,sp,48
  4c:	8082                	ret

000000000000004e <matchhere>:
  if(re[0] == '\0')
  4e:	00054703          	lbu	a4,0(a0)
  52:	cb3d                	beqz	a4,c8 <matchhere+0x7a>
{
  54:	1141                	addi	sp,sp,-16
  56:	e406                	sd	ra,8(sp)
  58:	e022                	sd	s0,0(sp)
  5a:	0800                	addi	s0,sp,16
  5c:	87aa                	mv	a5,a0
  if(re[1] == '*')
  5e:	00154683          	lbu	a3,1(a0)
  62:	02a00613          	li	a2,42
  66:	02c68563          	beq	a3,a2,90 <matchhere+0x42>
  if(re[0] == '$' && re[1] == '\0')
  6a:	02400613          	li	a2,36
  6e:	02c70a63          	beq	a4,a2,a2 <matchhere+0x54>
  if(*text!='\0' && (re[0]=='.' || re[0]==*text))
  72:	0005c683          	lbu	a3,0(a1)
  return 0;
  76:	4501                	li	a0,0
  if(*text!='\0' && (re[0]=='.' || re[0]==*text))
  78:	ca81                	beqz	a3,88 <matchhere+0x3a>
  7a:	02e00613          	li	a2,46
  7e:	02c70d63          	beq	a4,a2,b8 <matchhere+0x6a>
  return 0;
  82:	4501                	li	a0,0
  if(*text!='\0' && (re[0]=='.' || re[0]==*text))
  84:	02d70a63          	beq	a4,a3,b8 <matchhere+0x6a>
}
  88:	60a2                	ld	ra,8(sp)
  8a:	6402                	ld	s0,0(sp)
  8c:	0141                	addi	sp,sp,16
  8e:	8082                	ret
    return matchstar(re[0], re+2, text);
  90:	862e                	mv	a2,a1
  92:	00250593          	addi	a1,a0,2
  96:	853a                	mv	a0,a4
  98:	00000097          	auipc	ra,0x0
  9c:	f68080e7          	jalr	-152(ra) # 0 <matchstar>
  a0:	b7e5                	j	88 <matchhere+0x3a>
  if(re[0] == '$' && re[1] == '\0')
  a2:	c691                	beqz	a3,ae <matchhere+0x60>
  if(*text!='\0' && (re[0]=='.' || re[0]==*text))
  a4:	0005c683          	lbu	a3,0(a1)
  a8:	fee9                	bnez	a3,82 <matchhere+0x34>
  return 0;
  aa:	4501                	li	a0,0
  ac:	bff1                	j	88 <matchhere+0x3a>
    return *text == '\0';
  ae:	0005c503          	lbu	a0,0(a1)
  b2:	00153513          	seqz	a0,a0
  b6:	bfc9                	j	88 <matchhere+0x3a>
    return matchhere(re+1, text+1);
  b8:	0585                	addi	a1,a1,1
  ba:	00178513          	addi	a0,a5,1
  be:	00000097          	auipc	ra,0x0
  c2:	f90080e7          	jalr	-112(ra) # 4e <matchhere>
  c6:	b7c9                	j	88 <matchhere+0x3a>
    return 1;
  c8:	4505                	li	a0,1
}
  ca:	8082                	ret

00000000000000cc <match>:
{
  cc:	1101                	addi	sp,sp,-32
  ce:	ec06                	sd	ra,24(sp)
  d0:	e822                	sd	s0,16(sp)
  d2:	e426                	sd	s1,8(sp)
  d4:	e04a                	sd	s2,0(sp)
  d6:	1000                	addi	s0,sp,32
  d8:	892a                	mv	s2,a0
  da:	84ae                	mv	s1,a1
  if(re[0] == '^')
  dc:	00054703          	lbu	a4,0(a0)
  e0:	05e00793          	li	a5,94
  e4:	00f70e63          	beq	a4,a5,100 <match+0x34>
    if(matchhere(re, text))
  e8:	85a6                	mv	a1,s1
  ea:	854a                	mv	a0,s2
  ec:	00000097          	auipc	ra,0x0
  f0:	f62080e7          	jalr	-158(ra) # 4e <matchhere>
  f4:	ed01                	bnez	a0,10c <match+0x40>
  }while(*text++ != '\0');
  f6:	0485                	addi	s1,s1,1
  f8:	fff4c783          	lbu	a5,-1(s1)
  fc:	f7f5                	bnez	a5,e8 <match+0x1c>
  fe:	a801                	j	10e <match+0x42>
    return matchhere(re+1, text);
 100:	0505                	addi	a0,a0,1
 102:	00000097          	auipc	ra,0x0
 106:	f4c080e7          	jalr	-180(ra) # 4e <matchhere>
 10a:	a011                	j	10e <match+0x42>
      return 1;
 10c:	4505                	li	a0,1
}
 10e:	60e2                	ld	ra,24(sp)
 110:	6442                	ld	s0,16(sp)
 112:	64a2                	ld	s1,8(sp)
 114:	6902                	ld	s2,0(sp)
 116:	6105                	addi	sp,sp,32
 118:	8082                	ret

000000000000011a <grep>:
{
 11a:	715d                	addi	sp,sp,-80
 11c:	e486                	sd	ra,72(sp)
 11e:	e0a2                	sd	s0,64(sp)
 120:	fc26                	sd	s1,56(sp)
 122:	f84a                	sd	s2,48(sp)
 124:	f44e                	sd	s3,40(sp)
 126:	f052                	sd	s4,32(sp)
 128:	ec56                	sd	s5,24(sp)
 12a:	e85a                	sd	s6,16(sp)
 12c:	e45e                	sd	s7,8(sp)
 12e:	e062                	sd	s8,0(sp)
 130:	0880                	addi	s0,sp,80
 132:	89aa                	mv	s3,a0
 134:	8b2e                	mv	s6,a1
  m = 0;
 136:	4a01                	li	s4,0
  while((n = read(fd, buf+m, sizeof(buf)-m-1)) > 0){
 138:	3ff00b93          	li	s7,1023
 13c:	00001a97          	auipc	s5,0x1
 140:	ef4a8a93          	addi	s5,s5,-268 # 1030 <buf>
 144:	a0a1                	j	18c <grep+0x72>
      p = q+1;
 146:	00148913          	addi	s2,s1,1
    while((q = strchr(p, '\n')) != 0){
 14a:	45a9                	li	a1,10
 14c:	854a                	mv	a0,s2
 14e:	00000097          	auipc	ra,0x0
 152:	20a080e7          	jalr	522(ra) # 358 <strchr>
 156:	84aa                	mv	s1,a0
 158:	c905                	beqz	a0,188 <grep+0x6e>
      *q = 0;
 15a:	00048023          	sb	zero,0(s1)
      if(match(pattern, p)){
 15e:	85ca                	mv	a1,s2
 160:	854e                	mv	a0,s3
 162:	00000097          	auipc	ra,0x0
 166:	f6a080e7          	jalr	-150(ra) # cc <match>
 16a:	dd71                	beqz	a0,146 <grep+0x2c>
        *q = '\n';
 16c:	47a9                	li	a5,10
 16e:	00f48023          	sb	a5,0(s1)
        write(1, p, q+1 - p);
 172:	00148613          	addi	a2,s1,1
 176:	4126063b          	subw	a2,a2,s2
 17a:	85ca                	mv	a1,s2
 17c:	4505                	li	a0,1
 17e:	00000097          	auipc	ra,0x0
 182:	4de080e7          	jalr	1246(ra) # 65c <write>
 186:	b7c1                	j	146 <grep+0x2c>
    if(m > 0){
 188:	03404763          	bgtz	s4,1b6 <grep+0x9c>
  while((n = read(fd, buf+m, sizeof(buf)-m-1)) > 0){
 18c:	414b863b          	subw	a2,s7,s4
 190:	014a85b3          	add	a1,s5,s4
 194:	855a                	mv	a0,s6
 196:	00000097          	auipc	ra,0x0
 19a:	4be080e7          	jalr	1214(ra) # 654 <read>
 19e:	02a05b63          	blez	a0,1d4 <grep+0xba>
    m += n;
 1a2:	00aa0c3b          	addw	s8,s4,a0
 1a6:	000c0a1b          	sext.w	s4,s8
    buf[m] = '\0';
 1aa:	014a87b3          	add	a5,s5,s4
 1ae:	00078023          	sb	zero,0(a5)
    p = buf;
 1b2:	8956                	mv	s2,s5
    while((q = strchr(p, '\n')) != 0){
 1b4:	bf59                	j	14a <grep+0x30>
      m -= p - buf;
 1b6:	00001517          	auipc	a0,0x1
 1ba:	e7a50513          	addi	a0,a0,-390 # 1030 <buf>
 1be:	40a90a33          	sub	s4,s2,a0
 1c2:	414c0a3b          	subw	s4,s8,s4
      memmove(buf, p, m);
 1c6:	8652                	mv	a2,s4
 1c8:	85ca                	mv	a1,s2
 1ca:	00000097          	auipc	ra,0x0
 1ce:	328080e7          	jalr	808(ra) # 4f2 <memmove>
 1d2:	bf6d                	j	18c <grep+0x72>
}
 1d4:	60a6                	ld	ra,72(sp)
 1d6:	6406                	ld	s0,64(sp)
 1d8:	74e2                	ld	s1,56(sp)
 1da:	7942                	ld	s2,48(sp)
 1dc:	79a2                	ld	s3,40(sp)
 1de:	7a02                	ld	s4,32(sp)
 1e0:	6ae2                	ld	s5,24(sp)
 1e2:	6b42                	ld	s6,16(sp)
 1e4:	6ba2                	ld	s7,8(sp)
 1e6:	6c02                	ld	s8,0(sp)
 1e8:	6161                	addi	sp,sp,80
 1ea:	8082                	ret

00000000000001ec <main>:
{
 1ec:	7179                	addi	sp,sp,-48
 1ee:	f406                	sd	ra,40(sp)
 1f0:	f022                	sd	s0,32(sp)
 1f2:	ec26                	sd	s1,24(sp)
 1f4:	e84a                	sd	s2,16(sp)
 1f6:	e44e                	sd	s3,8(sp)
 1f8:	e052                	sd	s4,0(sp)
 1fa:	1800                	addi	s0,sp,48
  if(argc <= 1){
 1fc:	4785                	li	a5,1
 1fe:	04a7de63          	bge	a5,a0,25a <main+0x6e>
  pattern = argv[1];
 202:	0085ba03          	ld	s4,8(a1)
  if(argc <= 2){
 206:	4789                	li	a5,2
 208:	06a7d763          	bge	a5,a0,276 <main+0x8a>
 20c:	01058913          	addi	s2,a1,16
 210:	ffd5099b          	addiw	s3,a0,-3
 214:	02099793          	slli	a5,s3,0x20
 218:	01d7d993          	srli	s3,a5,0x1d
 21c:	05e1                	addi	a1,a1,24
 21e:	99ae                	add	s3,s3,a1
    if((fd = open(argv[i], 0)) < 0){
 220:	4581                	li	a1,0
 222:	00093503          	ld	a0,0(s2)
 226:	00000097          	auipc	ra,0x0
 22a:	456080e7          	jalr	1110(ra) # 67c <open>
 22e:	84aa                	mv	s1,a0
 230:	04054e63          	bltz	a0,28c <main+0xa0>
    grep(pattern, fd);
 234:	85aa                	mv	a1,a0
 236:	8552                	mv	a0,s4
 238:	00000097          	auipc	ra,0x0
 23c:	ee2080e7          	jalr	-286(ra) # 11a <grep>
    close(fd);
 240:	8526                	mv	a0,s1
 242:	00000097          	auipc	ra,0x0
 246:	422080e7          	jalr	1058(ra) # 664 <close>
  for(i = 2; i < argc; i++){
 24a:	0921                	addi	s2,s2,8
 24c:	fd391ae3          	bne	s2,s3,220 <main+0x34>
  exit(0);
 250:	4501                	li	a0,0
 252:	00000097          	auipc	ra,0x0
 256:	3ea080e7          	jalr	1002(ra) # 63c <exit>
    fprintf(2, "usage: grep pattern [file ...]\n");
 25a:	00001597          	auipc	a1,0x1
 25e:	bc658593          	addi	a1,a1,-1082 # e20 <ithread_join+0x50>
 262:	4509                	li	a0,2
 264:	00000097          	auipc	ra,0x0
 268:	780080e7          	jalr	1920(ra) # 9e4 <fprintf>
    exit(1);
 26c:	4505                	li	a0,1
 26e:	00000097          	auipc	ra,0x0
 272:	3ce080e7          	jalr	974(ra) # 63c <exit>
    grep(pattern, 0);
 276:	4581                	li	a1,0
 278:	8552                	mv	a0,s4
 27a:	00000097          	auipc	ra,0x0
 27e:	ea0080e7          	jalr	-352(ra) # 11a <grep>
    exit(0);
 282:	4501                	li	a0,0
 284:	00000097          	auipc	ra,0x0
 288:	3b8080e7          	jalr	952(ra) # 63c <exit>
      printf("grep: cannot open %s\n", argv[i]);
 28c:	00093583          	ld	a1,0(s2)
 290:	00001517          	auipc	a0,0x1
 294:	bb050513          	addi	a0,a0,-1104 # e40 <ithread_join+0x70>
 298:	00000097          	auipc	ra,0x0
 29c:	77a080e7          	jalr	1914(ra) # a12 <printf>
      exit(1);
 2a0:	4505                	li	a0,1
 2a2:	00000097          	auipc	ra,0x0
 2a6:	39a080e7          	jalr	922(ra) # 63c <exit>

00000000000002aa <_main>:
//
// wrapper so that it's OK if main() does not call exit().
//
void
_main()
{
 2aa:	1141                	addi	sp,sp,-16
 2ac:	e406                	sd	ra,8(sp)
 2ae:	e022                	sd	s0,0(sp)
 2b0:	0800                	addi	s0,sp,16
  extern int main();
  main();
 2b2:	00000097          	auipc	ra,0x0
 2b6:	f3a080e7          	jalr	-198(ra) # 1ec <main>
  exit(0);
 2ba:	4501                	li	a0,0
 2bc:	00000097          	auipc	ra,0x0
 2c0:	380080e7          	jalr	896(ra) # 63c <exit>

00000000000002c4 <strcpy>:
}

char*
strcpy(char *s, const char *t)
{
 2c4:	1141                	addi	sp,sp,-16
 2c6:	e422                	sd	s0,8(sp)
 2c8:	0800                	addi	s0,sp,16
  char *os;

  os = s;
  while((*s++ = *t++) != 0)
 2ca:	87aa                	mv	a5,a0
 2cc:	0585                	addi	a1,a1,1
 2ce:	0785                	addi	a5,a5,1
 2d0:	fff5c703          	lbu	a4,-1(a1)
 2d4:	fee78fa3          	sb	a4,-1(a5)
 2d8:	fb75                	bnez	a4,2cc <strcpy+0x8>
    ;
  return os;
}
 2da:	6422                	ld	s0,8(sp)
 2dc:	0141                	addi	sp,sp,16
 2de:	8082                	ret

00000000000002e0 <strcmp>:

int
strcmp(const char *p, const char *q)
{
 2e0:	1141                	addi	sp,sp,-16
 2e2:	e422                	sd	s0,8(sp)
 2e4:	0800                	addi	s0,sp,16
  while(*p && *p == *q)
 2e6:	00054783          	lbu	a5,0(a0)
 2ea:	cb91                	beqz	a5,2fe <strcmp+0x1e>
 2ec:	0005c703          	lbu	a4,0(a1)
 2f0:	00f71763          	bne	a4,a5,2fe <strcmp+0x1e>
    p++, q++;
 2f4:	0505                	addi	a0,a0,1
 2f6:	0585                	addi	a1,a1,1
  while(*p && *p == *q)
 2f8:	00054783          	lbu	a5,0(a0)
 2fc:	fbe5                	bnez	a5,2ec <strcmp+0xc>
  return (uchar)*p - (uchar)*q;
 2fe:	0005c503          	lbu	a0,0(a1)
}
 302:	40a7853b          	subw	a0,a5,a0
 306:	6422                	ld	s0,8(sp)
 308:	0141                	addi	sp,sp,16
 30a:	8082                	ret

000000000000030c <strlen>:

uint
strlen(const char *s)
{
 30c:	1141                	addi	sp,sp,-16
 30e:	e422                	sd	s0,8(sp)
 310:	0800                	addi	s0,sp,16
  int n;

  for(n = 0; s[n]; n++)
 312:	00054783          	lbu	a5,0(a0)
 316:	cf91                	beqz	a5,332 <strlen+0x26>
 318:	0505                	addi	a0,a0,1
 31a:	87aa                	mv	a5,a0
 31c:	86be                	mv	a3,a5
 31e:	0785                	addi	a5,a5,1
 320:	fff7c703          	lbu	a4,-1(a5)
 324:	ff65                	bnez	a4,31c <strlen+0x10>
 326:	40a6853b          	subw	a0,a3,a0
 32a:	2505                	addiw	a0,a0,1
    ;
  return n;
}
 32c:	6422                	ld	s0,8(sp)
 32e:	0141                	addi	sp,sp,16
 330:	8082                	ret
  for(n = 0; s[n]; n++)
 332:	4501                	li	a0,0
 334:	bfe5                	j	32c <strlen+0x20>

0000000000000336 <memset>:

void*
memset(void *dst, int c, uint n)
{
 336:	1141                	addi	sp,sp,-16
 338:	e422                	sd	s0,8(sp)
 33a:	0800                	addi	s0,sp,16
  char *cdst = (char *) dst;
  int i;
  for(i = 0; i < n; i++){
 33c:	ca19                	beqz	a2,352 <memset+0x1c>
 33e:	87aa                	mv	a5,a0
 340:	1602                	slli	a2,a2,0x20
 342:	9201                	srli	a2,a2,0x20
 344:	00a60733          	add	a4,a2,a0
    cdst[i] = c;
 348:	00b78023          	sb	a1,0(a5)
  for(i = 0; i < n; i++){
 34c:	0785                	addi	a5,a5,1
 34e:	fee79de3          	bne	a5,a4,348 <memset+0x12>
  }
  return dst;
}
 352:	6422                	ld	s0,8(sp)
 354:	0141                	addi	sp,sp,16
 356:	8082                	ret

0000000000000358 <strchr>:

char*
strchr(const char *s, char c)
{
 358:	1141                	addi	sp,sp,-16
 35a:	e422                	sd	s0,8(sp)
 35c:	0800                	addi	s0,sp,16
  for(; *s; s++)
 35e:	00054783          	lbu	a5,0(a0)
 362:	cb99                	beqz	a5,378 <strchr+0x20>
    if(*s == c)
 364:	00f58763          	beq	a1,a5,372 <strchr+0x1a>
  for(; *s; s++)
 368:	0505                	addi	a0,a0,1
 36a:	00054783          	lbu	a5,0(a0)
 36e:	fbfd                	bnez	a5,364 <strchr+0xc>
      return (char*)s;
  return 0;
 370:	4501                	li	a0,0
}
 372:	6422                	ld	s0,8(sp)
 374:	0141                	addi	sp,sp,16
 376:	8082                	ret
  return 0;
 378:	4501                	li	a0,0
 37a:	bfe5                	j	372 <strchr+0x1a>

000000000000037c <gets>:

char*
gets(char *buf, int max)
{
 37c:	711d                	addi	sp,sp,-96
 37e:	ec86                	sd	ra,88(sp)
 380:	e8a2                	sd	s0,80(sp)
 382:	e4a6                	sd	s1,72(sp)
 384:	e0ca                	sd	s2,64(sp)
 386:	fc4e                	sd	s3,56(sp)
 388:	f852                	sd	s4,48(sp)
 38a:	f456                	sd	s5,40(sp)
 38c:	f05a                	sd	s6,32(sp)
 38e:	ec5e                	sd	s7,24(sp)
 390:	1080                	addi	s0,sp,96
 392:	8baa                	mv	s7,a0
 394:	8a2e                	mv	s4,a1
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 396:	892a                	mv	s2,a0
 398:	4481                	li	s1,0
    cc = read(0, &c, 1);
    if(cc < 1)
      break;
    buf[i++] = c;
    if(c == '\n' || c == '\r')
 39a:	4aa9                	li	s5,10
 39c:	4b35                	li	s6,13
  for(i=0; i+1 < max; ){
 39e:	89a6                	mv	s3,s1
 3a0:	2485                	addiw	s1,s1,1
 3a2:	0344d863          	bge	s1,s4,3d2 <gets+0x56>
    cc = read(0, &c, 1);
 3a6:	4605                	li	a2,1
 3a8:	faf40593          	addi	a1,s0,-81
 3ac:	4501                	li	a0,0
 3ae:	00000097          	auipc	ra,0x0
 3b2:	2a6080e7          	jalr	678(ra) # 654 <read>
    if(cc < 1)
 3b6:	00a05e63          	blez	a0,3d2 <gets+0x56>
    buf[i++] = c;
 3ba:	faf44783          	lbu	a5,-81(s0)
 3be:	00f90023          	sb	a5,0(s2)
    if(c == '\n' || c == '\r')
 3c2:	01578763          	beq	a5,s5,3d0 <gets+0x54>
 3c6:	0905                	addi	s2,s2,1
 3c8:	fd679be3          	bne	a5,s6,39e <gets+0x22>
    buf[i++] = c;
 3cc:	89a6                	mv	s3,s1
 3ce:	a011                	j	3d2 <gets+0x56>
 3d0:	89a6                	mv	s3,s1
      break;
  }
  buf[i] = '\0';
 3d2:	99de                	add	s3,s3,s7
 3d4:	00098023          	sb	zero,0(s3)
  return buf;
}
 3d8:	855e                	mv	a0,s7
 3da:	60e6                	ld	ra,88(sp)
 3dc:	6446                	ld	s0,80(sp)
 3de:	64a6                	ld	s1,72(sp)
 3e0:	6906                	ld	s2,64(sp)
 3e2:	79e2                	ld	s3,56(sp)
 3e4:	7a42                	ld	s4,48(sp)
 3e6:	7aa2                	ld	s5,40(sp)
 3e8:	7b02                	ld	s6,32(sp)
 3ea:	6be2                	ld	s7,24(sp)
 3ec:	6125                	addi	sp,sp,96
 3ee:	8082                	ret

00000000000003f0 <fgetstdin>:

int
fgetstdin(char *buf, int size) {
 3f0:	711d                	addi	sp,sp,-96
 3f2:	ec86                	sd	ra,88(sp)
 3f4:	e8a2                	sd	s0,80(sp)
 3f6:	e4a6                	sd	s1,72(sp)
 3f8:	e0ca                	sd	s2,64(sp)
 3fa:	fc4e                	sd	s3,56(sp)
 3fc:	f852                	sd	s4,48(sp)
 3fe:	f456                	sd	s5,40(sp)
 400:	f05a                	sd	s6,32(sp)
 402:	ec5e                	sd	s7,24(sp)
 404:	1080                	addi	s0,sp,96
 406:	8baa                	mv	s7,a0
 408:	89ae                	mv	s3,a1
  int i, cc;
  char c;

  for(i=0; i+1 < size; ){
 40a:	892a                	mv	s2,a0
 40c:	4481                	li	s1,0
    cc = read(0, &c, 1);
    if(cc < 1)
      break;
    buf[i++] = c;
    if(c == '\n' || c == '\r')
 40e:	4aa9                	li	s5,10
 410:	4b35                	li	s6,13
  for(i=0; i+1 < size; ){
 412:	8a26                	mv	s4,s1
 414:	2485                	addiw	s1,s1,1
 416:	0334d863          	bge	s1,s3,446 <fgetstdin+0x56>
    cc = read(0, &c, 1);
 41a:	4605                	li	a2,1
 41c:	faf40593          	addi	a1,s0,-81
 420:	4501                	li	a0,0
 422:	00000097          	auipc	ra,0x0
 426:	232080e7          	jalr	562(ra) # 654 <read>
    if(cc < 1)
 42a:	00a05e63          	blez	a0,446 <fgetstdin+0x56>
    buf[i++] = c;
 42e:	faf44783          	lbu	a5,-81(s0)
 432:	00f90023          	sb	a5,0(s2)
    if(c == '\n' || c == '\r')
 436:	01578763          	beq	a5,s5,444 <fgetstdin+0x54>
 43a:	0905                	addi	s2,s2,1
 43c:	fd679be3          	bne	a5,s6,412 <fgetstdin+0x22>
    buf[i++] = c;
 440:	8a26                	mv	s4,s1
 442:	a011                	j	446 <fgetstdin+0x56>
 444:	8a26                	mv	s4,s1
      break;
  }
  buf[i] = '\0';
 446:	9bd2                	add	s7,s7,s4
 448:	000b8023          	sb	zero,0(s7)
  return i;
}
 44c:	8552                	mv	a0,s4
 44e:	60e6                	ld	ra,88(sp)
 450:	6446                	ld	s0,80(sp)
 452:	64a6                	ld	s1,72(sp)
 454:	6906                	ld	s2,64(sp)
 456:	79e2                	ld	s3,56(sp)
 458:	7a42                	ld	s4,48(sp)
 45a:	7aa2                	ld	s5,40(sp)
 45c:	7b02                	ld	s6,32(sp)
 45e:	6be2                	ld	s7,24(sp)
 460:	6125                	addi	sp,sp,96
 462:	8082                	ret

0000000000000464 <stat>:

int
stat(const char *n, struct stat *st)
{
 464:	1101                	addi	sp,sp,-32
 466:	ec06                	sd	ra,24(sp)
 468:	e822                	sd	s0,16(sp)
 46a:	e04a                	sd	s2,0(sp)
 46c:	1000                	addi	s0,sp,32
 46e:	892e                	mv	s2,a1
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 470:	4581                	li	a1,0
 472:	00000097          	auipc	ra,0x0
 476:	20a080e7          	jalr	522(ra) # 67c <open>
  if(fd < 0)
 47a:	02054663          	bltz	a0,4a6 <stat+0x42>
 47e:	e426                	sd	s1,8(sp)
 480:	84aa                	mv	s1,a0
    return -1;
  r = fstat(fd, st);
 482:	85ca                	mv	a1,s2
 484:	00000097          	auipc	ra,0x0
 488:	210080e7          	jalr	528(ra) # 694 <fstat>
 48c:	892a                	mv	s2,a0
  close(fd);
 48e:	8526                	mv	a0,s1
 490:	00000097          	auipc	ra,0x0
 494:	1d4080e7          	jalr	468(ra) # 664 <close>
  return r;
 498:	64a2                	ld	s1,8(sp)
}
 49a:	854a                	mv	a0,s2
 49c:	60e2                	ld	ra,24(sp)
 49e:	6442                	ld	s0,16(sp)
 4a0:	6902                	ld	s2,0(sp)
 4a2:	6105                	addi	sp,sp,32
 4a4:	8082                	ret
    return -1;
 4a6:	597d                	li	s2,-1
 4a8:	bfcd                	j	49a <stat+0x36>

00000000000004aa <atoi>:

int
atoi(const char *s)
{
 4aa:	1141                	addi	sp,sp,-16
 4ac:	e422                	sd	s0,8(sp)
 4ae:	0800                	addi	s0,sp,16
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
 4b0:	00054683          	lbu	a3,0(a0)
 4b4:	fd06879b          	addiw	a5,a3,-48
 4b8:	0ff7f793          	zext.b	a5,a5
 4bc:	4625                	li	a2,9
 4be:	02f66863          	bltu	a2,a5,4ee <atoi+0x44>
 4c2:	872a                	mv	a4,a0
  n = 0;
 4c4:	4501                	li	a0,0
    n = n*10 + *s++ - '0';
 4c6:	0705                	addi	a4,a4,1
 4c8:	0025179b          	slliw	a5,a0,0x2
 4cc:	9fa9                	addw	a5,a5,a0
 4ce:	0017979b          	slliw	a5,a5,0x1
 4d2:	9fb5                	addw	a5,a5,a3
 4d4:	fd07851b          	addiw	a0,a5,-48
  while('0' <= *s && *s <= '9')
 4d8:	00074683          	lbu	a3,0(a4)
 4dc:	fd06879b          	addiw	a5,a3,-48
 4e0:	0ff7f793          	zext.b	a5,a5
 4e4:	fef671e3          	bgeu	a2,a5,4c6 <atoi+0x1c>
  return n;
}
 4e8:	6422                	ld	s0,8(sp)
 4ea:	0141                	addi	sp,sp,16
 4ec:	8082                	ret
  n = 0;
 4ee:	4501                	li	a0,0
 4f0:	bfe5                	j	4e8 <atoi+0x3e>

00000000000004f2 <memmove>:

void*
memmove(void *vdst, const void *vsrc, int n)
{
 4f2:	1141                	addi	sp,sp,-16
 4f4:	e422                	sd	s0,8(sp)
 4f6:	0800                	addi	s0,sp,16
  char *dst;
  const char *src;

  dst = vdst;
  src = vsrc;
  if (src > dst) {
 4f8:	02b57463          	bgeu	a0,a1,520 <memmove+0x2e>
    while(n-- > 0)
 4fc:	00c05f63          	blez	a2,51a <memmove+0x28>
 500:	1602                	slli	a2,a2,0x20
 502:	9201                	srli	a2,a2,0x20
 504:	00c507b3          	add	a5,a0,a2
  dst = vdst;
 508:	872a                	mv	a4,a0
      *dst++ = *src++;
 50a:	0585                	addi	a1,a1,1
 50c:	0705                	addi	a4,a4,1
 50e:	fff5c683          	lbu	a3,-1(a1)
 512:	fed70fa3          	sb	a3,-1(a4)
    while(n-- > 0)
 516:	fef71ae3          	bne	a4,a5,50a <memmove+0x18>
    src += n;
    while(n-- > 0)
      *--dst = *--src;
  }
  return vdst;
}
 51a:	6422                	ld	s0,8(sp)
 51c:	0141                	addi	sp,sp,16
 51e:	8082                	ret
    dst += n;
 520:	00c50733          	add	a4,a0,a2
    src += n;
 524:	95b2                	add	a1,a1,a2
    while(n-- > 0)
 526:	fec05ae3          	blez	a2,51a <memmove+0x28>
 52a:	fff6079b          	addiw	a5,a2,-1
 52e:	1782                	slli	a5,a5,0x20
 530:	9381                	srli	a5,a5,0x20
 532:	fff7c793          	not	a5,a5
 536:	97ba                	add	a5,a5,a4
      *--dst = *--src;
 538:	15fd                	addi	a1,a1,-1
 53a:	177d                	addi	a4,a4,-1
 53c:	0005c683          	lbu	a3,0(a1)
 540:	00d70023          	sb	a3,0(a4)
    while(n-- > 0)
 544:	fee79ae3          	bne	a5,a4,538 <memmove+0x46>
 548:	bfc9                	j	51a <memmove+0x28>

000000000000054a <memcmp>:

int
memcmp(const void *s1, const void *s2, uint n)
{
 54a:	1141                	addi	sp,sp,-16
 54c:	e422                	sd	s0,8(sp)
 54e:	0800                	addi	s0,sp,16
  const char *p1 = s1, *p2 = s2;
  while (n-- > 0) {
 550:	ca05                	beqz	a2,580 <memcmp+0x36>
 552:	fff6069b          	addiw	a3,a2,-1
 556:	1682                	slli	a3,a3,0x20
 558:	9281                	srli	a3,a3,0x20
 55a:	0685                	addi	a3,a3,1
 55c:	96aa                	add	a3,a3,a0
    if (*p1 != *p2) {
 55e:	00054783          	lbu	a5,0(a0)
 562:	0005c703          	lbu	a4,0(a1)
 566:	00e79863          	bne	a5,a4,576 <memcmp+0x2c>
      return *p1 - *p2;
    }
    p1++;
 56a:	0505                	addi	a0,a0,1
    p2++;
 56c:	0585                	addi	a1,a1,1
  while (n-- > 0) {
 56e:	fed518e3          	bne	a0,a3,55e <memcmp+0x14>
  }
  return 0;
 572:	4501                	li	a0,0
 574:	a019                	j	57a <memcmp+0x30>
      return *p1 - *p2;
 576:	40e7853b          	subw	a0,a5,a4
}
 57a:	6422                	ld	s0,8(sp)
 57c:	0141                	addi	sp,sp,16
 57e:	8082                	ret
  return 0;
 580:	4501                	li	a0,0
 582:	bfe5                	j	57a <memcmp+0x30>

0000000000000584 <memcpy>:

void *
memcpy(void *dst, const void *src, uint n)
{
 584:	1141                	addi	sp,sp,-16
 586:	e406                	sd	ra,8(sp)
 588:	e022                	sd	s0,0(sp)
 58a:	0800                	addi	s0,sp,16
  return memmove(dst, src, n);
 58c:	00000097          	auipc	ra,0x0
 590:	f66080e7          	jalr	-154(ra) # 4f2 <memmove>
}
 594:	60a2                	ld	ra,8(sp)
 596:	6402                	ld	s0,0(sp)
 598:	0141                	addi	sp,sp,16
 59a:	8082                	ret

000000000000059c <inet_addr>:

// Parse a dotted-decimal IPv4 string (e.g. "10.10.0.2") and return the
// address as a 32-bit integer in host byte order, or 0 on failure.
uint
inet_addr(const char *s)
{
 59c:	1141                	addi	sp,sp,-16
 59e:	e422                	sd	s0,8(sp)
 5a0:	0800                	addi	s0,sp,16
  uint result = 0;
  int octet = 0;
  int digits = 0;
  int dots = 0;

  for (; *s; s++) {
 5a2:	00054783          	lbu	a5,0(a0)
 5a6:	cfbd                	beqz	a5,624 <inet_addr+0x88>
  int dots = 0;
 5a8:	4801                	li	a6,0
  int digits = 0;
 5aa:	4601                	li	a2,0
  int octet = 0;
 5ac:	4681                	li	a3,0
  uint result = 0;
 5ae:	4581                	li	a1,0
    if (*s >= '0' && *s <= '9') {
 5b0:	48a5                	li	a7,9
      octet = octet * 10 + (*s - '0');
      digits++;
      if (octet > 255)
        return 0;
    } else if (*s == '.') {
 5b2:	02e00e93          	li	t4,46
      if (digits == 0 || dots == 3)
 5b6:	4f0d                	li	t5,3
        return 0;
      result = (result << 8) | (uint)octet;
      octet = 0;
      digits = 0;
 5b8:	4301                	li	t1,0
      if (octet > 255)
 5ba:	0ff00e13          	li	t3,255
 5be:	a015                	j	5e2 <inet_addr+0x46>
    } else if (*s == '.') {
 5c0:	07d79463          	bne	a5,t4,628 <inet_addr+0x8c>
      if (digits == 0 || dots == 3)
 5c4:	c625                	beqz	a2,62c <inet_addr+0x90>
 5c6:	07e80563          	beq	a6,t5,630 <inet_addr+0x94>
      result = (result << 8) | (uint)octet;
 5ca:	0085959b          	slliw	a1,a1,0x8
 5ce:	8ecd                	or	a3,a3,a1
 5d0:	0006859b          	sext.w	a1,a3
      dots++;
 5d4:	2805                	addiw	a6,a6,1
      digits = 0;
 5d6:	861a                	mv	a2,t1
      octet = 0;
 5d8:	869a                	mv	a3,t1
  for (; *s; s++) {
 5da:	0505                	addi	a0,a0,1
 5dc:	00054783          	lbu	a5,0(a0)
 5e0:	c79d                	beqz	a5,60e <inet_addr+0x72>
    if (*s >= '0' && *s <= '9') {
 5e2:	fd07871b          	addiw	a4,a5,-48
 5e6:	0ff77713          	zext.b	a4,a4
 5ea:	fce8ebe3          	bltu	a7,a4,5c0 <inet_addr+0x24>
      octet = octet * 10 + (*s - '0');
 5ee:	0026971b          	slliw	a4,a3,0x2
 5f2:	9f35                	addw	a4,a4,a3
 5f4:	0017171b          	slliw	a4,a4,0x1
 5f8:	fd07879b          	addiw	a5,a5,-48
 5fc:	00e786bb          	addw	a3,a5,a4
      digits++;
 600:	2605                	addiw	a2,a2,1
      if (octet > 255)
 602:	fcde5ce3          	bge	t3,a3,5da <inet_addr+0x3e>
        return 0;
 606:	4501                	li	a0,0
  if (digits == 0 || dots != 3)
    return 0;

  result = (result << 8) | (uint)octet;
  return result;
}
 608:	6422                	ld	s0,8(sp)
 60a:	0141                	addi	sp,sp,16
 60c:	8082                	ret
    return 0;
 60e:	4501                	li	a0,0
  if (digits == 0 || dots != 3)
 610:	de65                	beqz	a2,608 <inet_addr+0x6c>
 612:	478d                	li	a5,3
 614:	fef81ae3          	bne	a6,a5,608 <inet_addr+0x6c>
  result = (result << 8) | (uint)octet;
 618:	0085959b          	slliw	a1,a1,0x8
 61c:	8ecd                	or	a3,a3,a1
 61e:	0006851b          	sext.w	a0,a3
  return result;
 622:	b7dd                	j	608 <inet_addr+0x6c>
    return 0;
 624:	4501                	li	a0,0
 626:	b7cd                	j	608 <inet_addr+0x6c>
      return 0;
 628:	4501                	li	a0,0
 62a:	bff9                	j	608 <inet_addr+0x6c>
        return 0;
 62c:	4501                	li	a0,0
 62e:	bfe9                	j	608 <inet_addr+0x6c>
 630:	4501                	li	a0,0
 632:	bfd9                	j	608 <inet_addr+0x6c>

0000000000000634 <fork>:
# generated by usys.pl - do not edit
#include "kernel/syscall.h"
.global fork
fork:
 li a7, SYS_fork
 634:	4885                	li	a7,1
 ecall
 636:	00000073          	ecall
 ret
 63a:	8082                	ret

000000000000063c <exit>:
.global exit
exit:
 li a7, SYS_exit
 63c:	4889                	li	a7,2
 ecall
 63e:	00000073          	ecall
 ret
 642:	8082                	ret

0000000000000644 <wait>:
.global wait
wait:
 li a7, SYS_wait
 644:	488d                	li	a7,3
 ecall
 646:	00000073          	ecall
 ret
 64a:	8082                	ret

000000000000064c <pipe>:
.global pipe
pipe:
 li a7, SYS_pipe
 64c:	4891                	li	a7,4
 ecall
 64e:	00000073          	ecall
 ret
 652:	8082                	ret

0000000000000654 <read>:
.global read
read:
 li a7, SYS_read
 654:	4895                	li	a7,5
 ecall
 656:	00000073          	ecall
 ret
 65a:	8082                	ret

000000000000065c <write>:
.global write
write:
 li a7, SYS_write
 65c:	48c1                	li	a7,16
 ecall
 65e:	00000073          	ecall
 ret
 662:	8082                	ret

0000000000000664 <close>:
.global close
close:
 li a7, SYS_close
 664:	48d5                	li	a7,21
 ecall
 666:	00000073          	ecall
 ret
 66a:	8082                	ret

000000000000066c <kill>:
.global kill
kill:
 li a7, SYS_kill
 66c:	4899                	li	a7,6
 ecall
 66e:	00000073          	ecall
 ret
 672:	8082                	ret

0000000000000674 <exec>:
.global exec
exec:
 li a7, SYS_exec
 674:	489d                	li	a7,7
 ecall
 676:	00000073          	ecall
 ret
 67a:	8082                	ret

000000000000067c <open>:
.global open
open:
 li a7, SYS_open
 67c:	48bd                	li	a7,15
 ecall
 67e:	00000073          	ecall
 ret
 682:	8082                	ret

0000000000000684 <mknod>:
.global mknod
mknod:
 li a7, SYS_mknod
 684:	48c5                	li	a7,17
 ecall
 686:	00000073          	ecall
 ret
 68a:	8082                	ret

000000000000068c <unlink>:
.global unlink
unlink:
 li a7, SYS_unlink
 68c:	48c9                	li	a7,18
 ecall
 68e:	00000073          	ecall
 ret
 692:	8082                	ret

0000000000000694 <fstat>:
.global fstat
fstat:
 li a7, SYS_fstat
 694:	48a1                	li	a7,8
 ecall
 696:	00000073          	ecall
 ret
 69a:	8082                	ret

000000000000069c <link>:
.global link
link:
 li a7, SYS_link
 69c:	48cd                	li	a7,19
 ecall
 69e:	00000073          	ecall
 ret
 6a2:	8082                	ret

00000000000006a4 <mkdir>:
.global mkdir
mkdir:
 li a7, SYS_mkdir
 6a4:	48d1                	li	a7,20
 ecall
 6a6:	00000073          	ecall
 ret
 6aa:	8082                	ret

00000000000006ac <chdir>:
.global chdir
chdir:
 li a7, SYS_chdir
 6ac:	48a5                	li	a7,9
 ecall
 6ae:	00000073          	ecall
 ret
 6b2:	8082                	ret

00000000000006b4 <dup>:
.global dup
dup:
 li a7, SYS_dup
 6b4:	48a9                	li	a7,10
 ecall
 6b6:	00000073          	ecall
 ret
 6ba:	8082                	ret

00000000000006bc <getpid>:
.global getpid
getpid:
 li a7, SYS_getpid
 6bc:	48ad                	li	a7,11
 ecall
 6be:	00000073          	ecall
 ret
 6c2:	8082                	ret

00000000000006c4 <sbrk>:
.global sbrk
sbrk:
 li a7, SYS_sbrk
 6c4:	48b1                	li	a7,12
 ecall
 6c6:	00000073          	ecall
 ret
 6ca:	8082                	ret

00000000000006cc <sleep>:
.global sleep
sleep:
 li a7, SYS_sleep
 6cc:	48b5                	li	a7,13
 ecall
 6ce:	00000073          	ecall
 ret
 6d2:	8082                	ret

00000000000006d4 <uptime>:
.global uptime
uptime:
 li a7, SYS_uptime
 6d4:	48b9                	li	a7,14
 ecall
 6d6:	00000073          	ecall
 ret
 6da:	8082                	ret

00000000000006dc <spoon>:
.global spoon
spoon:
 li a7, SYS_spoon
 6dc:	48d9                	li	a7,22
 ecall
 6de:	00000073          	ecall
 ret
 6e2:	8082                	ret

00000000000006e4 <create_thread>:
.global create_thread
create_thread:
 li a7, SYS_create_thread
 6e4:	48dd                	li	a7,23
 ecall
 6e6:	00000073          	ecall
 ret
 6ea:	8082                	ret

00000000000006ec <join_thread>:
.global join_thread
join_thread:
 li a7, SYS_join_thread
 6ec:	48e1                	li	a7,24
 ecall
 6ee:	00000073          	ecall
 ret
 6f2:	8082                	ret

00000000000006f4 <thread_exit>:
.global thread_exit
thread_exit:
 li a7, SYS_thread_exit
 6f4:	48e5                	li	a7,25
 ecall
 6f6:	00000073          	ecall
 ret
 6fa:	8082                	ret

00000000000006fc <socket>:
.global socket
socket:
 li a7, SYS_socket
 6fc:	48e9                	li	a7,26
 ecall
 6fe:	00000073          	ecall
 ret
 702:	8082                	ret

0000000000000704 <bind>:
.global bind
bind:
 li a7, SYS_bind
 704:	48ed                	li	a7,27
 ecall
 706:	00000073          	ecall
 ret
 70a:	8082                	ret

000000000000070c <accept>:
.global accept
accept:
 li a7, SYS_accept
 70c:	48f5                	li	a7,29
 ecall
 70e:	00000073          	ecall
 ret
 712:	8082                	ret

0000000000000714 <listen>:
.global listen
listen:
 li a7, SYS_listen
 714:	48f1                	li	a7,28
 ecall
 716:	00000073          	ecall
 ret
 71a:	8082                	ret

000000000000071c <connect>:
.global connect
connect:
 li a7, SYS_connect
 71c:	48f9                	li	a7,30
 ecall
 71e:	00000073          	ecall
 ret
 722:	8082                	ret

0000000000000724 <send>:
.global send
send:
 li a7, SYS_send
 724:	48fd                	li	a7,31
 ecall
 726:	00000073          	ecall
 ret
 72a:	8082                	ret

000000000000072c <recv>:
.global recv
recv:
 li a7, SYS_recv
 72c:	02000893          	li	a7,32
 ecall
 730:	00000073          	ecall
 ret
 734:	8082                	ret

0000000000000736 <sendto>:
.global sendto
sendto:
 li a7, SYS_sendto
 736:	02100893          	li	a7,33
 ecall
 73a:	00000073          	ecall
 ret
 73e:	8082                	ret

0000000000000740 <recvfrom>:
.global recvfrom
recvfrom:
 li a7, SYS_recvfrom
 740:	02200893          	li	a7,34
 ecall
 744:	00000073          	ecall
 ret
 748:	8082                	ret

000000000000074a <putc>:

static char digits[] = "0123456789ABCDEF";

static void
putc(int fd, char c)
{
 74a:	1101                	addi	sp,sp,-32
 74c:	ec06                	sd	ra,24(sp)
 74e:	e822                	sd	s0,16(sp)
 750:	1000                	addi	s0,sp,32
 752:	feb407a3          	sb	a1,-17(s0)
  write(fd, &c, 1);
 756:	4605                	li	a2,1
 758:	fef40593          	addi	a1,s0,-17
 75c:	00000097          	auipc	ra,0x0
 760:	f00080e7          	jalr	-256(ra) # 65c <write>
}
 764:	60e2                	ld	ra,24(sp)
 766:	6442                	ld	s0,16(sp)
 768:	6105                	addi	sp,sp,32
 76a:	8082                	ret

000000000000076c <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
 76c:	7139                	addi	sp,sp,-64
 76e:	fc06                	sd	ra,56(sp)
 770:	f822                	sd	s0,48(sp)
 772:	f426                	sd	s1,40(sp)
 774:	0080                	addi	s0,sp,64
 776:	84aa                	mv	s1,a0
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
  if(sgn && xx < 0){
 778:	c299                	beqz	a3,77e <printint+0x12>
 77a:	0805cb63          	bltz	a1,810 <printint+0xa4>
    neg = 1;
    x = -xx;
  } else {
    x = xx;
 77e:	2581                	sext.w	a1,a1
  neg = 0;
 780:	4881                	li	a7,0
 782:	fc040693          	addi	a3,s0,-64
  }

  i = 0;
 786:	4701                	li	a4,0
  do{
    buf[i++] = digits[x % base];
 788:	2601                	sext.w	a2,a2
 78a:	00000517          	auipc	a0,0x0
 78e:	75e50513          	addi	a0,a0,1886 # ee8 <digits>
 792:	883a                	mv	a6,a4
 794:	2705                	addiw	a4,a4,1
 796:	02c5f7bb          	remuw	a5,a1,a2
 79a:	1782                	slli	a5,a5,0x20
 79c:	9381                	srli	a5,a5,0x20
 79e:	97aa                	add	a5,a5,a0
 7a0:	0007c783          	lbu	a5,0(a5)
 7a4:	00f68023          	sb	a5,0(a3)
  }while((x /= base) != 0);
 7a8:	0005879b          	sext.w	a5,a1
 7ac:	02c5d5bb          	divuw	a1,a1,a2
 7b0:	0685                	addi	a3,a3,1
 7b2:	fec7f0e3          	bgeu	a5,a2,792 <printint+0x26>
  if(neg)
 7b6:	00088c63          	beqz	a7,7ce <printint+0x62>
    buf[i++] = '-';
 7ba:	fd070793          	addi	a5,a4,-48
 7be:	00878733          	add	a4,a5,s0
 7c2:	02d00793          	li	a5,45
 7c6:	fef70823          	sb	a5,-16(a4)
 7ca:	0028071b          	addiw	a4,a6,2

  while(--i >= 0)
 7ce:	02e05c63          	blez	a4,806 <printint+0x9a>
 7d2:	f04a                	sd	s2,32(sp)
 7d4:	ec4e                	sd	s3,24(sp)
 7d6:	fc040793          	addi	a5,s0,-64
 7da:	00e78933          	add	s2,a5,a4
 7de:	fff78993          	addi	s3,a5,-1
 7e2:	99ba                	add	s3,s3,a4
 7e4:	377d                	addiw	a4,a4,-1
 7e6:	1702                	slli	a4,a4,0x20
 7e8:	9301                	srli	a4,a4,0x20
 7ea:	40e989b3          	sub	s3,s3,a4
    putc(fd, buf[i]);
 7ee:	fff94583          	lbu	a1,-1(s2)
 7f2:	8526                	mv	a0,s1
 7f4:	00000097          	auipc	ra,0x0
 7f8:	f56080e7          	jalr	-170(ra) # 74a <putc>
  while(--i >= 0)
 7fc:	197d                	addi	s2,s2,-1
 7fe:	ff3918e3          	bne	s2,s3,7ee <printint+0x82>
 802:	7902                	ld	s2,32(sp)
 804:	69e2                	ld	s3,24(sp)
}
 806:	70e2                	ld	ra,56(sp)
 808:	7442                	ld	s0,48(sp)
 80a:	74a2                	ld	s1,40(sp)
 80c:	6121                	addi	sp,sp,64
 80e:	8082                	ret
    x = -xx;
 810:	40b005bb          	negw	a1,a1
    neg = 1;
 814:	4885                	li	a7,1
    x = -xx;
 816:	b7b5                	j	782 <printint+0x16>

0000000000000818 <vprintf>:
}

// Print to the given fd. Only understands %d, %x, %p, %s.
void
vprintf(int fd, const char *fmt, va_list ap)
{
 818:	715d                	addi	sp,sp,-80
 81a:	e486                	sd	ra,72(sp)
 81c:	e0a2                	sd	s0,64(sp)
 81e:	f84a                	sd	s2,48(sp)
 820:	0880                	addi	s0,sp,80
  char *s;
  int c, i, state;

  state = 0;
  for(i = 0; fmt[i]; i++){
 822:	0005c903          	lbu	s2,0(a1)
 826:	1a090a63          	beqz	s2,9da <vprintf+0x1c2>
 82a:	fc26                	sd	s1,56(sp)
 82c:	f44e                	sd	s3,40(sp)
 82e:	f052                	sd	s4,32(sp)
 830:	ec56                	sd	s5,24(sp)
 832:	e85a                	sd	s6,16(sp)
 834:	e45e                	sd	s7,8(sp)
 836:	8aaa                	mv	s5,a0
 838:	8bb2                	mv	s7,a2
 83a:	00158493          	addi	s1,a1,1
  state = 0;
 83e:	4981                	li	s3,0
      if(c == '%'){
        state = '%';
      } else {
        putc(fd, c);
      }
    } else if(state == '%'){
 840:	02500a13          	li	s4,37
 844:	4b55                	li	s6,21
 846:	a839                	j	864 <vprintf+0x4c>
        putc(fd, c);
 848:	85ca                	mv	a1,s2
 84a:	8556                	mv	a0,s5
 84c:	00000097          	auipc	ra,0x0
 850:	efe080e7          	jalr	-258(ra) # 74a <putc>
 854:	a019                	j	85a <vprintf+0x42>
    } else if(state == '%'){
 856:	01498d63          	beq	s3,s4,870 <vprintf+0x58>
  for(i = 0; fmt[i]; i++){
 85a:	0485                	addi	s1,s1,1
 85c:	fff4c903          	lbu	s2,-1(s1)
 860:	16090763          	beqz	s2,9ce <vprintf+0x1b6>
    if(state == 0){
 864:	fe0999e3          	bnez	s3,856 <vprintf+0x3e>
      if(c == '%'){
 868:	ff4910e3          	bne	s2,s4,848 <vprintf+0x30>
        state = '%';
 86c:	89d2                	mv	s3,s4
 86e:	b7f5                	j	85a <vprintf+0x42>
      if(c == 'd'){
 870:	13490463          	beq	s2,s4,998 <vprintf+0x180>
 874:	f9d9079b          	addiw	a5,s2,-99
 878:	0ff7f793          	zext.b	a5,a5
 87c:	12fb6763          	bltu	s6,a5,9aa <vprintf+0x192>
 880:	f9d9079b          	addiw	a5,s2,-99
 884:	0ff7f713          	zext.b	a4,a5
 888:	12eb6163          	bltu	s6,a4,9aa <vprintf+0x192>
 88c:	00271793          	slli	a5,a4,0x2
 890:	00000717          	auipc	a4,0x0
 894:	60070713          	addi	a4,a4,1536 # e90 <ithread_join+0xc0>
 898:	97ba                	add	a5,a5,a4
 89a:	439c                	lw	a5,0(a5)
 89c:	97ba                	add	a5,a5,a4
 89e:	8782                	jr	a5
        printint(fd, va_arg(ap, int), 10, 1);
 8a0:	008b8913          	addi	s2,s7,8
 8a4:	4685                	li	a3,1
 8a6:	4629                	li	a2,10
 8a8:	000ba583          	lw	a1,0(s7)
 8ac:	8556                	mv	a0,s5
 8ae:	00000097          	auipc	ra,0x0
 8b2:	ebe080e7          	jalr	-322(ra) # 76c <printint>
 8b6:	8bca                	mv	s7,s2
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
        putc(fd, c);
      }
      state = 0;
 8b8:	4981                	li	s3,0
 8ba:	b745                	j	85a <vprintf+0x42>
        printint(fd, va_arg(ap, uint64), 10, 0);
 8bc:	008b8913          	addi	s2,s7,8
 8c0:	4681                	li	a3,0
 8c2:	4629                	li	a2,10
 8c4:	000ba583          	lw	a1,0(s7)
 8c8:	8556                	mv	a0,s5
 8ca:	00000097          	auipc	ra,0x0
 8ce:	ea2080e7          	jalr	-350(ra) # 76c <printint>
 8d2:	8bca                	mv	s7,s2
      state = 0;
 8d4:	4981                	li	s3,0
 8d6:	b751                	j	85a <vprintf+0x42>
        printint(fd, va_arg(ap, int), 16, 0);
 8d8:	008b8913          	addi	s2,s7,8
 8dc:	4681                	li	a3,0
 8de:	4641                	li	a2,16
 8e0:	000ba583          	lw	a1,0(s7)
 8e4:	8556                	mv	a0,s5
 8e6:	00000097          	auipc	ra,0x0
 8ea:	e86080e7          	jalr	-378(ra) # 76c <printint>
 8ee:	8bca                	mv	s7,s2
      state = 0;
 8f0:	4981                	li	s3,0
 8f2:	b7a5                	j	85a <vprintf+0x42>
 8f4:	e062                	sd	s8,0(sp)
        printptr(fd, va_arg(ap, uint64));
 8f6:	008b8c13          	addi	s8,s7,8
 8fa:	000bb983          	ld	s3,0(s7)
  putc(fd, '0');
 8fe:	03000593          	li	a1,48
 902:	8556                	mv	a0,s5
 904:	00000097          	auipc	ra,0x0
 908:	e46080e7          	jalr	-442(ra) # 74a <putc>
  putc(fd, 'x');
 90c:	07800593          	li	a1,120
 910:	8556                	mv	a0,s5
 912:	00000097          	auipc	ra,0x0
 916:	e38080e7          	jalr	-456(ra) # 74a <putc>
 91a:	4941                	li	s2,16
    putc(fd, digits[x >> (sizeof(uint64) * 8 - 4)]);
 91c:	00000b97          	auipc	s7,0x0
 920:	5ccb8b93          	addi	s7,s7,1484 # ee8 <digits>
 924:	03c9d793          	srli	a5,s3,0x3c
 928:	97de                	add	a5,a5,s7
 92a:	0007c583          	lbu	a1,0(a5)
 92e:	8556                	mv	a0,s5
 930:	00000097          	auipc	ra,0x0
 934:	e1a080e7          	jalr	-486(ra) # 74a <putc>
  for (i = 0; i < (sizeof(uint64) * 2); i++, x <<= 4)
 938:	0992                	slli	s3,s3,0x4
 93a:	397d                	addiw	s2,s2,-1
 93c:	fe0914e3          	bnez	s2,924 <vprintf+0x10c>
        printptr(fd, va_arg(ap, uint64));
 940:	8be2                	mv	s7,s8
      state = 0;
 942:	4981                	li	s3,0
 944:	6c02                	ld	s8,0(sp)
 946:	bf11                	j	85a <vprintf+0x42>
        s = va_arg(ap, char*);
 948:	008b8993          	addi	s3,s7,8
 94c:	000bb903          	ld	s2,0(s7)
        if(s == 0)
 950:	02090163          	beqz	s2,972 <vprintf+0x15a>
        while(*s != 0){
 954:	00094583          	lbu	a1,0(s2)
 958:	c9a5                	beqz	a1,9c8 <vprintf+0x1b0>
          putc(fd, *s);
 95a:	8556                	mv	a0,s5
 95c:	00000097          	auipc	ra,0x0
 960:	dee080e7          	jalr	-530(ra) # 74a <putc>
          s++;
 964:	0905                	addi	s2,s2,1
        while(*s != 0){
 966:	00094583          	lbu	a1,0(s2)
 96a:	f9e5                	bnez	a1,95a <vprintf+0x142>
        s = va_arg(ap, char*);
 96c:	8bce                	mv	s7,s3
      state = 0;
 96e:	4981                	li	s3,0
 970:	b5ed                	j	85a <vprintf+0x42>
          s = "(null)";
 972:	00000917          	auipc	s2,0x0
 976:	4e690913          	addi	s2,s2,1254 # e58 <ithread_join+0x88>
        while(*s != 0){
 97a:	02800593          	li	a1,40
 97e:	bff1                	j	95a <vprintf+0x142>
        putc(fd, va_arg(ap, uint));
 980:	008b8913          	addi	s2,s7,8
 984:	000bc583          	lbu	a1,0(s7)
 988:	8556                	mv	a0,s5
 98a:	00000097          	auipc	ra,0x0
 98e:	dc0080e7          	jalr	-576(ra) # 74a <putc>
 992:	8bca                	mv	s7,s2
      state = 0;
 994:	4981                	li	s3,0
 996:	b5d1                	j	85a <vprintf+0x42>
        putc(fd, c);
 998:	02500593          	li	a1,37
 99c:	8556                	mv	a0,s5
 99e:	00000097          	auipc	ra,0x0
 9a2:	dac080e7          	jalr	-596(ra) # 74a <putc>
      state = 0;
 9a6:	4981                	li	s3,0
 9a8:	bd4d                	j	85a <vprintf+0x42>
        putc(fd, '%');
 9aa:	02500593          	li	a1,37
 9ae:	8556                	mv	a0,s5
 9b0:	00000097          	auipc	ra,0x0
 9b4:	d9a080e7          	jalr	-614(ra) # 74a <putc>
        putc(fd, c);
 9b8:	85ca                	mv	a1,s2
 9ba:	8556                	mv	a0,s5
 9bc:	00000097          	auipc	ra,0x0
 9c0:	d8e080e7          	jalr	-626(ra) # 74a <putc>
      state = 0;
 9c4:	4981                	li	s3,0
 9c6:	bd51                	j	85a <vprintf+0x42>
        s = va_arg(ap, char*);
 9c8:	8bce                	mv	s7,s3
      state = 0;
 9ca:	4981                	li	s3,0
 9cc:	b579                	j	85a <vprintf+0x42>
 9ce:	74e2                	ld	s1,56(sp)
 9d0:	79a2                	ld	s3,40(sp)
 9d2:	7a02                	ld	s4,32(sp)
 9d4:	6ae2                	ld	s5,24(sp)
 9d6:	6b42                	ld	s6,16(sp)
 9d8:	6ba2                	ld	s7,8(sp)
    }
  }
}
 9da:	60a6                	ld	ra,72(sp)
 9dc:	6406                	ld	s0,64(sp)
 9de:	7942                	ld	s2,48(sp)
 9e0:	6161                	addi	sp,sp,80
 9e2:	8082                	ret

00000000000009e4 <fprintf>:

void
fprintf(int fd, const char *fmt, ...)
{
 9e4:	715d                	addi	sp,sp,-80
 9e6:	ec06                	sd	ra,24(sp)
 9e8:	e822                	sd	s0,16(sp)
 9ea:	1000                	addi	s0,sp,32
 9ec:	e010                	sd	a2,0(s0)
 9ee:	e414                	sd	a3,8(s0)
 9f0:	e818                	sd	a4,16(s0)
 9f2:	ec1c                	sd	a5,24(s0)
 9f4:	03043023          	sd	a6,32(s0)
 9f8:	03143423          	sd	a7,40(s0)
  va_list ap;

  va_start(ap, fmt);
 9fc:	fe843423          	sd	s0,-24(s0)
  vprintf(fd, fmt, ap);
 a00:	8622                	mv	a2,s0
 a02:	00000097          	auipc	ra,0x0
 a06:	e16080e7          	jalr	-490(ra) # 818 <vprintf>
}
 a0a:	60e2                	ld	ra,24(sp)
 a0c:	6442                	ld	s0,16(sp)
 a0e:	6161                	addi	sp,sp,80
 a10:	8082                	ret

0000000000000a12 <printf>:

void
printf(const char *fmt, ...)
{
 a12:	711d                	addi	sp,sp,-96
 a14:	ec06                	sd	ra,24(sp)
 a16:	e822                	sd	s0,16(sp)
 a18:	1000                	addi	s0,sp,32
 a1a:	e40c                	sd	a1,8(s0)
 a1c:	e810                	sd	a2,16(s0)
 a1e:	ec14                	sd	a3,24(s0)
 a20:	f018                	sd	a4,32(s0)
 a22:	f41c                	sd	a5,40(s0)
 a24:	03043823          	sd	a6,48(s0)
 a28:	03143c23          	sd	a7,56(s0)
  va_list ap;

  va_start(ap, fmt);
 a2c:	00840613          	addi	a2,s0,8
 a30:	fec43423          	sd	a2,-24(s0)
  vprintf(1, fmt, ap);
 a34:	85aa                	mv	a1,a0
 a36:	4505                	li	a0,1
 a38:	00000097          	auipc	ra,0x0
 a3c:	de0080e7          	jalr	-544(ra) # 818 <vprintf>
}
 a40:	60e2                	ld	ra,24(sp)
 a42:	6442                	ld	s0,16(sp)
 a44:	6125                	addi	sp,sp,96
 a46:	8082                	ret

0000000000000a48 <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 a48:	1141                	addi	sp,sp,-16
 a4a:	e422                	sd	s0,8(sp)
 a4c:	0800                	addi	s0,sp,16
  Header *bp, *p;

  bp = (Header*)ap - 1;
 a4e:	ff050693          	addi	a3,a0,-16
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 a52:	00000797          	auipc	a5,0x0
 a56:	5be7b783          	ld	a5,1470(a5) # 1010 <freep>
 a5a:	a02d                	j	a84 <free+0x3c>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
      break;
  if(bp + bp->s.size == p->s.ptr){
    bp->s.size += p->s.ptr->s.size;
 a5c:	4618                	lw	a4,8(a2)
 a5e:	9f2d                	addw	a4,a4,a1
 a60:	fee52c23          	sw	a4,-8(a0)
    bp->s.ptr = p->s.ptr->s.ptr;
 a64:	6398                	ld	a4,0(a5)
 a66:	6310                	ld	a2,0(a4)
 a68:	a83d                	j	aa6 <free+0x5e>
  } else
    bp->s.ptr = p->s.ptr;
  if(p + p->s.size == bp){
    p->s.size += bp->s.size;
 a6a:	ff852703          	lw	a4,-8(a0)
 a6e:	9f31                	addw	a4,a4,a2
 a70:	c798                	sw	a4,8(a5)
    p->s.ptr = bp->s.ptr;
 a72:	ff053683          	ld	a3,-16(a0)
 a76:	a091                	j	aba <free+0x72>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 a78:	6398                	ld	a4,0(a5)
 a7a:	00e7e463          	bltu	a5,a4,a82 <free+0x3a>
 a7e:	00e6ea63          	bltu	a3,a4,a92 <free+0x4a>
{
 a82:	87ba                	mv	a5,a4
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 a84:	fed7fae3          	bgeu	a5,a3,a78 <free+0x30>
 a88:	6398                	ld	a4,0(a5)
 a8a:	00e6e463          	bltu	a3,a4,a92 <free+0x4a>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 a8e:	fee7eae3          	bltu	a5,a4,a82 <free+0x3a>
  if(bp + bp->s.size == p->s.ptr){
 a92:	ff852583          	lw	a1,-8(a0)
 a96:	6390                	ld	a2,0(a5)
 a98:	02059813          	slli	a6,a1,0x20
 a9c:	01c85713          	srli	a4,a6,0x1c
 aa0:	9736                	add	a4,a4,a3
 aa2:	fae60de3          	beq	a2,a4,a5c <free+0x14>
    bp->s.ptr = p->s.ptr->s.ptr;
 aa6:	fec53823          	sd	a2,-16(a0)
  if(p + p->s.size == bp){
 aaa:	4790                	lw	a2,8(a5)
 aac:	02061593          	slli	a1,a2,0x20
 ab0:	01c5d713          	srli	a4,a1,0x1c
 ab4:	973e                	add	a4,a4,a5
 ab6:	fae68ae3          	beq	a3,a4,a6a <free+0x22>
    p->s.ptr = bp->s.ptr;
 aba:	e394                	sd	a3,0(a5)
  } else
    p->s.ptr = bp;
  freep = p;
 abc:	00000717          	auipc	a4,0x0
 ac0:	54f73a23          	sd	a5,1364(a4) # 1010 <freep>
}
 ac4:	6422                	ld	s0,8(sp)
 ac6:	0141                	addi	sp,sp,16
 ac8:	8082                	ret

0000000000000aca <malloc>:
  return freep;
}

void*
malloc(uint nbytes)
{
 aca:	7139                	addi	sp,sp,-64
 acc:	fc06                	sd	ra,56(sp)
 ace:	f822                	sd	s0,48(sp)
 ad0:	f426                	sd	s1,40(sp)
 ad2:	ec4e                	sd	s3,24(sp)
 ad4:	0080                	addi	s0,sp,64
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 ad6:	02051493          	slli	s1,a0,0x20
 ada:	9081                	srli	s1,s1,0x20
 adc:	04bd                	addi	s1,s1,15
 ade:	8091                	srli	s1,s1,0x4
 ae0:	0014899b          	addiw	s3,s1,1
 ae4:	0485                	addi	s1,s1,1
  if((prevp = freep) == 0){
 ae6:	00000517          	auipc	a0,0x0
 aea:	52a53503          	ld	a0,1322(a0) # 1010 <freep>
 aee:	c915                	beqz	a0,b22 <malloc+0x58>
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 af0:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
 af2:	4798                	lw	a4,8(a5)
 af4:	08977e63          	bgeu	a4,s1,b90 <malloc+0xc6>
 af8:	f04a                	sd	s2,32(sp)
 afa:	e852                	sd	s4,16(sp)
 afc:	e456                	sd	s5,8(sp)
 afe:	e05a                	sd	s6,0(sp)
  if(nu < 4096)
 b00:	8a4e                	mv	s4,s3
 b02:	0009871b          	sext.w	a4,s3
 b06:	6685                	lui	a3,0x1
 b08:	00d77363          	bgeu	a4,a3,b0e <malloc+0x44>
 b0c:	6a05                	lui	s4,0x1
 b0e:	000a0b1b          	sext.w	s6,s4
  p = sbrk(nu * sizeof(Header));
 b12:	004a1a1b          	slliw	s4,s4,0x4
        p->s.size = nunits;
      }
      freep = prevp;
      return (void*)(p + 1);
    }
    if(p == freep)
 b16:	00000917          	auipc	s2,0x0
 b1a:	4fa90913          	addi	s2,s2,1274 # 1010 <freep>
  if(p == (char*)-1)
 b1e:	5afd                	li	s5,-1
 b20:	a091                	j	b64 <malloc+0x9a>
 b22:	f04a                	sd	s2,32(sp)
 b24:	e852                	sd	s4,16(sp)
 b26:	e456                	sd	s5,8(sp)
 b28:	e05a                	sd	s6,0(sp)
    base.s.ptr = freep = prevp = &base;
 b2a:	00001797          	auipc	a5,0x1
 b2e:	90678793          	addi	a5,a5,-1786 # 1430 <base>
 b32:	00000717          	auipc	a4,0x0
 b36:	4cf73f23          	sd	a5,1246(a4) # 1010 <freep>
 b3a:	e39c                	sd	a5,0(a5)
    base.s.size = 0;
 b3c:	0007a423          	sw	zero,8(a5)
    if(p->s.size >= nunits){
 b40:	b7c1                	j	b00 <malloc+0x36>
        prevp->s.ptr = p->s.ptr;
 b42:	6398                	ld	a4,0(a5)
 b44:	e118                	sd	a4,0(a0)
 b46:	a08d                	j	ba8 <malloc+0xde>
  hp->s.size = nu;
 b48:	01652423          	sw	s6,8(a0)
  free((void*)(hp + 1));
 b4c:	0541                	addi	a0,a0,16
 b4e:	00000097          	auipc	ra,0x0
 b52:	efa080e7          	jalr	-262(ra) # a48 <free>
  return freep;
 b56:	00093503          	ld	a0,0(s2)
      if((p = morecore(nunits)) == 0)
 b5a:	c13d                	beqz	a0,bc0 <malloc+0xf6>
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 b5c:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
 b5e:	4798                	lw	a4,8(a5)
 b60:	02977463          	bgeu	a4,s1,b88 <malloc+0xbe>
    if(p == freep)
 b64:	00093703          	ld	a4,0(s2)
 b68:	853e                	mv	a0,a5
 b6a:	fef719e3          	bne	a4,a5,b5c <malloc+0x92>
  p = sbrk(nu * sizeof(Header));
 b6e:	8552                	mv	a0,s4
 b70:	00000097          	auipc	ra,0x0
 b74:	b54080e7          	jalr	-1196(ra) # 6c4 <sbrk>
  if(p == (char*)-1)
 b78:	fd5518e3          	bne	a0,s5,b48 <malloc+0x7e>
        return 0;
 b7c:	4501                	li	a0,0
 b7e:	7902                	ld	s2,32(sp)
 b80:	6a42                	ld	s4,16(sp)
 b82:	6aa2                	ld	s5,8(sp)
 b84:	6b02                	ld	s6,0(sp)
 b86:	a03d                	j	bb4 <malloc+0xea>
 b88:	7902                	ld	s2,32(sp)
 b8a:	6a42                	ld	s4,16(sp)
 b8c:	6aa2                	ld	s5,8(sp)
 b8e:	6b02                	ld	s6,0(sp)
      if(p->s.size == nunits)
 b90:	fae489e3          	beq	s1,a4,b42 <malloc+0x78>
        p->s.size -= nunits;
 b94:	4137073b          	subw	a4,a4,s3
 b98:	c798                	sw	a4,8(a5)
        p += p->s.size;
 b9a:	02071693          	slli	a3,a4,0x20
 b9e:	01c6d713          	srli	a4,a3,0x1c
 ba2:	97ba                	add	a5,a5,a4
        p->s.size = nunits;
 ba4:	0137a423          	sw	s3,8(a5)
      freep = prevp;
 ba8:	00000717          	auipc	a4,0x0
 bac:	46a73423          	sd	a0,1128(a4) # 1010 <freep>
      return (void*)(p + 1);
 bb0:	01078513          	addi	a0,a5,16
  }
}
 bb4:	70e2                	ld	ra,56(sp)
 bb6:	7442                	ld	s0,48(sp)
 bb8:	74a2                	ld	s1,40(sp)
 bba:	69e2                	ld	s3,24(sp)
 bbc:	6121                	addi	sp,sp,64
 bbe:	8082                	ret
 bc0:	7902                	ld	s2,32(sp)
 bc2:	6a42                	ld	s4,16(sp)
 bc4:	6aa2                	ld	s5,8(sp)
 bc6:	6b02                	ld	s6,0(sp)
 bc8:	b7f5                	j	bb4 <malloc+0xea>

0000000000000bca <ithread_exit>:
  free(stacks);
  stacks = new_stacks;
  return 0;
}

void ithread_exit(uint64 status) {
 bca:	1141                	addi	sp,sp,-16
 bcc:	e406                	sd	ra,8(sp)
 bce:	e022                	sd	s0,0(sp)
 bd0:	0800                	addi	s0,sp,16
  thread_exit(status);
 bd2:	2501                	sext.w	a0,a0
 bd4:	00000097          	auipc	ra,0x0
 bd8:	b20080e7          	jalr	-1248(ra) # 6f4 <thread_exit>
}
 bdc:	60a2                	ld	ra,8(sp)
 bde:	6402                	ld	s0,0(sp)
 be0:	0141                	addi	sp,sp,16
 be2:	8082                	ret

0000000000000be4 <free_stacks>:
int free_stacks() {
 be4:	7179                	addi	sp,sp,-48
 be6:	f406                	sd	ra,40(sp)
 be8:	f022                	sd	s0,32(sp)
 bea:	ec26                	sd	s1,24(sp)
 bec:	1800                	addi	s0,sp,48
  for (int i = 0; i < num_threads; i++) {
 bee:	00000797          	auipc	a5,0x0
 bf2:	4327a783          	lw	a5,1074(a5) # 1020 <num_threads>
 bf6:	04f05063          	blez	a5,c36 <free_stacks+0x52>
 bfa:	e84a                	sd	s2,16(sp)
 bfc:	e44e                	sd	s3,8(sp)
 bfe:	4481                	li	s1,0
    free(stacks[i]);
 c00:	00000997          	auipc	s3,0x0
 c04:	41898993          	addi	s3,s3,1048 # 1018 <stacks>
  for (int i = 0; i < num_threads; i++) {
 c08:	00000917          	auipc	s2,0x0
 c0c:	41890913          	addi	s2,s2,1048 # 1020 <num_threads>
    free(stacks[i]);
 c10:	0009b783          	ld	a5,0(s3)
 c14:	00349713          	slli	a4,s1,0x3
 c18:	97ba                	add	a5,a5,a4
 c1a:	6388                	ld	a0,0(a5)
 c1c:	00000097          	auipc	ra,0x0
 c20:	e2c080e7          	jalr	-468(ra) # a48 <free>
  for (int i = 0; i < num_threads; i++) {
 c24:	0485                	addi	s1,s1,1
 c26:	00092703          	lw	a4,0(s2)
 c2a:	0004879b          	sext.w	a5,s1
 c2e:	fee7c1e3          	blt	a5,a4,c10 <free_stacks+0x2c>
 c32:	6942                	ld	s2,16(sp)
 c34:	69a2                	ld	s3,8(sp)
  free(stacks);
 c36:	00000497          	auipc	s1,0x0
 c3a:	3e248493          	addi	s1,s1,994 # 1018 <stacks>
 c3e:	6088                	ld	a0,0(s1)
 c40:	00000097          	auipc	ra,0x0
 c44:	e08080e7          	jalr	-504(ra) # a48 <free>
  stacks = 0;
 c48:	0004b023          	sd	zero,0(s1)
  num_threads = 0;
 c4c:	00000797          	auipc	a5,0x0
 c50:	3c07aa23          	sw	zero,980(a5) # 1020 <num_threads>
  max_stacks = INIT_MAX_STACKS;
 c54:	47a1                	li	a5,8
 c56:	00000717          	auipc	a4,0x0
 c5a:	3af72523          	sw	a5,938(a4) # 1000 <max_stacks>
  threads_done = 0;
 c5e:	00000797          	auipc	a5,0x0
 c62:	3c07a323          	sw	zero,966(a5) # 1024 <threads_done>
}
 c66:	4501                	li	a0,0
 c68:	70a2                	ld	ra,40(sp)
 c6a:	7402                	ld	s0,32(sp)
 c6c:	64e2                	ld	s1,24(sp)
 c6e:	6145                	addi	sp,sp,48
 c70:	8082                	ret

0000000000000c72 <expand_num_threads>:
int expand_num_threads() {
 c72:	1101                	addi	sp,sp,-32
 c74:	ec06                	sd	ra,24(sp)
 c76:	e822                	sd	s0,16(sp)
 c78:	e426                	sd	s1,8(sp)
 c7a:	e04a                	sd	s2,0(sp)
 c7c:	1000                	addi	s0,sp,32
  max_stacks *= 2;
 c7e:	00000797          	auipc	a5,0x0
 c82:	38278793          	addi	a5,a5,898 # 1000 <max_stacks>
 c86:	4388                	lw	a0,0(a5)
 c88:	0015151b          	slliw	a0,a0,0x1
 c8c:	c388                	sw	a0,0(a5)
  void **new_stacks = malloc(max_stacks*sizeof(char*));
 c8e:	0035151b          	slliw	a0,a0,0x3
 c92:	00000097          	auipc	ra,0x0
 c96:	e38080e7          	jalr	-456(ra) # aca <malloc>
 c9a:	892a                	mv	s2,a0
  memmove(new_stacks, stacks, num_threads*sizeof(char*));
 c9c:	00000617          	auipc	a2,0x0
 ca0:	38462603          	lw	a2,900(a2) # 1020 <num_threads>
 ca4:	00000497          	auipc	s1,0x0
 ca8:	37448493          	addi	s1,s1,884 # 1018 <stacks>
 cac:	0036161b          	slliw	a2,a2,0x3
 cb0:	608c                	ld	a1,0(s1)
 cb2:	00000097          	auipc	ra,0x0
 cb6:	840080e7          	jalr	-1984(ra) # 4f2 <memmove>
  free(stacks);
 cba:	6088                	ld	a0,0(s1)
 cbc:	00000097          	auipc	ra,0x0
 cc0:	d8c080e7          	jalr	-628(ra) # a48 <free>
  stacks = new_stacks;
 cc4:	0124b023          	sd	s2,0(s1)
}
 cc8:	4501                	li	a0,0
 cca:	60e2                	ld	ra,24(sp)
 ccc:	6442                	ld	s0,16(sp)
 cce:	64a2                	ld	s1,8(sp)
 cd0:	6902                	ld	s2,0(sp)
 cd2:	6105                	addi	sp,sp,32
 cd4:	8082                	ret

0000000000000cd6 <ithread_create>:

int ithread_create(void* (*fn_ptr)(void *), void *args) {
 cd6:	7179                	addi	sp,sp,-48
 cd8:	f406                	sd	ra,40(sp)
 cda:	f022                	sd	s0,32(sp)
 cdc:	e84a                	sd	s2,16(sp)
 cde:	e44e                	sd	s3,8(sp)
 ce0:	1800                	addi	s0,sp,48
 ce2:	892a                	mv	s2,a0
 ce4:	89ae                	mv	s3,a1
  if (stacks == 0) {
 ce6:	00000797          	auipc	a5,0x0
 cea:	3327b783          	ld	a5,818(a5) # 1018 <stacks>
 cee:	c3d9                	beqz	a5,d74 <ithread_create+0x9e>
    stacks = malloc(max_stacks*sizeof(char*));
  }
  if (num_threads == max_stacks) {
 cf0:	00000797          	auipc	a5,0x0
 cf4:	3107a783          	lw	a5,784(a5) # 1000 <max_stacks>
 cf8:	00000717          	auipc	a4,0x0
 cfc:	32872703          	lw	a4,808(a4) # 1020 <num_threads>
 d00:	0af71363          	bne	a4,a5,da6 <ithread_create+0xd0>
    if (max_stacks == MAX_THREADS) {
 d04:	04000713          	li	a4,64
 d08:	08e78563          	beq	a5,a4,d92 <ithread_create+0xbc>
 d0c:	ec26                	sd	s1,24(sp)
      printf("ERROR: Thread capacity has been reached\n");
      return -1;
    }
    expand_num_threads();
 d0e:	00000097          	auipc	ra,0x0
 d12:	f64080e7          	jalr	-156(ra) # c72 <expand_num_threads>
  }

  void *stack_ptr = malloc(PGSIZE);
 d16:	6505                	lui	a0,0x1
 d18:	00000097          	auipc	ra,0x0
 d1c:	db2080e7          	jalr	-590(ra) # aca <malloc>
 d20:	84aa                	mv	s1,a0
  stacks[num_threads] = stack_ptr;
 d22:	00000717          	auipc	a4,0x0
 d26:	2fe72703          	lw	a4,766(a4) # 1020 <num_threads>
 d2a:	070e                	slli	a4,a4,0x3
 d2c:	00000797          	auipc	a5,0x0
 d30:	2ec7b783          	ld	a5,748(a5) # 1018 <stacks>
 d34:	97ba                	add	a5,a5,a4
 d36:	e388                	sd	a0,0(a5)
  int res = create_thread(fn_ptr, args, stack_ptr, &ithread_exit);
 d38:	00000697          	auipc	a3,0x0
 d3c:	e9268693          	addi	a3,a3,-366 # bca <ithread_exit>
 d40:	862a                	mv	a2,a0
 d42:	85ce                	mv	a1,s3
 d44:	854a                	mv	a0,s2
 d46:	00000097          	auipc	ra,0x0
 d4a:	99e080e7          	jalr	-1634(ra) # 6e4 <create_thread>
 d4e:	892a                	mv	s2,a0
  if (res != -1) {
 d50:	57fd                	li	a5,-1
 d52:	04f50c63          	beq	a0,a5,daa <ithread_create+0xd4>
    num_threads++;
 d56:	00000717          	auipc	a4,0x0
 d5a:	2ca70713          	addi	a4,a4,714 # 1020 <num_threads>
 d5e:	431c                	lw	a5,0(a4)
 d60:	2785                	addiw	a5,a5,1
 d62:	c31c                	sw	a5,0(a4)
 d64:	64e2                	ld	s1,24(sp)
  } else {
    free(stack_ptr);
    stacks[num_threads] = 0;
  }
  return res;
}
 d66:	854a                	mv	a0,s2
 d68:	70a2                	ld	ra,40(sp)
 d6a:	7402                	ld	s0,32(sp)
 d6c:	6942                	ld	s2,16(sp)
 d6e:	69a2                	ld	s3,8(sp)
 d70:	6145                	addi	sp,sp,48
 d72:	8082                	ret
    stacks = malloc(max_stacks*sizeof(char*));
 d74:	00000517          	auipc	a0,0x0
 d78:	28c52503          	lw	a0,652(a0) # 1000 <max_stacks>
 d7c:	0035151b          	slliw	a0,a0,0x3
 d80:	00000097          	auipc	ra,0x0
 d84:	d4a080e7          	jalr	-694(ra) # aca <malloc>
 d88:	00000797          	auipc	a5,0x0
 d8c:	28a7b823          	sd	a0,656(a5) # 1018 <stacks>
 d90:	b785                	j	cf0 <ithread_create+0x1a>
      printf("ERROR: Thread capacity has been reached\n");
 d92:	00000517          	auipc	a0,0x0
 d96:	0ce50513          	addi	a0,a0,206 # e60 <ithread_join+0x90>
 d9a:	00000097          	auipc	ra,0x0
 d9e:	c78080e7          	jalr	-904(ra) # a12 <printf>
      return -1;
 da2:	597d                	li	s2,-1
 da4:	b7c9                	j	d66 <ithread_create+0x90>
 da6:	ec26                	sd	s1,24(sp)
 da8:	b7bd                	j	d16 <ithread_create+0x40>
    free(stack_ptr);
 daa:	8526                	mv	a0,s1
 dac:	00000097          	auipc	ra,0x0
 db0:	c9c080e7          	jalr	-868(ra) # a48 <free>
    stacks[num_threads] = 0;
 db4:	00000717          	auipc	a4,0x0
 db8:	26c72703          	lw	a4,620(a4) # 1020 <num_threads>
 dbc:	070e                	slli	a4,a4,0x3
 dbe:	00000797          	auipc	a5,0x0
 dc2:	25a7b783          	ld	a5,602(a5) # 1018 <stacks>
 dc6:	97ba                	add	a5,a5,a4
 dc8:	0007b023          	sd	zero,0(a5)
 dcc:	64e2                	ld	s1,24(sp)
 dce:	bf61                	j	d66 <ithread_create+0x90>

0000000000000dd0 <ithread_join>:

int ithread_join(int thread_id) {
 dd0:	1101                	addi	sp,sp,-32
 dd2:	ec06                	sd	ra,24(sp)
 dd4:	e822                	sd	s0,16(sp)
 dd6:	1000                	addi	s0,sp,32
  int status;
  join_thread(thread_id, (uint64)&status);
 dd8:	ff040793          	addi	a5,s0,-16
 ddc:	ffc7859b          	addiw	a1,a5,-4
 de0:	00000097          	auipc	ra,0x0
 de4:	90c080e7          	jalr	-1780(ra) # 6ec <join_thread>
  threads_done++;
 de8:	00000717          	auipc	a4,0x0
 dec:	23c70713          	addi	a4,a4,572 # 1024 <threads_done>
 df0:	431c                	lw	a5,0(a4)
 df2:	2785                	addiw	a5,a5,1
 df4:	0007869b          	sext.w	a3,a5
 df8:	c31c                	sw	a5,0(a4)
  if (threads_done == num_threads) {
 dfa:	00000797          	auipc	a5,0x0
 dfe:	2267a783          	lw	a5,550(a5) # 1020 <num_threads>
 e02:	00d78863          	beq	a5,a3,e12 <ithread_join+0x42>
    free_stacks();
  }
  return status;
}
 e06:	fec42503          	lw	a0,-20(s0)
 e0a:	60e2                	ld	ra,24(sp)
 e0c:	6442                	ld	s0,16(sp)
 e0e:	6105                	addi	sp,sp,32
 e10:	8082                	ret
    free_stacks();
 e12:	00000097          	auipc	ra,0x0
 e16:	dd2080e7          	jalr	-558(ra) # be4 <free_stacks>
 e1a:	b7f5                	j	e06 <ithread_join+0x36>
