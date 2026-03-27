
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
 182:	3d2080e7          	jalr	978(ra) # 550 <write>
 186:	b7c1                	j	146 <grep+0x2c>
    if(m > 0){
 188:	03404763          	bgtz	s4,1b6 <grep+0x9c>
  while((n = read(fd, buf+m, sizeof(buf)-m-1)) > 0){
 18c:	414b863b          	subw	a2,s7,s4
 190:	014a85b3          	add	a1,s5,s4
 194:	855a                	mv	a0,s6
 196:	00000097          	auipc	ra,0x0
 19a:	3b2080e7          	jalr	946(ra) # 548 <read>
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
 1ce:	2b4080e7          	jalr	692(ra) # 47e <memmove>
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
 22a:	34a080e7          	jalr	842(ra) # 570 <open>
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
 246:	316080e7          	jalr	790(ra) # 558 <close>
  for(i = 2; i < argc; i++){
 24a:	0921                	addi	s2,s2,8
 24c:	fd391ae3          	bne	s2,s3,220 <main+0x34>
  exit(0);
 250:	4501                	li	a0,0
 252:	00000097          	auipc	ra,0x0
 256:	2de080e7          	jalr	734(ra) # 530 <exit>
    fprintf(2, "usage: grep pattern [file ...]\n");
 25a:	00001597          	auipc	a1,0x1
 25e:	ab658593          	addi	a1,a1,-1354 # d10 <ithread_join+0x4c>
 262:	4509                	li	a0,2
 264:	00000097          	auipc	ra,0x0
 268:	674080e7          	jalr	1652(ra) # 8d8 <fprintf>
    exit(1);
 26c:	4505                	li	a0,1
 26e:	00000097          	auipc	ra,0x0
 272:	2c2080e7          	jalr	706(ra) # 530 <exit>
    grep(pattern, 0);
 276:	4581                	li	a1,0
 278:	8552                	mv	a0,s4
 27a:	00000097          	auipc	ra,0x0
 27e:	ea0080e7          	jalr	-352(ra) # 11a <grep>
    exit(0);
 282:	4501                	li	a0,0
 284:	00000097          	auipc	ra,0x0
 288:	2ac080e7          	jalr	684(ra) # 530 <exit>
      printf("grep: cannot open %s\n", argv[i]);
 28c:	00093583          	ld	a1,0(s2)
 290:	00001517          	auipc	a0,0x1
 294:	aa050513          	addi	a0,a0,-1376 # d30 <ithread_join+0x6c>
 298:	00000097          	auipc	ra,0x0
 29c:	66e080e7          	jalr	1646(ra) # 906 <printf>
      exit(1);
 2a0:	4505                	li	a0,1
 2a2:	00000097          	auipc	ra,0x0
 2a6:	28e080e7          	jalr	654(ra) # 530 <exit>

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
 2c0:	274080e7          	jalr	628(ra) # 530 <exit>

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
 3b2:	19a080e7          	jalr	410(ra) # 548 <read>
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

00000000000003f0 <stat>:

int
stat(const char *n, struct stat *st)
{
 3f0:	1101                	addi	sp,sp,-32
 3f2:	ec06                	sd	ra,24(sp)
 3f4:	e822                	sd	s0,16(sp)
 3f6:	e04a                	sd	s2,0(sp)
 3f8:	1000                	addi	s0,sp,32
 3fa:	892e                	mv	s2,a1
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 3fc:	4581                	li	a1,0
 3fe:	00000097          	auipc	ra,0x0
 402:	172080e7          	jalr	370(ra) # 570 <open>
  if(fd < 0)
 406:	02054663          	bltz	a0,432 <stat+0x42>
 40a:	e426                	sd	s1,8(sp)
 40c:	84aa                	mv	s1,a0
    return -1;
  r = fstat(fd, st);
 40e:	85ca                	mv	a1,s2
 410:	00000097          	auipc	ra,0x0
 414:	178080e7          	jalr	376(ra) # 588 <fstat>
 418:	892a                	mv	s2,a0
  close(fd);
 41a:	8526                	mv	a0,s1
 41c:	00000097          	auipc	ra,0x0
 420:	13c080e7          	jalr	316(ra) # 558 <close>
  return r;
 424:	64a2                	ld	s1,8(sp)
}
 426:	854a                	mv	a0,s2
 428:	60e2                	ld	ra,24(sp)
 42a:	6442                	ld	s0,16(sp)
 42c:	6902                	ld	s2,0(sp)
 42e:	6105                	addi	sp,sp,32
 430:	8082                	ret
    return -1;
 432:	597d                	li	s2,-1
 434:	bfcd                	j	426 <stat+0x36>

0000000000000436 <atoi>:

int
atoi(const char *s)
{
 436:	1141                	addi	sp,sp,-16
 438:	e422                	sd	s0,8(sp)
 43a:	0800                	addi	s0,sp,16
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
 43c:	00054683          	lbu	a3,0(a0)
 440:	fd06879b          	addiw	a5,a3,-48
 444:	0ff7f793          	zext.b	a5,a5
 448:	4625                	li	a2,9
 44a:	02f66863          	bltu	a2,a5,47a <atoi+0x44>
 44e:	872a                	mv	a4,a0
  n = 0;
 450:	4501                	li	a0,0
    n = n*10 + *s++ - '0';
 452:	0705                	addi	a4,a4,1
 454:	0025179b          	slliw	a5,a0,0x2
 458:	9fa9                	addw	a5,a5,a0
 45a:	0017979b          	slliw	a5,a5,0x1
 45e:	9fb5                	addw	a5,a5,a3
 460:	fd07851b          	addiw	a0,a5,-48
  while('0' <= *s && *s <= '9')
 464:	00074683          	lbu	a3,0(a4)
 468:	fd06879b          	addiw	a5,a3,-48
 46c:	0ff7f793          	zext.b	a5,a5
 470:	fef671e3          	bgeu	a2,a5,452 <atoi+0x1c>
  return n;
}
 474:	6422                	ld	s0,8(sp)
 476:	0141                	addi	sp,sp,16
 478:	8082                	ret
  n = 0;
 47a:	4501                	li	a0,0
 47c:	bfe5                	j	474 <atoi+0x3e>

000000000000047e <memmove>:

void*
memmove(void *vdst, const void *vsrc, int n)
{
 47e:	1141                	addi	sp,sp,-16
 480:	e422                	sd	s0,8(sp)
 482:	0800                	addi	s0,sp,16
  char *dst;
  const char *src;

  dst = vdst;
  src = vsrc;
  if (src > dst) {
 484:	02b57463          	bgeu	a0,a1,4ac <memmove+0x2e>
    while(n-- > 0)
 488:	00c05f63          	blez	a2,4a6 <memmove+0x28>
 48c:	1602                	slli	a2,a2,0x20
 48e:	9201                	srli	a2,a2,0x20
 490:	00c507b3          	add	a5,a0,a2
  dst = vdst;
 494:	872a                	mv	a4,a0
      *dst++ = *src++;
 496:	0585                	addi	a1,a1,1
 498:	0705                	addi	a4,a4,1
 49a:	fff5c683          	lbu	a3,-1(a1)
 49e:	fed70fa3          	sb	a3,-1(a4)
    while(n-- > 0)
 4a2:	fef71ae3          	bne	a4,a5,496 <memmove+0x18>
    src += n;
    while(n-- > 0)
      *--dst = *--src;
  }
  return vdst;
}
 4a6:	6422                	ld	s0,8(sp)
 4a8:	0141                	addi	sp,sp,16
 4aa:	8082                	ret
    dst += n;
 4ac:	00c50733          	add	a4,a0,a2
    src += n;
 4b0:	95b2                	add	a1,a1,a2
    while(n-- > 0)
 4b2:	fec05ae3          	blez	a2,4a6 <memmove+0x28>
 4b6:	fff6079b          	addiw	a5,a2,-1
 4ba:	1782                	slli	a5,a5,0x20
 4bc:	9381                	srli	a5,a5,0x20
 4be:	fff7c793          	not	a5,a5
 4c2:	97ba                	add	a5,a5,a4
      *--dst = *--src;
 4c4:	15fd                	addi	a1,a1,-1
 4c6:	177d                	addi	a4,a4,-1
 4c8:	0005c683          	lbu	a3,0(a1)
 4cc:	00d70023          	sb	a3,0(a4)
    while(n-- > 0)
 4d0:	fee79ae3          	bne	a5,a4,4c4 <memmove+0x46>
 4d4:	bfc9                	j	4a6 <memmove+0x28>

00000000000004d6 <memcmp>:

int
memcmp(const void *s1, const void *s2, uint n)
{
 4d6:	1141                	addi	sp,sp,-16
 4d8:	e422                	sd	s0,8(sp)
 4da:	0800                	addi	s0,sp,16
  const char *p1 = s1, *p2 = s2;
  while (n-- > 0) {
 4dc:	ca05                	beqz	a2,50c <memcmp+0x36>
 4de:	fff6069b          	addiw	a3,a2,-1
 4e2:	1682                	slli	a3,a3,0x20
 4e4:	9281                	srli	a3,a3,0x20
 4e6:	0685                	addi	a3,a3,1
 4e8:	96aa                	add	a3,a3,a0
    if (*p1 != *p2) {
 4ea:	00054783          	lbu	a5,0(a0)
 4ee:	0005c703          	lbu	a4,0(a1)
 4f2:	00e79863          	bne	a5,a4,502 <memcmp+0x2c>
      return *p1 - *p2;
    }
    p1++;
 4f6:	0505                	addi	a0,a0,1
    p2++;
 4f8:	0585                	addi	a1,a1,1
  while (n-- > 0) {
 4fa:	fed518e3          	bne	a0,a3,4ea <memcmp+0x14>
  }
  return 0;
 4fe:	4501                	li	a0,0
 500:	a019                	j	506 <memcmp+0x30>
      return *p1 - *p2;
 502:	40e7853b          	subw	a0,a5,a4
}
 506:	6422                	ld	s0,8(sp)
 508:	0141                	addi	sp,sp,16
 50a:	8082                	ret
  return 0;
 50c:	4501                	li	a0,0
 50e:	bfe5                	j	506 <memcmp+0x30>

0000000000000510 <memcpy>:

void *
memcpy(void *dst, const void *src, uint n)
{
 510:	1141                	addi	sp,sp,-16
 512:	e406                	sd	ra,8(sp)
 514:	e022                	sd	s0,0(sp)
 516:	0800                	addi	s0,sp,16
  return memmove(dst, src, n);
 518:	00000097          	auipc	ra,0x0
 51c:	f66080e7          	jalr	-154(ra) # 47e <memmove>
}
 520:	60a2                	ld	ra,8(sp)
 522:	6402                	ld	s0,0(sp)
 524:	0141                	addi	sp,sp,16
 526:	8082                	ret

0000000000000528 <fork>:
# generated by usys.pl - do not edit
#include "kernel/syscall.h"
.global fork
fork:
 li a7, SYS_fork
 528:	4885                	li	a7,1
 ecall
 52a:	00000073          	ecall
 ret
 52e:	8082                	ret

0000000000000530 <exit>:
.global exit
exit:
 li a7, SYS_exit
 530:	4889                	li	a7,2
 ecall
 532:	00000073          	ecall
 ret
 536:	8082                	ret

0000000000000538 <wait>:
.global wait
wait:
 li a7, SYS_wait
 538:	488d                	li	a7,3
 ecall
 53a:	00000073          	ecall
 ret
 53e:	8082                	ret

0000000000000540 <pipe>:
.global pipe
pipe:
 li a7, SYS_pipe
 540:	4891                	li	a7,4
 ecall
 542:	00000073          	ecall
 ret
 546:	8082                	ret

0000000000000548 <read>:
.global read
read:
 li a7, SYS_read
 548:	4895                	li	a7,5
 ecall
 54a:	00000073          	ecall
 ret
 54e:	8082                	ret

0000000000000550 <write>:
.global write
write:
 li a7, SYS_write
 550:	48c1                	li	a7,16
 ecall
 552:	00000073          	ecall
 ret
 556:	8082                	ret

0000000000000558 <close>:
.global close
close:
 li a7, SYS_close
 558:	48d5                	li	a7,21
 ecall
 55a:	00000073          	ecall
 ret
 55e:	8082                	ret

0000000000000560 <kill>:
.global kill
kill:
 li a7, SYS_kill
 560:	4899                	li	a7,6
 ecall
 562:	00000073          	ecall
 ret
 566:	8082                	ret

0000000000000568 <exec>:
.global exec
exec:
 li a7, SYS_exec
 568:	489d                	li	a7,7
 ecall
 56a:	00000073          	ecall
 ret
 56e:	8082                	ret

0000000000000570 <open>:
.global open
open:
 li a7, SYS_open
 570:	48bd                	li	a7,15
 ecall
 572:	00000073          	ecall
 ret
 576:	8082                	ret

0000000000000578 <mknod>:
.global mknod
mknod:
 li a7, SYS_mknod
 578:	48c5                	li	a7,17
 ecall
 57a:	00000073          	ecall
 ret
 57e:	8082                	ret

0000000000000580 <unlink>:
.global unlink
unlink:
 li a7, SYS_unlink
 580:	48c9                	li	a7,18
 ecall
 582:	00000073          	ecall
 ret
 586:	8082                	ret

0000000000000588 <fstat>:
.global fstat
fstat:
 li a7, SYS_fstat
 588:	48a1                	li	a7,8
 ecall
 58a:	00000073          	ecall
 ret
 58e:	8082                	ret

0000000000000590 <link>:
.global link
link:
 li a7, SYS_link
 590:	48cd                	li	a7,19
 ecall
 592:	00000073          	ecall
 ret
 596:	8082                	ret

0000000000000598 <mkdir>:
.global mkdir
mkdir:
 li a7, SYS_mkdir
 598:	48d1                	li	a7,20
 ecall
 59a:	00000073          	ecall
 ret
 59e:	8082                	ret

00000000000005a0 <chdir>:
.global chdir
chdir:
 li a7, SYS_chdir
 5a0:	48a5                	li	a7,9
 ecall
 5a2:	00000073          	ecall
 ret
 5a6:	8082                	ret

00000000000005a8 <dup>:
.global dup
dup:
 li a7, SYS_dup
 5a8:	48a9                	li	a7,10
 ecall
 5aa:	00000073          	ecall
 ret
 5ae:	8082                	ret

00000000000005b0 <getpid>:
.global getpid
getpid:
 li a7, SYS_getpid
 5b0:	48ad                	li	a7,11
 ecall
 5b2:	00000073          	ecall
 ret
 5b6:	8082                	ret

00000000000005b8 <sbrk>:
.global sbrk
sbrk:
 li a7, SYS_sbrk
 5b8:	48b1                	li	a7,12
 ecall
 5ba:	00000073          	ecall
 ret
 5be:	8082                	ret

00000000000005c0 <sleep>:
.global sleep
sleep:
 li a7, SYS_sleep
 5c0:	48b5                	li	a7,13
 ecall
 5c2:	00000073          	ecall
 ret
 5c6:	8082                	ret

00000000000005c8 <uptime>:
.global uptime
uptime:
 li a7, SYS_uptime
 5c8:	48b9                	li	a7,14
 ecall
 5ca:	00000073          	ecall
 ret
 5ce:	8082                	ret

00000000000005d0 <spoon>:
.global spoon
spoon:
 li a7, SYS_spoon
 5d0:	48d9                	li	a7,22
 ecall
 5d2:	00000073          	ecall
 ret
 5d6:	8082                	ret

00000000000005d8 <create_thread>:
.global create_thread
create_thread:
 li a7, SYS_create_thread
 5d8:	48dd                	li	a7,23
 ecall
 5da:	00000073          	ecall
 ret
 5de:	8082                	ret

00000000000005e0 <join_thread>:
.global join_thread
join_thread:
 li a7, SYS_join_thread
 5e0:	48e1                	li	a7,24
 ecall
 5e2:	00000073          	ecall
 ret
 5e6:	8082                	ret

00000000000005e8 <thread_exit>:
.global thread_exit
thread_exit:
 li a7, SYS_thread_exit
 5e8:	48e5                	li	a7,25
 ecall
 5ea:	00000073          	ecall
 ret
 5ee:	8082                	ret

00000000000005f0 <socket>:
.global socket
socket:
 li a7, SYS_socket
 5f0:	48e9                	li	a7,26
 ecall
 5f2:	00000073          	ecall
 ret
 5f6:	8082                	ret

00000000000005f8 <bind>:
.global bind
bind:
 li a7, SYS_bind
 5f8:	48ed                	li	a7,27
 ecall
 5fa:	00000073          	ecall
 ret
 5fe:	8082                	ret

0000000000000600 <accept>:
.global accept
accept:
 li a7, SYS_accept
 600:	48f5                	li	a7,29
 ecall
 602:	00000073          	ecall
 ret
 606:	8082                	ret

0000000000000608 <listen>:
.global listen
listen:
 li a7, SYS_listen
 608:	48f1                	li	a7,28
 ecall
 60a:	00000073          	ecall
 ret
 60e:	8082                	ret

0000000000000610 <connect>:
.global connect
connect:
 li a7, SYS_connect
 610:	48f9                	li	a7,30
 ecall
 612:	00000073          	ecall
 ret
 616:	8082                	ret

0000000000000618 <send>:
.global send
send:
 li a7, SYS_send
 618:	48fd                	li	a7,31
 ecall
 61a:	00000073          	ecall
 ret
 61e:	8082                	ret

0000000000000620 <recv>:
.global recv
recv:
 li a7, SYS_recv
 620:	02000893          	li	a7,32
 ecall
 624:	00000073          	ecall
 ret
 628:	8082                	ret

000000000000062a <sendto>:
.global sendto
sendto:
 li a7, SYS_sendto
 62a:	02100893          	li	a7,33
 ecall
 62e:	00000073          	ecall
 ret
 632:	8082                	ret

0000000000000634 <recvfrom>:
.global recvfrom
recvfrom:
 li a7, SYS_recvfrom
 634:	02200893          	li	a7,34
 ecall
 638:	00000073          	ecall
 ret
 63c:	8082                	ret

000000000000063e <putc>:

static char digits[] = "0123456789ABCDEF";

static void
putc(int fd, char c)
{
 63e:	1101                	addi	sp,sp,-32
 640:	ec06                	sd	ra,24(sp)
 642:	e822                	sd	s0,16(sp)
 644:	1000                	addi	s0,sp,32
 646:	feb407a3          	sb	a1,-17(s0)
  write(fd, &c, 1);
 64a:	4605                	li	a2,1
 64c:	fef40593          	addi	a1,s0,-17
 650:	00000097          	auipc	ra,0x0
 654:	f00080e7          	jalr	-256(ra) # 550 <write>
}
 658:	60e2                	ld	ra,24(sp)
 65a:	6442                	ld	s0,16(sp)
 65c:	6105                	addi	sp,sp,32
 65e:	8082                	ret

0000000000000660 <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
 660:	7139                	addi	sp,sp,-64
 662:	fc06                	sd	ra,56(sp)
 664:	f822                	sd	s0,48(sp)
 666:	f426                	sd	s1,40(sp)
 668:	0080                	addi	s0,sp,64
 66a:	84aa                	mv	s1,a0
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
  if(sgn && xx < 0){
 66c:	c299                	beqz	a3,672 <printint+0x12>
 66e:	0805cb63          	bltz	a1,704 <printint+0xa4>
    neg = 1;
    x = -xx;
  } else {
    x = xx;
 672:	2581                	sext.w	a1,a1
  neg = 0;
 674:	4881                	li	a7,0
 676:	fc040693          	addi	a3,s0,-64
  }

  i = 0;
 67a:	4701                	li	a4,0
  do{
    buf[i++] = digits[x % base];
 67c:	2601                	sext.w	a2,a2
 67e:	00000517          	auipc	a0,0x0
 682:	75a50513          	addi	a0,a0,1882 # dd8 <digits>
 686:	883a                	mv	a6,a4
 688:	2705                	addiw	a4,a4,1
 68a:	02c5f7bb          	remuw	a5,a1,a2
 68e:	1782                	slli	a5,a5,0x20
 690:	9381                	srli	a5,a5,0x20
 692:	97aa                	add	a5,a5,a0
 694:	0007c783          	lbu	a5,0(a5)
 698:	00f68023          	sb	a5,0(a3)
  }while((x /= base) != 0);
 69c:	0005879b          	sext.w	a5,a1
 6a0:	02c5d5bb          	divuw	a1,a1,a2
 6a4:	0685                	addi	a3,a3,1
 6a6:	fec7f0e3          	bgeu	a5,a2,686 <printint+0x26>
  if(neg)
 6aa:	00088c63          	beqz	a7,6c2 <printint+0x62>
    buf[i++] = '-';
 6ae:	fd070793          	addi	a5,a4,-48
 6b2:	00878733          	add	a4,a5,s0
 6b6:	02d00793          	li	a5,45
 6ba:	fef70823          	sb	a5,-16(a4)
 6be:	0028071b          	addiw	a4,a6,2

  while(--i >= 0)
 6c2:	02e05c63          	blez	a4,6fa <printint+0x9a>
 6c6:	f04a                	sd	s2,32(sp)
 6c8:	ec4e                	sd	s3,24(sp)
 6ca:	fc040793          	addi	a5,s0,-64
 6ce:	00e78933          	add	s2,a5,a4
 6d2:	fff78993          	addi	s3,a5,-1
 6d6:	99ba                	add	s3,s3,a4
 6d8:	377d                	addiw	a4,a4,-1
 6da:	1702                	slli	a4,a4,0x20
 6dc:	9301                	srli	a4,a4,0x20
 6de:	40e989b3          	sub	s3,s3,a4
    putc(fd, buf[i]);
 6e2:	fff94583          	lbu	a1,-1(s2)
 6e6:	8526                	mv	a0,s1
 6e8:	00000097          	auipc	ra,0x0
 6ec:	f56080e7          	jalr	-170(ra) # 63e <putc>
  while(--i >= 0)
 6f0:	197d                	addi	s2,s2,-1
 6f2:	ff3918e3          	bne	s2,s3,6e2 <printint+0x82>
 6f6:	7902                	ld	s2,32(sp)
 6f8:	69e2                	ld	s3,24(sp)
}
 6fa:	70e2                	ld	ra,56(sp)
 6fc:	7442                	ld	s0,48(sp)
 6fe:	74a2                	ld	s1,40(sp)
 700:	6121                	addi	sp,sp,64
 702:	8082                	ret
    x = -xx;
 704:	40b005bb          	negw	a1,a1
    neg = 1;
 708:	4885                	li	a7,1
    x = -xx;
 70a:	b7b5                	j	676 <printint+0x16>

000000000000070c <vprintf>:
}

// Print to the given fd. Only understands %d, %x, %p, %s.
void
vprintf(int fd, const char *fmt, va_list ap)
{
 70c:	715d                	addi	sp,sp,-80
 70e:	e486                	sd	ra,72(sp)
 710:	e0a2                	sd	s0,64(sp)
 712:	f84a                	sd	s2,48(sp)
 714:	0880                	addi	s0,sp,80
  char *s;
  int c, i, state;

  state = 0;
  for(i = 0; fmt[i]; i++){
 716:	0005c903          	lbu	s2,0(a1)
 71a:	1a090a63          	beqz	s2,8ce <vprintf+0x1c2>
 71e:	fc26                	sd	s1,56(sp)
 720:	f44e                	sd	s3,40(sp)
 722:	f052                	sd	s4,32(sp)
 724:	ec56                	sd	s5,24(sp)
 726:	e85a                	sd	s6,16(sp)
 728:	e45e                	sd	s7,8(sp)
 72a:	8aaa                	mv	s5,a0
 72c:	8bb2                	mv	s7,a2
 72e:	00158493          	addi	s1,a1,1
  state = 0;
 732:	4981                	li	s3,0
      if(c == '%'){
        state = '%';
      } else {
        putc(fd, c);
      }
    } else if(state == '%'){
 734:	02500a13          	li	s4,37
 738:	4b55                	li	s6,21
 73a:	a839                	j	758 <vprintf+0x4c>
        putc(fd, c);
 73c:	85ca                	mv	a1,s2
 73e:	8556                	mv	a0,s5
 740:	00000097          	auipc	ra,0x0
 744:	efe080e7          	jalr	-258(ra) # 63e <putc>
 748:	a019                	j	74e <vprintf+0x42>
    } else if(state == '%'){
 74a:	01498d63          	beq	s3,s4,764 <vprintf+0x58>
  for(i = 0; fmt[i]; i++){
 74e:	0485                	addi	s1,s1,1
 750:	fff4c903          	lbu	s2,-1(s1)
 754:	16090763          	beqz	s2,8c2 <vprintf+0x1b6>
    if(state == 0){
 758:	fe0999e3          	bnez	s3,74a <vprintf+0x3e>
      if(c == '%'){
 75c:	ff4910e3          	bne	s2,s4,73c <vprintf+0x30>
        state = '%';
 760:	89d2                	mv	s3,s4
 762:	b7f5                	j	74e <vprintf+0x42>
      if(c == 'd'){
 764:	13490463          	beq	s2,s4,88c <vprintf+0x180>
 768:	f9d9079b          	addiw	a5,s2,-99
 76c:	0ff7f793          	zext.b	a5,a5
 770:	12fb6763          	bltu	s6,a5,89e <vprintf+0x192>
 774:	f9d9079b          	addiw	a5,s2,-99
 778:	0ff7f713          	zext.b	a4,a5
 77c:	12eb6163          	bltu	s6,a4,89e <vprintf+0x192>
 780:	00271793          	slli	a5,a4,0x2
 784:	00000717          	auipc	a4,0x0
 788:	5fc70713          	addi	a4,a4,1532 # d80 <ithread_join+0xbc>
 78c:	97ba                	add	a5,a5,a4
 78e:	439c                	lw	a5,0(a5)
 790:	97ba                	add	a5,a5,a4
 792:	8782                	jr	a5
        printint(fd, va_arg(ap, int), 10, 1);
 794:	008b8913          	addi	s2,s7,8
 798:	4685                	li	a3,1
 79a:	4629                	li	a2,10
 79c:	000ba583          	lw	a1,0(s7)
 7a0:	8556                	mv	a0,s5
 7a2:	00000097          	auipc	ra,0x0
 7a6:	ebe080e7          	jalr	-322(ra) # 660 <printint>
 7aa:	8bca                	mv	s7,s2
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
        putc(fd, c);
      }
      state = 0;
 7ac:	4981                	li	s3,0
 7ae:	b745                	j	74e <vprintf+0x42>
        printint(fd, va_arg(ap, uint64), 10, 0);
 7b0:	008b8913          	addi	s2,s7,8
 7b4:	4681                	li	a3,0
 7b6:	4629                	li	a2,10
 7b8:	000ba583          	lw	a1,0(s7)
 7bc:	8556                	mv	a0,s5
 7be:	00000097          	auipc	ra,0x0
 7c2:	ea2080e7          	jalr	-350(ra) # 660 <printint>
 7c6:	8bca                	mv	s7,s2
      state = 0;
 7c8:	4981                	li	s3,0
 7ca:	b751                	j	74e <vprintf+0x42>
        printint(fd, va_arg(ap, int), 16, 0);
 7cc:	008b8913          	addi	s2,s7,8
 7d0:	4681                	li	a3,0
 7d2:	4641                	li	a2,16
 7d4:	000ba583          	lw	a1,0(s7)
 7d8:	8556                	mv	a0,s5
 7da:	00000097          	auipc	ra,0x0
 7de:	e86080e7          	jalr	-378(ra) # 660 <printint>
 7e2:	8bca                	mv	s7,s2
      state = 0;
 7e4:	4981                	li	s3,0
 7e6:	b7a5                	j	74e <vprintf+0x42>
 7e8:	e062                	sd	s8,0(sp)
        printptr(fd, va_arg(ap, uint64));
 7ea:	008b8c13          	addi	s8,s7,8
 7ee:	000bb983          	ld	s3,0(s7)
  putc(fd, '0');
 7f2:	03000593          	li	a1,48
 7f6:	8556                	mv	a0,s5
 7f8:	00000097          	auipc	ra,0x0
 7fc:	e46080e7          	jalr	-442(ra) # 63e <putc>
  putc(fd, 'x');
 800:	07800593          	li	a1,120
 804:	8556                	mv	a0,s5
 806:	00000097          	auipc	ra,0x0
 80a:	e38080e7          	jalr	-456(ra) # 63e <putc>
 80e:	4941                	li	s2,16
    putc(fd, digits[x >> (sizeof(uint64) * 8 - 4)]);
 810:	00000b97          	auipc	s7,0x0
 814:	5c8b8b93          	addi	s7,s7,1480 # dd8 <digits>
 818:	03c9d793          	srli	a5,s3,0x3c
 81c:	97de                	add	a5,a5,s7
 81e:	0007c583          	lbu	a1,0(a5)
 822:	8556                	mv	a0,s5
 824:	00000097          	auipc	ra,0x0
 828:	e1a080e7          	jalr	-486(ra) # 63e <putc>
  for (i = 0; i < (sizeof(uint64) * 2); i++, x <<= 4)
 82c:	0992                	slli	s3,s3,0x4
 82e:	397d                	addiw	s2,s2,-1
 830:	fe0914e3          	bnez	s2,818 <vprintf+0x10c>
        printptr(fd, va_arg(ap, uint64));
 834:	8be2                	mv	s7,s8
      state = 0;
 836:	4981                	li	s3,0
 838:	6c02                	ld	s8,0(sp)
 83a:	bf11                	j	74e <vprintf+0x42>
        s = va_arg(ap, char*);
 83c:	008b8993          	addi	s3,s7,8
 840:	000bb903          	ld	s2,0(s7)
        if(s == 0)
 844:	02090163          	beqz	s2,866 <vprintf+0x15a>
        while(*s != 0){
 848:	00094583          	lbu	a1,0(s2)
 84c:	c9a5                	beqz	a1,8bc <vprintf+0x1b0>
          putc(fd, *s);
 84e:	8556                	mv	a0,s5
 850:	00000097          	auipc	ra,0x0
 854:	dee080e7          	jalr	-530(ra) # 63e <putc>
          s++;
 858:	0905                	addi	s2,s2,1
        while(*s != 0){
 85a:	00094583          	lbu	a1,0(s2)
 85e:	f9e5                	bnez	a1,84e <vprintf+0x142>
        s = va_arg(ap, char*);
 860:	8bce                	mv	s7,s3
      state = 0;
 862:	4981                	li	s3,0
 864:	b5ed                	j	74e <vprintf+0x42>
          s = "(null)";
 866:	00000917          	auipc	s2,0x0
 86a:	4e290913          	addi	s2,s2,1250 # d48 <ithread_join+0x84>
        while(*s != 0){
 86e:	02800593          	li	a1,40
 872:	bff1                	j	84e <vprintf+0x142>
        putc(fd, va_arg(ap, uint));
 874:	008b8913          	addi	s2,s7,8
 878:	000bc583          	lbu	a1,0(s7)
 87c:	8556                	mv	a0,s5
 87e:	00000097          	auipc	ra,0x0
 882:	dc0080e7          	jalr	-576(ra) # 63e <putc>
 886:	8bca                	mv	s7,s2
      state = 0;
 888:	4981                	li	s3,0
 88a:	b5d1                	j	74e <vprintf+0x42>
        putc(fd, c);
 88c:	02500593          	li	a1,37
 890:	8556                	mv	a0,s5
 892:	00000097          	auipc	ra,0x0
 896:	dac080e7          	jalr	-596(ra) # 63e <putc>
      state = 0;
 89a:	4981                	li	s3,0
 89c:	bd4d                	j	74e <vprintf+0x42>
        putc(fd, '%');
 89e:	02500593          	li	a1,37
 8a2:	8556                	mv	a0,s5
 8a4:	00000097          	auipc	ra,0x0
 8a8:	d9a080e7          	jalr	-614(ra) # 63e <putc>
        putc(fd, c);
 8ac:	85ca                	mv	a1,s2
 8ae:	8556                	mv	a0,s5
 8b0:	00000097          	auipc	ra,0x0
 8b4:	d8e080e7          	jalr	-626(ra) # 63e <putc>
      state = 0;
 8b8:	4981                	li	s3,0
 8ba:	bd51                	j	74e <vprintf+0x42>
        s = va_arg(ap, char*);
 8bc:	8bce                	mv	s7,s3
      state = 0;
 8be:	4981                	li	s3,0
 8c0:	b579                	j	74e <vprintf+0x42>
 8c2:	74e2                	ld	s1,56(sp)
 8c4:	79a2                	ld	s3,40(sp)
 8c6:	7a02                	ld	s4,32(sp)
 8c8:	6ae2                	ld	s5,24(sp)
 8ca:	6b42                	ld	s6,16(sp)
 8cc:	6ba2                	ld	s7,8(sp)
    }
  }
}
 8ce:	60a6                	ld	ra,72(sp)
 8d0:	6406                	ld	s0,64(sp)
 8d2:	7942                	ld	s2,48(sp)
 8d4:	6161                	addi	sp,sp,80
 8d6:	8082                	ret

00000000000008d8 <fprintf>:

void
fprintf(int fd, const char *fmt, ...)
{
 8d8:	715d                	addi	sp,sp,-80
 8da:	ec06                	sd	ra,24(sp)
 8dc:	e822                	sd	s0,16(sp)
 8de:	1000                	addi	s0,sp,32
 8e0:	e010                	sd	a2,0(s0)
 8e2:	e414                	sd	a3,8(s0)
 8e4:	e818                	sd	a4,16(s0)
 8e6:	ec1c                	sd	a5,24(s0)
 8e8:	03043023          	sd	a6,32(s0)
 8ec:	03143423          	sd	a7,40(s0)
  va_list ap;

  va_start(ap, fmt);
 8f0:	fe843423          	sd	s0,-24(s0)
  vprintf(fd, fmt, ap);
 8f4:	8622                	mv	a2,s0
 8f6:	00000097          	auipc	ra,0x0
 8fa:	e16080e7          	jalr	-490(ra) # 70c <vprintf>
}
 8fe:	60e2                	ld	ra,24(sp)
 900:	6442                	ld	s0,16(sp)
 902:	6161                	addi	sp,sp,80
 904:	8082                	ret

0000000000000906 <printf>:

void
printf(const char *fmt, ...)
{
 906:	711d                	addi	sp,sp,-96
 908:	ec06                	sd	ra,24(sp)
 90a:	e822                	sd	s0,16(sp)
 90c:	1000                	addi	s0,sp,32
 90e:	e40c                	sd	a1,8(s0)
 910:	e810                	sd	a2,16(s0)
 912:	ec14                	sd	a3,24(s0)
 914:	f018                	sd	a4,32(s0)
 916:	f41c                	sd	a5,40(s0)
 918:	03043823          	sd	a6,48(s0)
 91c:	03143c23          	sd	a7,56(s0)
  va_list ap;

  va_start(ap, fmt);
 920:	00840613          	addi	a2,s0,8
 924:	fec43423          	sd	a2,-24(s0)
  vprintf(1, fmt, ap);
 928:	85aa                	mv	a1,a0
 92a:	4505                	li	a0,1
 92c:	00000097          	auipc	ra,0x0
 930:	de0080e7          	jalr	-544(ra) # 70c <vprintf>
}
 934:	60e2                	ld	ra,24(sp)
 936:	6442                	ld	s0,16(sp)
 938:	6125                	addi	sp,sp,96
 93a:	8082                	ret

000000000000093c <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 93c:	1141                	addi	sp,sp,-16
 93e:	e422                	sd	s0,8(sp)
 940:	0800                	addi	s0,sp,16
  Header *bp, *p;

  bp = (Header*)ap - 1;
 942:	ff050693          	addi	a3,a0,-16
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 946:	00000797          	auipc	a5,0x0
 94a:	6ca7b783          	ld	a5,1738(a5) # 1010 <freep>
 94e:	a02d                	j	978 <free+0x3c>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
      break;
  if(bp + bp->s.size == p->s.ptr){
    bp->s.size += p->s.ptr->s.size;
 950:	4618                	lw	a4,8(a2)
 952:	9f2d                	addw	a4,a4,a1
 954:	fee52c23          	sw	a4,-8(a0)
    bp->s.ptr = p->s.ptr->s.ptr;
 958:	6398                	ld	a4,0(a5)
 95a:	6310                	ld	a2,0(a4)
 95c:	a83d                	j	99a <free+0x5e>
  } else
    bp->s.ptr = p->s.ptr;
  if(p + p->s.size == bp){
    p->s.size += bp->s.size;
 95e:	ff852703          	lw	a4,-8(a0)
 962:	9f31                	addw	a4,a4,a2
 964:	c798                	sw	a4,8(a5)
    p->s.ptr = bp->s.ptr;
 966:	ff053683          	ld	a3,-16(a0)
 96a:	a091                	j	9ae <free+0x72>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 96c:	6398                	ld	a4,0(a5)
 96e:	00e7e463          	bltu	a5,a4,976 <free+0x3a>
 972:	00e6ea63          	bltu	a3,a4,986 <free+0x4a>
{
 976:	87ba                	mv	a5,a4
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 978:	fed7fae3          	bgeu	a5,a3,96c <free+0x30>
 97c:	6398                	ld	a4,0(a5)
 97e:	00e6e463          	bltu	a3,a4,986 <free+0x4a>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 982:	fee7eae3          	bltu	a5,a4,976 <free+0x3a>
  if(bp + bp->s.size == p->s.ptr){
 986:	ff852583          	lw	a1,-8(a0)
 98a:	6390                	ld	a2,0(a5)
 98c:	02059813          	slli	a6,a1,0x20
 990:	01c85713          	srli	a4,a6,0x1c
 994:	9736                	add	a4,a4,a3
 996:	fae60de3          	beq	a2,a4,950 <free+0x14>
    bp->s.ptr = p->s.ptr->s.ptr;
 99a:	fec53823          	sd	a2,-16(a0)
  if(p + p->s.size == bp){
 99e:	4790                	lw	a2,8(a5)
 9a0:	02061593          	slli	a1,a2,0x20
 9a4:	01c5d713          	srli	a4,a1,0x1c
 9a8:	973e                	add	a4,a4,a5
 9aa:	fae68ae3          	beq	a3,a4,95e <free+0x22>
    p->s.ptr = bp->s.ptr;
 9ae:	e394                	sd	a3,0(a5)
  } else
    p->s.ptr = bp;
  freep = p;
 9b0:	00000717          	auipc	a4,0x0
 9b4:	66f73023          	sd	a5,1632(a4) # 1010 <freep>
}
 9b8:	6422                	ld	s0,8(sp)
 9ba:	0141                	addi	sp,sp,16
 9bc:	8082                	ret

00000000000009be <malloc>:
  return freep;
}

void*
malloc(uint nbytes)
{
 9be:	7139                	addi	sp,sp,-64
 9c0:	fc06                	sd	ra,56(sp)
 9c2:	f822                	sd	s0,48(sp)
 9c4:	f426                	sd	s1,40(sp)
 9c6:	ec4e                	sd	s3,24(sp)
 9c8:	0080                	addi	s0,sp,64
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 9ca:	02051493          	slli	s1,a0,0x20
 9ce:	9081                	srli	s1,s1,0x20
 9d0:	04bd                	addi	s1,s1,15
 9d2:	8091                	srli	s1,s1,0x4
 9d4:	0014899b          	addiw	s3,s1,1
 9d8:	0485                	addi	s1,s1,1
  if((prevp = freep) == 0){
 9da:	00000517          	auipc	a0,0x0
 9de:	63653503          	ld	a0,1590(a0) # 1010 <freep>
 9e2:	c915                	beqz	a0,a16 <malloc+0x58>
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 9e4:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
 9e6:	4798                	lw	a4,8(a5)
 9e8:	08977e63          	bgeu	a4,s1,a84 <malloc+0xc6>
 9ec:	f04a                	sd	s2,32(sp)
 9ee:	e852                	sd	s4,16(sp)
 9f0:	e456                	sd	s5,8(sp)
 9f2:	e05a                	sd	s6,0(sp)
  if(nu < 4096)
 9f4:	8a4e                	mv	s4,s3
 9f6:	0009871b          	sext.w	a4,s3
 9fa:	6685                	lui	a3,0x1
 9fc:	00d77363          	bgeu	a4,a3,a02 <malloc+0x44>
 a00:	6a05                	lui	s4,0x1
 a02:	000a0b1b          	sext.w	s6,s4
  p = sbrk(nu * sizeof(Header));
 a06:	004a1a1b          	slliw	s4,s4,0x4
        p->s.size = nunits;
      }
      freep = prevp;
      return (void*)(p + 1);
    }
    if(p == freep)
 a0a:	00000917          	auipc	s2,0x0
 a0e:	60690913          	addi	s2,s2,1542 # 1010 <freep>
  if(p == (char*)-1)
 a12:	5afd                	li	s5,-1
 a14:	a091                	j	a58 <malloc+0x9a>
 a16:	f04a                	sd	s2,32(sp)
 a18:	e852                	sd	s4,16(sp)
 a1a:	e456                	sd	s5,8(sp)
 a1c:	e05a                	sd	s6,0(sp)
    base.s.ptr = freep = prevp = &base;
 a1e:	00001797          	auipc	a5,0x1
 a22:	a1278793          	addi	a5,a5,-1518 # 1430 <base>
 a26:	00000717          	auipc	a4,0x0
 a2a:	5ef73523          	sd	a5,1514(a4) # 1010 <freep>
 a2e:	e39c                	sd	a5,0(a5)
    base.s.size = 0;
 a30:	0007a423          	sw	zero,8(a5)
    if(p->s.size >= nunits){
 a34:	b7c1                	j	9f4 <malloc+0x36>
        prevp->s.ptr = p->s.ptr;
 a36:	6398                	ld	a4,0(a5)
 a38:	e118                	sd	a4,0(a0)
 a3a:	a08d                	j	a9c <malloc+0xde>
  hp->s.size = nu;
 a3c:	01652423          	sw	s6,8(a0)
  free((void*)(hp + 1));
 a40:	0541                	addi	a0,a0,16
 a42:	00000097          	auipc	ra,0x0
 a46:	efa080e7          	jalr	-262(ra) # 93c <free>
  return freep;
 a4a:	00093503          	ld	a0,0(s2)
      if((p = morecore(nunits)) == 0)
 a4e:	c13d                	beqz	a0,ab4 <malloc+0xf6>
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 a50:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
 a52:	4798                	lw	a4,8(a5)
 a54:	02977463          	bgeu	a4,s1,a7c <malloc+0xbe>
    if(p == freep)
 a58:	00093703          	ld	a4,0(s2)
 a5c:	853e                	mv	a0,a5
 a5e:	fef719e3          	bne	a4,a5,a50 <malloc+0x92>
  p = sbrk(nu * sizeof(Header));
 a62:	8552                	mv	a0,s4
 a64:	00000097          	auipc	ra,0x0
 a68:	b54080e7          	jalr	-1196(ra) # 5b8 <sbrk>
  if(p == (char*)-1)
 a6c:	fd5518e3          	bne	a0,s5,a3c <malloc+0x7e>
        return 0;
 a70:	4501                	li	a0,0
 a72:	7902                	ld	s2,32(sp)
 a74:	6a42                	ld	s4,16(sp)
 a76:	6aa2                	ld	s5,8(sp)
 a78:	6b02                	ld	s6,0(sp)
 a7a:	a03d                	j	aa8 <malloc+0xea>
 a7c:	7902                	ld	s2,32(sp)
 a7e:	6a42                	ld	s4,16(sp)
 a80:	6aa2                	ld	s5,8(sp)
 a82:	6b02                	ld	s6,0(sp)
      if(p->s.size == nunits)
 a84:	fae489e3          	beq	s1,a4,a36 <malloc+0x78>
        p->s.size -= nunits;
 a88:	4137073b          	subw	a4,a4,s3
 a8c:	c798                	sw	a4,8(a5)
        p += p->s.size;
 a8e:	02071693          	slli	a3,a4,0x20
 a92:	01c6d713          	srli	a4,a3,0x1c
 a96:	97ba                	add	a5,a5,a4
        p->s.size = nunits;
 a98:	0137a423          	sw	s3,8(a5)
      freep = prevp;
 a9c:	00000717          	auipc	a4,0x0
 aa0:	56a73a23          	sd	a0,1396(a4) # 1010 <freep>
      return (void*)(p + 1);
 aa4:	01078513          	addi	a0,a5,16
  }
}
 aa8:	70e2                	ld	ra,56(sp)
 aaa:	7442                	ld	s0,48(sp)
 aac:	74a2                	ld	s1,40(sp)
 aae:	69e2                	ld	s3,24(sp)
 ab0:	6121                	addi	sp,sp,64
 ab2:	8082                	ret
 ab4:	7902                	ld	s2,32(sp)
 ab6:	6a42                	ld	s4,16(sp)
 ab8:	6aa2                	ld	s5,8(sp)
 aba:	6b02                	ld	s6,0(sp)
 abc:	b7f5                	j	aa8 <malloc+0xea>

0000000000000abe <ithread_exit>:
  free(stacks);
  stacks = new_stacks;
  return 0;
}

void ithread_exit(uint64 status) {
 abe:	1141                	addi	sp,sp,-16
 ac0:	e406                	sd	ra,8(sp)
 ac2:	e022                	sd	s0,0(sp)
 ac4:	0800                	addi	s0,sp,16
  thread_exit(status);
 ac6:	2501                	sext.w	a0,a0
 ac8:	00000097          	auipc	ra,0x0
 acc:	b20080e7          	jalr	-1248(ra) # 5e8 <thread_exit>
}
 ad0:	60a2                	ld	ra,8(sp)
 ad2:	6402                	ld	s0,0(sp)
 ad4:	0141                	addi	sp,sp,16
 ad6:	8082                	ret

0000000000000ad8 <free_stacks>:
int free_stacks() {
 ad8:	7179                	addi	sp,sp,-48
 ada:	f406                	sd	ra,40(sp)
 adc:	f022                	sd	s0,32(sp)
 ade:	ec26                	sd	s1,24(sp)
 ae0:	1800                	addi	s0,sp,48
  for (int i = 0; i < num_threads; i++) {
 ae2:	00000797          	auipc	a5,0x0
 ae6:	53e7a783          	lw	a5,1342(a5) # 1020 <num_threads>
 aea:	04f05063          	blez	a5,b2a <free_stacks+0x52>
 aee:	e84a                	sd	s2,16(sp)
 af0:	e44e                	sd	s3,8(sp)
 af2:	4481                	li	s1,0
    free(stacks[i]);
 af4:	00000997          	auipc	s3,0x0
 af8:	52498993          	addi	s3,s3,1316 # 1018 <stacks>
  for (int i = 0; i < num_threads; i++) {
 afc:	00000917          	auipc	s2,0x0
 b00:	52490913          	addi	s2,s2,1316 # 1020 <num_threads>
    free(stacks[i]);
 b04:	0009b783          	ld	a5,0(s3)
 b08:	00349713          	slli	a4,s1,0x3
 b0c:	97ba                	add	a5,a5,a4
 b0e:	6388                	ld	a0,0(a5)
 b10:	00000097          	auipc	ra,0x0
 b14:	e2c080e7          	jalr	-468(ra) # 93c <free>
  for (int i = 0; i < num_threads; i++) {
 b18:	0485                	addi	s1,s1,1
 b1a:	00092703          	lw	a4,0(s2)
 b1e:	0004879b          	sext.w	a5,s1
 b22:	fee7c1e3          	blt	a5,a4,b04 <free_stacks+0x2c>
 b26:	6942                	ld	s2,16(sp)
 b28:	69a2                	ld	s3,8(sp)
  free(stacks);
 b2a:	00000497          	auipc	s1,0x0
 b2e:	4ee48493          	addi	s1,s1,1262 # 1018 <stacks>
 b32:	6088                	ld	a0,0(s1)
 b34:	00000097          	auipc	ra,0x0
 b38:	e08080e7          	jalr	-504(ra) # 93c <free>
  stacks = 0;
 b3c:	0004b023          	sd	zero,0(s1)
  num_threads = 0;
 b40:	00000797          	auipc	a5,0x0
 b44:	4e07a023          	sw	zero,1248(a5) # 1020 <num_threads>
  max_stacks = INIT_MAX_STACKS;
 b48:	47a1                	li	a5,8
 b4a:	00000717          	auipc	a4,0x0
 b4e:	4af72b23          	sw	a5,1206(a4) # 1000 <max_stacks>
  threads_done = 0;
 b52:	00000797          	auipc	a5,0x0
 b56:	4c07a923          	sw	zero,1234(a5) # 1024 <threads_done>
}
 b5a:	4501                	li	a0,0
 b5c:	70a2                	ld	ra,40(sp)
 b5e:	7402                	ld	s0,32(sp)
 b60:	64e2                	ld	s1,24(sp)
 b62:	6145                	addi	sp,sp,48
 b64:	8082                	ret

0000000000000b66 <expand_num_threads>:
int expand_num_threads() {
 b66:	1101                	addi	sp,sp,-32
 b68:	ec06                	sd	ra,24(sp)
 b6a:	e822                	sd	s0,16(sp)
 b6c:	e426                	sd	s1,8(sp)
 b6e:	e04a                	sd	s2,0(sp)
 b70:	1000                	addi	s0,sp,32
  max_stacks *= 2;
 b72:	00000797          	auipc	a5,0x0
 b76:	48e78793          	addi	a5,a5,1166 # 1000 <max_stacks>
 b7a:	4388                	lw	a0,0(a5)
 b7c:	0015151b          	slliw	a0,a0,0x1
 b80:	c388                	sw	a0,0(a5)
  void **new_stacks = malloc(max_stacks*sizeof(char*));
 b82:	0035151b          	slliw	a0,a0,0x3
 b86:	00000097          	auipc	ra,0x0
 b8a:	e38080e7          	jalr	-456(ra) # 9be <malloc>
 b8e:	892a                	mv	s2,a0
  memmove(new_stacks, stacks, num_threads*sizeof(char*));
 b90:	00000617          	auipc	a2,0x0
 b94:	49062603          	lw	a2,1168(a2) # 1020 <num_threads>
 b98:	00000497          	auipc	s1,0x0
 b9c:	48048493          	addi	s1,s1,1152 # 1018 <stacks>
 ba0:	0036161b          	slliw	a2,a2,0x3
 ba4:	608c                	ld	a1,0(s1)
 ba6:	00000097          	auipc	ra,0x0
 baa:	8d8080e7          	jalr	-1832(ra) # 47e <memmove>
  free(stacks);
 bae:	6088                	ld	a0,0(s1)
 bb0:	00000097          	auipc	ra,0x0
 bb4:	d8c080e7          	jalr	-628(ra) # 93c <free>
  stacks = new_stacks;
 bb8:	0124b023          	sd	s2,0(s1)
}
 bbc:	4501                	li	a0,0
 bbe:	60e2                	ld	ra,24(sp)
 bc0:	6442                	ld	s0,16(sp)
 bc2:	64a2                	ld	s1,8(sp)
 bc4:	6902                	ld	s2,0(sp)
 bc6:	6105                	addi	sp,sp,32
 bc8:	8082                	ret

0000000000000bca <ithread_create>:

int ithread_create(void* (*fn_ptr)(void *), void *args) {
 bca:	7179                	addi	sp,sp,-48
 bcc:	f406                	sd	ra,40(sp)
 bce:	f022                	sd	s0,32(sp)
 bd0:	e84a                	sd	s2,16(sp)
 bd2:	e44e                	sd	s3,8(sp)
 bd4:	1800                	addi	s0,sp,48
 bd6:	892a                	mv	s2,a0
 bd8:	89ae                	mv	s3,a1
  if (stacks == 0) {
 bda:	00000797          	auipc	a5,0x0
 bde:	43e7b783          	ld	a5,1086(a5) # 1018 <stacks>
 be2:	c3d9                	beqz	a5,c68 <ithread_create+0x9e>
    stacks = malloc(max_stacks*sizeof(char*));
  }
  if (num_threads == max_stacks) {
 be4:	00000797          	auipc	a5,0x0
 be8:	41c7a783          	lw	a5,1052(a5) # 1000 <max_stacks>
 bec:	00000717          	auipc	a4,0x0
 bf0:	43472703          	lw	a4,1076(a4) # 1020 <num_threads>
 bf4:	0af71363          	bne	a4,a5,c9a <ithread_create+0xd0>
    if (max_stacks == MAX_THREADS) {
 bf8:	04000713          	li	a4,64
 bfc:	08e78563          	beq	a5,a4,c86 <ithread_create+0xbc>
 c00:	ec26                	sd	s1,24(sp)
      printf("ERROR: Thread capacity has been reached\n");
      return -1;
    }
    expand_num_threads();
 c02:	00000097          	auipc	ra,0x0
 c06:	f64080e7          	jalr	-156(ra) # b66 <expand_num_threads>
  }

  void *stack_ptr = malloc(PGSIZE);
 c0a:	6505                	lui	a0,0x1
 c0c:	00000097          	auipc	ra,0x0
 c10:	db2080e7          	jalr	-590(ra) # 9be <malloc>
 c14:	84aa                	mv	s1,a0
  stacks[num_threads] = stack_ptr;
 c16:	00000717          	auipc	a4,0x0
 c1a:	40a72703          	lw	a4,1034(a4) # 1020 <num_threads>
 c1e:	070e                	slli	a4,a4,0x3
 c20:	00000797          	auipc	a5,0x0
 c24:	3f87b783          	ld	a5,1016(a5) # 1018 <stacks>
 c28:	97ba                	add	a5,a5,a4
 c2a:	e388                	sd	a0,0(a5)
  int res = create_thread(fn_ptr, args, stack_ptr, &ithread_exit);
 c2c:	00000697          	auipc	a3,0x0
 c30:	e9268693          	addi	a3,a3,-366 # abe <ithread_exit>
 c34:	862a                	mv	a2,a0
 c36:	85ce                	mv	a1,s3
 c38:	854a                	mv	a0,s2
 c3a:	00000097          	auipc	ra,0x0
 c3e:	99e080e7          	jalr	-1634(ra) # 5d8 <create_thread>
 c42:	892a                	mv	s2,a0
  if (res != -1) {
 c44:	57fd                	li	a5,-1
 c46:	04f50c63          	beq	a0,a5,c9e <ithread_create+0xd4>
    num_threads++;
 c4a:	00000717          	auipc	a4,0x0
 c4e:	3d670713          	addi	a4,a4,982 # 1020 <num_threads>
 c52:	431c                	lw	a5,0(a4)
 c54:	2785                	addiw	a5,a5,1
 c56:	c31c                	sw	a5,0(a4)
 c58:	64e2                	ld	s1,24(sp)
  } else {
    free(stack_ptr);
    stacks[num_threads] = 0;
  }
  return res;
}
 c5a:	854a                	mv	a0,s2
 c5c:	70a2                	ld	ra,40(sp)
 c5e:	7402                	ld	s0,32(sp)
 c60:	6942                	ld	s2,16(sp)
 c62:	69a2                	ld	s3,8(sp)
 c64:	6145                	addi	sp,sp,48
 c66:	8082                	ret
    stacks = malloc(max_stacks*sizeof(char*));
 c68:	00000517          	auipc	a0,0x0
 c6c:	39852503          	lw	a0,920(a0) # 1000 <max_stacks>
 c70:	0035151b          	slliw	a0,a0,0x3
 c74:	00000097          	auipc	ra,0x0
 c78:	d4a080e7          	jalr	-694(ra) # 9be <malloc>
 c7c:	00000797          	auipc	a5,0x0
 c80:	38a7be23          	sd	a0,924(a5) # 1018 <stacks>
 c84:	b785                	j	be4 <ithread_create+0x1a>
      printf("ERROR: Thread capacity has been reached\n");
 c86:	00000517          	auipc	a0,0x0
 c8a:	0ca50513          	addi	a0,a0,202 # d50 <ithread_join+0x8c>
 c8e:	00000097          	auipc	ra,0x0
 c92:	c78080e7          	jalr	-904(ra) # 906 <printf>
      return -1;
 c96:	597d                	li	s2,-1
 c98:	b7c9                	j	c5a <ithread_create+0x90>
 c9a:	ec26                	sd	s1,24(sp)
 c9c:	b7bd                	j	c0a <ithread_create+0x40>
    free(stack_ptr);
 c9e:	8526                	mv	a0,s1
 ca0:	00000097          	auipc	ra,0x0
 ca4:	c9c080e7          	jalr	-868(ra) # 93c <free>
    stacks[num_threads] = 0;
 ca8:	00000717          	auipc	a4,0x0
 cac:	37872703          	lw	a4,888(a4) # 1020 <num_threads>
 cb0:	070e                	slli	a4,a4,0x3
 cb2:	00000797          	auipc	a5,0x0
 cb6:	3667b783          	ld	a5,870(a5) # 1018 <stacks>
 cba:	97ba                	add	a5,a5,a4
 cbc:	0007b023          	sd	zero,0(a5)
 cc0:	64e2                	ld	s1,24(sp)
 cc2:	bf61                	j	c5a <ithread_create+0x90>

0000000000000cc4 <ithread_join>:

int ithread_join(int thread_id) {
 cc4:	1101                	addi	sp,sp,-32
 cc6:	ec06                	sd	ra,24(sp)
 cc8:	e822                	sd	s0,16(sp)
 cca:	1000                	addi	s0,sp,32
  int status;
  join_thread(thread_id, (uint64)&status);
 ccc:	ff040793          	addi	a5,s0,-16
 cd0:	ffc7859b          	addiw	a1,a5,-4
 cd4:	00000097          	auipc	ra,0x0
 cd8:	90c080e7          	jalr	-1780(ra) # 5e0 <join_thread>
  threads_done++;
 cdc:	00000717          	auipc	a4,0x0
 ce0:	34870713          	addi	a4,a4,840 # 1024 <threads_done>
 ce4:	431c                	lw	a5,0(a4)
 ce6:	2785                	addiw	a5,a5,1
 ce8:	0007869b          	sext.w	a3,a5
 cec:	c31c                	sw	a5,0(a4)
  if (threads_done == num_threads) {
 cee:	00000797          	auipc	a5,0x0
 cf2:	3327a783          	lw	a5,818(a5) # 1020 <num_threads>
 cf6:	00d78863          	beq	a5,a3,d06 <ithread_join+0x42>
    free_stacks();
  }
  return status;
}
 cfa:	fec42503          	lw	a0,-20(s0)
 cfe:	60e2                	ld	ra,24(sp)
 d00:	6442                	ld	s0,16(sp)
 d02:	6105                	addi	sp,sp,32
 d04:	8082                	ret
    free_stacks();
 d06:	00000097          	auipc	ra,0x0
 d0a:	dd2080e7          	jalr	-558(ra) # ad8 <free_stacks>
 d0e:	b7f5                	j	cfa <ithread_join+0x36>
