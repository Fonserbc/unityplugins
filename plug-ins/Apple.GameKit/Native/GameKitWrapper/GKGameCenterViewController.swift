//
//  GKGameCenterViewController.swift
//  GameKitWrapper
//
//  Copyright © 2021 Apple, Inc. All rights reserved.
//

import Foundation
import GameKit

var _currentPresentingGameCenterDelegate : GameKitUIDelegateHandler? = GameKitUIDelegateHandler();

@_cdecl("GKGameCenterViewController_Free")
public func GKGameCenterViewController_Free
(
    pointer: UnsafeMutableRawPointer
)
{
    _ =  Unmanaged<GKGameCenterViewController>.fromOpaque(pointer).autorelease();
}

@_cdecl("GKGameCenterViewController_InitWithState")
public func GKGameCenterViewController_InitWithState
(
    state: Int
) -> UnsafeMutableRawPointer
{
    let target = GKGameCenterViewController.init(state: GKGameCenterViewControllerState.init(rawValue: state)!);
    target.gameCenterDelegate = _currentPresentingGameCenterDelegate;
    return Unmanaged.passRetained(target).toOpaque();
}

@_cdecl("GKGameCenterViewController_InitWithLeaderboard")
public func GKGameCenterViewController_InitWithLeaderboard
(
    leaderboardPtr: UnsafeMutableRawPointer,
    playerScope: Int,
    timeScope: Int
) -> UnsafeMutableRawPointer
{
    let leaderboard = Unmanaged<GKLeaderboard>.fromOpaque(leaderboardPtr).takeUnretainedValue();
    let target = GKGameCenterViewController.init(
        leaderboardID: leaderboard.baseLeaderboardID,
        playerScope: GKLeaderboard.PlayerScope.init(rawValue: playerScope)!,
        timeScope: GKLeaderboard.TimeScope.init(rawValue: timeScope)!);
    target.gameCenterDelegate = _currentPresentingGameCenterDelegate;
    
    return Unmanaged.passRetained(target).toOpaque();
    
}

@_cdecl("GKGameCenterViewController_InitWithAchievement")
public func GKGameCenterViewController_InitWithAchievement
(
    achievementPtr: UnsafeMutableRawPointer
) -> UnsafeMutableRawPointer
{
    let achievement = Unmanaged<GKAchievement>.fromOpaque(achievementPtr).takeUnretainedValue();
    let target = GKGameCenterViewController.init(achievementID: achievement.identifier);
    target.gameCenterDelegate = _currentPresentingGameCenterDelegate;
    
    return Unmanaged.passRetained(target).toOpaque();
    
}

@_cdecl("GKGameCenterViewController_Present")
public func GKGameCenterViewController_Present
(
    pointer: UnsafeMutableRawPointer,
    taskId: Int64,
    onSuccess: @escaping SuccessTaskCallback
)
{
    let target = Unmanaged<GKGameCenterViewController>.fromOpaque(pointer).takeUnretainedValue();
    _currentPresentingGameCenterDelegate?.set(taskId: taskId, onSuccess: onSuccess);
    
#if os(iOS) || os(tvOS)
    let viewController = UIApplication.shared.windows.first!.rootViewController;
    viewController?.present(target, animated: true);
#else
    GKDialogController.shared().parentWindow = NSApplication.shared.keyWindow;
    GKDialogController.shared().present(target);
#endif
}
