# coding=utf-8
# This is a sample Python script.

# Press ⌃R to execute it or replace it with your code.
# Press Double ⇧ to search everywhere for classes, files, tool windows, actions, and settings.

import glob
import pickle
from selenium import webdriver
from selenium.webdriver.common.action_chains import ActionChains
import time
import numpy as np
import re

test = "1. d4 d5 2. Qd3 Qd6 3. Qf5 Qb4+ 4. Kd1 Qxb2 5. Qxf7+ Kd8 6. Qxf8+ Kd7 7. Qxg8 Qxa1 8. Qxh8 Qxa2 9. Qxh7 Qxb1 10. Qxg7 Qxc2+ 11. Ke1 Qf5 12. Qxe7+ Kc6 13. Qxc7+ Kb5 14. Qxb8 Qxf2+ 15. Kd1 Qxf1+ 16. Kd2 Qxg2 17. Qxa8 Qxh1 18. Qxc8 Qxg1 19. Qxb7+ Kc4 20. Qxa7 Qxh2 21. Qa5 Qh1 22. Ke3 Qxc1+ 23. Kf3 Kxd4 24. Qxd5+ Kxd5 25. Kg4 Qe3 26. Kh4 Qf3 27. e3 Qg2"
movesPgn1 = "1. d4 d5 2. Bf4"
movesPgn2 = "1. d4 Nf6 2. Bf4"
movesPgn3 = "1. d4 e6 2. Bf4"

allPgns = ["1. d4"]

def getRespondingMoveChain(movesPgn):
    timeLimit = 60
    initialTime = time.time()
    emptyList = ['','','','','']

    options = webdriver.ChromeOptions()
    #options.add_experimental_option("detach", True)
    options.headless = True
    driver = webdriver.Chrome(chrome_options=options, executable_path='/Users/willb/PycharmProjects/selen/chromedriver')
    driver.maximize_window()

    # GO TO SITE
    driver.get('https://lichess.org/analysis')

    # TURN ON CLOUD
    cloudButton = driver.find_element_by_xpath('//*[@id="main-wrap"]/main/div[2]/div[1]/div')
    cloudButton.click()

    # CLICKING OPTIONS BUTTON
    optionsButton = driver.find_element_by_css_selector('#main-wrap > main > div.analyse__controls.analyse-controls > button')
    while optionsButton.get_attribute("className") == "fbt":
        ac4 = ActionChains(driver)
        ac4.move_to_element(optionsButton).click().perform()
        ac4.reset_actions()
        if (time.time() - initialTime) > timeLimit:
            driver.get_screenshot_as_file('issue1.png')
            break

    # CLICKING SLIDER
    slider = driver.find_element_by_css_selector('#analyse-multipv')
    # x-offset should be 30 for 3 lines, 50 for 4 lines, 100 for 5 lines
    while driver.find_element_by_xpath('//*[@id="main-wrap"]/main/div[3]/div/div[9]/div').get_property('outerText') != '5 / 5':
        ac5 = ActionChains(driver)
        ac5.move_to_element(slider).move_by_offset(70, 0).click().perform()
        ac5.reset_actions()
        if (time.time() - initialTime) > timeLimit:
            driver.get_screenshot_as_file('issue2.png')
            break

    # CLICKING OPTIONS BUTTON
    while optionsButton.get_attribute("className") == "fbt active":
        ac6 = ActionChains(driver)
        ac6.move_to_element(optionsButton).click().perform()
        ac6.reset_actions()
        if (time.time() - initialTime) > timeLimit:
            driver.get_screenshot_as_file('issue3.png')
            break

    # TYPE IN PGN
    textarea = driver.find_element_by_css_selector('#main-wrap > main > div.analyse__underboard > div > div.pgn > div > textarea')
    textarea.send_keys(movesPgn)

    # CLICK IMPORT PGN
    importButton = driver.find_element_by_css_selector('#main-wrap > main > div.analyse__underboard > div > div.pgn > div > button')
    importButton.click()

    # WAITING FOR DEPTH TO FINALIZE
    while True:
        depthInfo = driver.find_element_by_xpath('/html/body/div[1]/main/div[3]/div[1]/div[2]/span[3]').get_property(
            "outerText")
        if '/' in depthInfo:
            slashLoc = depthInfo.index('/')
            if depthInfo[slashLoc - 2:slashLoc] == depthInfo[slashLoc + 1:slashLoc + 3]:
                break
        else:
            if 'engine' not in depthInfo:
                break
        if (time.time() - initialTime) > (timeLimit*2):
            driver.get_screenshot_as_file('issue4.png')
            break

    # WAITING FOR STOCKFISH TO LOAD AT LEAST TWO MOVES
    result = None
    while result is None:
        try:
            result = driver.find_element_by_css_selector('#main-wrap > main > div.analyse__tools > div.pv_box > div:nth-child(2) > span:nth-child(4)').get_property("outerText")
        except:
            if (time.time() - initialTime) > timeLimit:
                driver.get_screenshot_as_file('issue5.png')
                break

    # WAITING FOR THE GREEN BAR TO FINISH LOADING
    while driver.find_element_by_xpath('//*[@id="main-wrap"]/main/div[3]/div[1]/div[1]').get_property('innerHTML') != "<span style=\"width: 100%\"></span>":
        if (time.time() - initialTime) > timeLimit:
            driver.get_screenshot_as_file('issue6.png')
            break

    # RECORD DATA TO OUTPUT VARIABLES
    try:
        firstOption = driver.find_element_by_css_selector('#main-wrap > main > div.analyse__tools > div.pv_box > div:nth-child(1) > span:nth-child(4)')
        option1 = firstOption.get_property("outerText")
    except:
        option1 = ''
    try:
        secondOption = driver.find_element_by_css_selector('#main-wrap > main > div.analyse__tools > div.pv_box > div:nth-child(2) > span:nth-child(4)')
        option2 = secondOption.get_property("outerText")
    except:
        option2 = ''
    try:
        thirdOption = driver.find_element_by_css_selector('#main-wrap > main > div.analyse__tools > div.pv_box > div:nth-child(3) > span:nth-child(4)')
        option3 = thirdOption.get_property("outerText")
    except:
        option3 = ''
    try:
        fourthOption = driver.find_element_by_css_selector('#main-wrap > main > div.analyse__tools > div.pv_box > div:nth-child(4) > span:nth-child(4)')
        option4 = fourthOption.get_property("outerText")
    except:
        option4 = ''
    try:
        fifthOption = driver.find_element_by_css_selector('#main-wrap > main > div.analyse__tools > div.pv_box > div:nth-child(5) > span:nth-child(4)')
        option5 = fifthOption.get_property("outerText")
    except:
        option5 = ''

    moveList = [option1, option2, option3,option4,option5]
    if '' in moveList:
        driver.get_screenshot_as_file('issue7.png')

    driver.close()

    print(moveList)
    return moveList


# startPgn next move must be black (ex: 1. d4, or 1. d4 d5 2. Bf4)
def runScript(moveNum, startPgn):
    newMoves = getRespondingMoveChain(startPgn)
    newPgns = []
    for move in newMoves:
        pgn = startPgn + " " + move
        newPgns.append(pgn)
    newMovesList = []
    for pgnVal in newPgns:
        moveVals = getRespondingMoveChain(pgnVal)
        newMovesList.append(moveVals)
    bestMoveList = []
    moveNum += 1
    for curMoves in newMovesList:
        bestMoveList.append(" " + str(moveNum) + ". " + curMoves[0])
    newestPgns = np.char.add(newPgns, bestMoveList)
    return newestPgns


def convertPickleToFen(pickleFn, setName):
    f = open(pickleFn, 'rb')
    obj = pickle.load(f)
    f.close()
    lineNum = 0
    for arr in obj:
        for line in obj:
            lineNum += 1
            options = webdriver.ChromeOptions()
            options.headless = True
            driver = webdriver.Chrome(chrome_options=options,
                                      executable_path='/Users/willb/PycharmProjects/selen/chromedriver')
            driver.get('http://www.lutanho.net/pgn/pgn2fen.html')
            inVal = driver.find_element_by_name("pgn")
            button = driver.find_element_by_xpath("/html/body/form/input[2]")
            outVal = driver.find_element_by_name("fen")
            inVal.send_keys(line)
            button.click()
            time.sleep(0.5)
            outText = outVal.get_attribute("value")
            driver.close()
            with open('/Users/willb/PycharmProjects/selen2/Output/' + setName + '_output' + str(lineNum) + '.txt', 'w') as f2:
                f2.write(outText)

def printFilesinDirectory():
    g = glob.glob("/Users/willb/Documents/C++/Chess3/Chess/FenFiles/London_Depth5/*.txt")
    fnList = []
    for fn in g:
        fn = str(fn)
        fn = fn[fn.index("Chess/")+len("Chess/"):]
        fn = fn[:-4]
        fnList.append(fn)
    fnList.sort(key=natural_keys)
    for fn in fnList:
        #fn = fn.replace('Depth5', 'Depth6')
        print('"' + fn + '",')

def atoi(text):
    return int(text) if text.isdigit() else text

def natural_keys(text):
    return [ atoi(c) for c in re.split(r'(\d+)', text) ]




if __name__ == '__main__':
    startTime = time.time()
    pgnListLists1 = []
    pgnListLists2 = []
    pgnListLists3 = []
    pgnListLists4 = []

    initialPgn = "1. d4 d5 2. Bf4"
    moveNumber = 2
    firstPgnList = runScript(moveNumber, initialPgn) # size of 5, takes 26 seconds

    moveNumber += 1
    for pgn in firstPgnList:
        secondPgnList = runScript(moveNumber, pgn)
        pgnListLists1.append(secondPgnList) # [[pgn1, pgn2, ...],[pgn1,pgn2,...]] size of 25

    moveNumber += 1
    count = 1
    for eachPgnList in pgnListLists1:
        for pgn in eachPgnList:
            thirdPgnList = runScript(moveNumber, pgn)
            pgnListLists2.append(thirdPgnList) # takes 14.4 mins to run for 5
            print(count)
            count += 1

    """
    moveNumber += 1
    for eachPgnList in pgnListLists2:
        for pgn in eachPgnList:
            fourthPgnList = runScript(moveNumber, pgn)
            pgnListLists3.append(fourthPgnList) # takes 22.5 mins to run for 3, creates 81 move lines for 3

    moveNumber += 1
    count = 0
    for eachPgnList in pgnListLists3:
        for pgn in eachPgnList:
            fifthPgnList = runScript(moveNumber, pgn)
            pgnListLists4.append(fifthPgnList)
            count += 1
            print(count)
    """

    print("-------------DONEEEEEE-------------------")

    executionTime = (time.time() - startTime)
    print("--------Runtime in seconds:-------------")
    print(executionTime)

    # save variables
    h = open('firstPgnList.pckl', 'wb')
    pickle.dump(firstPgnList, h)
    h.close()
    print("-------------firstPgnList:-------------")
    print(firstPgnList)

    g = open('pgnListLists1.pckl', 'wb')
    pickle.dump(pgnListLists1, g)
    g.close()
    print("-------------pgnListLists1:-------------")
    print(pgnListLists1)

    f = open('pgnListLists2.pckl', 'wb')
    pickle.dump(pgnListLists2, f)
    f.close()
    print("--------------pgnListLists2:---------------")
    print(pgnListLists2)

    e = open('pgnListLists3.pckl', 'wb')
    pickle.dump(pgnListLists3, e)
    e.close()
    print("--------------pgnListLists3:---------------")
    print(pgnListLists3)

    d = open('pgnListLists4.pckl', 'wb')
    pickle.dump(pgnListLists4, d)
    d.close()
    print("--------------pgnListLists4:---------------")
    print(pgnListLists4)

    convertPickleToFen('firstPgnList.pckl', 'London_d4d5Bf4_Depth3_RM5')
    time.sleep(3)
    convertPickleToFen('pgnListLists1.pckl', 'London_d4d5Bf4_Depth4_RM5')
    time.sleep(3)
    convertPickleToFen('pgnListLists2.pckl', 'London_d4d5Bf4_Depth5_RM5')
    # RM = number of responding moves

    """





    
    import pickle

f = open('store.pckl', 'wb')
pickle.dump(obj, f)
f.close()

f = open('store.pckl', 'rb')
obj = pickle.load(f)
f.close()
    
        a = 0
    startTime = time.time()

    while a < 10:
        print(getRespondingMoveChain(movesPgn1))
        a+=1
    executionTime = (time.time() - startTime)
    print(executionTime)
    
    
    
    moveNumber = 2
    newPgns = runScript(moveNumber, movesPgn1)
    moveNumber += 1
    allPgns = []
    for pgn in newPgns:
        newerPgns = runScript(moveNumber, pgn)
        allPgns.append(newerPgns)  # provides [['1. d4 d5 2. Bf4 c5 3. e3 cxd4 4. exd4','1. d4 d5 2. Bf4 c5 3. e3 Nf6 4. Nf3'],[...],...]

    
    moveNumber += 1
    morePgns = []
    for pgnList in allPgns:
        for pgn in pgnList:
            newerPgns = runScript(moveNumber, pgn)
            morePgns.append(newerPgns) # provides 5.

    
    moveNumber += 1
    allNewPgns = []
    for pgn in morePgns:
        newerPgns = runScript(moveNumber, pgn)
        allNewPgns.append(newerPgns) # provides 6.


    moveNumber += 1
    allNewPgns1 = []
    for pgn in allNewPgns:
        newerPgns = runScript(moveNumber, pgn)
        allNewPgns1.append(newerPgns)  # provides 7.

    moveNumber += 1
    allNewPgns2 = []
    for pgn in allNewPgns1:
        newerPgns = runScript(moveNumber, pgn)
        allNewPgns2.append(newerPgns)  # provides 8.

    moveNumber += 1
    allNewPgns3 = []
    for pgn in allNewPgns2:
        newerPgns = runScript(moveNumber, pgn)
        allNewPgns3.append(newerPgns)  # provides 9.

    moveNumber += 1
    allNewPgns4 = []
    for pgn in allNewPgns3:
        newerPgns = runScript(moveNumber, pgn)
        allNewPgns4.append(newerPgns)  # provides 10.

    print(allNewPgns4)

    """