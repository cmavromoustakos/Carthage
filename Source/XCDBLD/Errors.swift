//
//  Errors.swift
//  Carthage
//
//  Created by Justin Spahr-Summers on 2014-10-24.
//  Copyright (c) 2014 Carthage. All rights reserved.
//

import Foundation
#if swift(>=3)
	import ReactiveSwift
#else
	import ReactiveCocoa
#endif
import ReactiveTask

/// Possible errors that can originate from Carthage.
public enum Error: ErrorType, Equatable {
	/// One or more arguments was invalid.
	case invalidArgument(description: String)
	
	/// `xcodebuild` did not return a build setting that we needed.
	case missingBuildSetting(String)
	
	/// Failed to read a file or directory at the given URL.
	case readFailed(URL, NSError?)
	
	/// Failed to write a file or directory at the given URL.
	case writeFailed(URL, NSError?)
	
	/// An error occurred parsing a Carthage file.
	case parseError(description: String)
	
	// An expected environment variable wasn't found.
	case missingEnvironmentVariable(variable: String)
	
	// An error occurred reading a framework's architectures.
	case invalidArchitectures(description: String)
	
	// An error occurred reading a dSYM or framework's UUIDs.
	case invalidUUIDs(description: String)
	
	/// Timeout whilst running `xcodebuild`
	case xcodebuildTimeout(ProjectLocator)
	
	case buildFailed(TaskError, log: URL?)
	
	/// An error occurred while shelling out.
	case taskError(TaskError)
}

public func == (lhs: Error, rhs: Error) -> Bool {
	switch (lhs, rhs) {
	case let (.invalidArgument(left), .invalidArgument(right)):
		return left == right
		
	case let (.missingBuildSetting(left), .missingBuildSetting(right)):
		return left == right
		
	case let (.readFailed(la, lb), .readFailed(ra, rb)):
		return la == ra && lb == rb
		
	case let (.writeFailed(la, lb), .writeFailed(ra, rb)):
		return la == ra && lb == rb
		
	case let (.parseError(left), .parseError(right)):
		return left == right
		
	case let (.missingEnvironmentVariable(left), .missingEnvironmentVariable(right)):
		return left == right
		
	case let (.invalidArchitectures(left), .invalidArchitectures(right)):
		return left == right
		
	case let (.buildFailed(la, lb), .buildFailed(ra, rb)):
		return la == ra && lb == rb
		
	case let (.taskError(left), .taskError(right)):
		return left == right
		
	default:
		return false
	}
}

extension Error: CustomStringConvertible {
	public var description: String {
		switch self {
		case let .invalidArgument(description):
			return description
			
		case let .missingBuildSetting(setting):
			return "xcodebuild did not return a value for build setting \(setting)"
			
		case let .readFailed(fileURL, underlyingError):
			var description = "Failed to read file or folder at \(fileURL.carthage_path)"
			
			if let underlyingError = underlyingError {
				description += ": \(underlyingError)"
			}
			
			return description
			
		case let .writeFailed(fileURL, underlyingError):
			var description = "Failed to write to \(fileURL.carthage_path)"
			
			if let underlyingError = underlyingError {
				description += ": \(underlyingError)"
			}
			
			return description
			
		case let .parseError(description):
			return "Parse error: \(description)"
			
		case let .invalidArchitectures(description):
			return "Invalid architecture: \(description)"
			
		case let .invalidUUIDs(description):
			return "Invalid architecture UUIDs: \(description)"
			
		case let .missingEnvironmentVariable(variable):
			return "Environment variable not set: \(variable)"
			
		case let .xcodebuildTimeout(project):
			return "xcodebuild timed out while trying to read \(project) 😭"
			
		case let .buildFailed(taskError, log):
			var message = "Build Failed\n"
			if case let .ShellTaskFailed(task, exitCode, _) = taskError {
				message += "\tTask failed with exit code \(exitCode):\n"
				message += "\t\(task)\n"
			} else {
				message += "\t" + taskError.description + "\n"
			}
			message += "\nThis usually indicates that project itself failed to compile."
			if let log = log {
				message += " Please check the xcodebuild log for more details: \(log.carthage_path)"
			}
			return message
			
		case let .taskError(taskError):
			return taskError.description
		}
	}
}
