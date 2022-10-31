/* SnakeAndLadderGame
 * Author: USER
 * Creation date: 1/29/2022
 */
MACHINE
    SnakeAndLadderGame

SETS
    RESPONSE = {SUCCESSFULLY_VISITED, SUCCESSFULLY_MOVED, ROLL_AGAIN, CLIMB, FALL, FINISHED,SNAKES_ENCOUNTERED,LADDERS_ENCOUNTERED}
    
CONSTANTS
    path, diceHomeBase, initialPoint, destination, ladder, snake
    
PROPERTIES
    path = 0..100 &
    diceHomeBase = 1..6 &
    initialPoint : NAT & initialPoint = 0 &
    destination = 100 &
    ladder = {(3 |-> 39),(10 |-> 12),(27 |-> 53),(56 |-> 84),(61 |-> 99),(74 |-> 90)} &
    snake = {(16 |-> 13),(31 |-> 4),(47 |-> 25),(63 |-> 60),(66 |-> 52),(97 |-> 75)} 
    
VARIABLES
    currentPosition,laddersEncountered, snakesEncountered, routeUse, numberOfTurns
    
INVARIANT
    currentPosition : path & currentPosition >= 0 & currentPosition <= 100 &
    laddersEncountered : NAT &
    snakesEncountered : NAT &
    numberOfTurns : NAT &
    routeUse : seq(path) 
    
INITIALISATION
    numberOfTurns := 0||
    laddersEncountered := 0 ||
    snakesEncountered := 0 ||
    currentPosition := 0 ||
    routeUse := []
    
OPERATIONS
    response <-- Move(dice) =
    PRE
         dice: 1..6 & dice >=1 & dice <= 6 & currentPosition >= 0 & currentPosition <= 100 
    THEN
        IF (currentPosition + dice = 100)
        THEN
            currentPosition := (currentPosition + dice) ||
            response := FINISHED
                                              
        ELSIF ((currentPosition + dice) : dom(ladder))
        THEN
            currentPosition := ladder(currentPosition + dice) ||
            numberOfTurns := numberOfTurns + 1 ||
            response := CLIMB 
            
        ELSIF ((currentPosition + dice) : dom(snake))
        THEN
            currentPosition := snake(currentPosition + dice) ||
            numberOfTurns := numberOfTurns + 1 ||
            response := FALL
            
        ELSIF ((currentPosition + dice) < destination)
        THEN
            currentPosition := (currentPosition + dice) ||
            numberOfTurns := numberOfTurns + 1 ||
            response := SUCCESSFULLY_MOVED
            
        ELSIF((currentPosition + dice) > destination)
        THEN
            response := ROLL_AGAIN
        END
    END;
    
    response <-- GameStatistics(dice) =
    PRE
         dice: 1..6 & dice >=1 & dice <= 6 & currentPosition >= 0 & currentPosition <= 100 & numberOfTurns >= 0
    THEN
        IF(currentPosition + dice = 100)
        THEN
            currentPosition := (currentPosition + dice) ||
            response := FINISHED
            
        ELSIF ((currentPosition + dice) : dom(ladder))
        THEN
            currentPosition := ladder(currentPosition + dice) ||
            laddersEncountered :=  laddersEncountered + 1 ||
            numberOfTurns := numberOfTurns + 1 ||
            response := LADDERS_ENCOUNTERED 
            
       ELSIF ((currentPosition + dice) : dom(snake))
        THEN
            currentPosition := snake(currentPosition + dice) ||
            snakesEncountered := snakesEncountered + 1 ||
            numberOfTurns := numberOfTurns + 1 ||
            response := SNAKES_ENCOUNTERED
            
        ELSIF ((currentPosition + dice) < destination)
        THEN
            currentPosition := (currentPosition + dice) ||
            numberOfTurns := numberOfTurns + 1 ||
            response := SUCCESSFULLY_MOVED
            
        ELSIF((currentPosition + dice) > destination)
        THEN
            response := ROLL_AGAIN
        END
    END;
    
    response <-- VisitedSquares(dice) =
    PRE
         dice: 1..6 & dice >=1 & dice <= 6 & currentPosition >= 0 & currentPosition <= 100
    THEN
       IF (currentPosition + dice = 100)
        THEN
            currentPosition := (currentPosition + dice) ||
            routeUse := routeUse <- (currentPosition + dice) ||
            response := FINISHED
        ELSIF ((currentPosition + dice) : dom(ladder))
        THEN
            currentPosition := ladder(currentPosition + dice) ||
            routeUse := routeUse <- ladder(currentPosition + dice) ||
            response := CLIMB 
            
        ELSIF ((currentPosition + dice) : dom(snake))
        THEN
            currentPosition := snake(currentPosition + dice) ||
            routeUse := routeUse <- snake(currentPosition + dice) ||
            response := FALL
            
        ELSIF ((currentPosition + dice) < destination)
        THEN
            currentPosition := (currentPosition + dice) ||
            routeUse := routeUse <- (currentPosition + dice) ||
            response := SUCCESSFULLY_MOVED
        ELSIF((currentPosition + dice) > destination)
        THEN
            response := ROLL_AGAIN
        END
    END;
    
    restartGame =
    BEGIN
        numberOfTurns := 0||
        laddersEncountered := 0 ||
        snakesEncountered := 0 ||
        routeUse := [] ||
        currentPosition := 0       
    END
    
END
